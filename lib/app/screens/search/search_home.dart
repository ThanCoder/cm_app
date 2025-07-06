import 'package:cm_app/app/screens/search/movie_geners_select_all_view.dart';
import 'package:cm_app/app/screens/search/movie_year_select_all_view.dart';
import 'package:cm_app/app/models/movie_genres_model.dart';
import 'package:cm_app/app/models/movie_year_model.dart';
import 'package:cm_app/app/screens/movie_result_screen.dart';
import 'package:flutter/material.dart';

class SearchHome extends StatelessWidget {
  List<MovieYearModel> yearList;
  List<MovieGenresModel> genresList;
  SearchHome({
    super.key,
    required this.yearList,
    required this.genresList,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        //year
        SliverToBoxAdapter(
          child: MovieYearSelectAllView(
            list: yearList,
            onLoaded: (result) {
              yearList = result;
            },
            onClicked: (year) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      MovieResultScreen(title: year.title, url: year.url),
                ),
              );
            },
          ),
        ),
        // genres
        SliverToBoxAdapter(
          child: MovieGenersSelectAllView(
            list: genresList,
            onLoaded: (list) {
              genresList = list;
            },
            onClicked: (genres) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      MovieResultScreen(title: genres.title, url: genres.url),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
