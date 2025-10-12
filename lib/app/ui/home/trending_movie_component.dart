import 'package:cm_app/app/core/models/movie.dart';
import 'package:cm_app/app/services/movie_services.dart';
import 'package:cm_app/app/ui/components/movie_grid_item.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';

class TrendingMovieComponent extends StatefulWidget {
  final String title;
  final String url;
  final void Function(Movie movie)? onClicked;
  const TrendingMovieComponent({
    super.key,
    required this.title,
    required this.url,
    this.onClicked,
  });

  @override
  State<TrendingMovieComponent> createState() => _TrendingMovieComponentState();
}

class _TrendingMovieComponentState extends State<TrendingMovieComponent> {
  @override
  void initState() {
    super.initState();
    init();
  }

  static List<Movie> list = [];
  bool isLoading = false;

  void init() async {
    try {
      setState(() {
        isLoading = true;
      });
      list = await MovieServices.getMovies(widget.url);
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      showTMessageDialogError(context, 'Error ရှိနေပါတယ်။\n${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: TLoader.random());
    }
    return _getViews();
  }

  Widget _getViews() {
    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title, style: TextStyle(fontSize: 18)),
        Expanded(
          child: ListView.builder(
            itemCount: list.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => _getListItem(list[index]),
          ),
        ),
      ],
    );
  }

  Widget _getListItem(Movie movie) {
    return Container(
      margin: EdgeInsets.only(right: 5),
      child: SizedBox(
        width: 120,
        height: 130,
        child: MovieGridItem(movie: movie, onClicked: widget.onClicked),
      ),
    );
  }
}
