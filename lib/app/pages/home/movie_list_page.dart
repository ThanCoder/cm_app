import 'package:cm_app/app/components/movie_see_all_list_view.dart';
import 'package:cm_app/app/screens/content_screens/movie_content_screen.dart';
import 'package:cm_app/app/screens/see_all_movie_screen.dart';
import 'package:cm_app/app/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:cm_app/app/providers/movie_provider.dart';
import 'package:provider/provider.dart';

class MovieListPage extends StatelessWidget {
  const MovieListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MovieProvider>();
    final isLoading = provider.isLoading;
    final list = provider.getList;
    if (isLoading) {
      return TLoader();
    }
    return MovieSeeAllListView(
      title: 'Latest Movie',
      list: list,
      onClicked: (movie) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieContentScreen(movie: movie),
          ),
        );
      },
      onSeeAllClicked: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SeeAllMovieScreen(),
          ),
        );
      },
    );
  }
}
