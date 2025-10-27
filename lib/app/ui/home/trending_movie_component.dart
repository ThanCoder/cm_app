import 'package:cm_app/app/core/models/movie.dart';
import 'package:cm_app/app/services/movie_services.dart';
import 'package:cm_app/app/ui/components/one_line_movie_component.dart';
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
  State<TrendingMovieComponent> createState() => TrendingMovieComponentState();
}

class TrendingMovieComponentState extends State<TrendingMovieComponent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
  }

  List<Movie> list = [];
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
    return OneLineMovieComponent(
      title: widget.title,
      list: list,
      onClicked: widget.onClicked,
    );
  }
}
