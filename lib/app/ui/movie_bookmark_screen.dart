import 'package:cm_app/app/core/models/movie.dart';
import 'package:cm_app/app/route_helper.dart';
import 'package:cm_app/app/services/movie_bookmark_services.dart';
import 'package:cm_app/app/ui/components/movie_grid_item.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';

class MovieBookmarkScreen extends StatefulWidget {
  const MovieBookmarkScreen({super.key});

  @override
  State<MovieBookmarkScreen> createState() => _MovieBookmarkScreenState();
}

class _MovieBookmarkScreenState extends State<MovieBookmarkScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  bool isLoading = false;
  List<Movie> list = [];
  void init() async {
    try {
      setState(() {
        isLoading = true;
      });
      list = await MovieBookmarkServices.getDatabase.getAll();

      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      showTMessageDialogError(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Book Mark')),
      body: GridView.builder(
        itemCount: list.length,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 180,
          mainAxisExtent: 220,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
        ),
        itemBuilder: (context, index) => MovieGridItem(
          movie: list[index],
          onClicked: (movie) => goMovieDetailScreen(context, movie: movie),
        ),
      ),
    );
  }
}
