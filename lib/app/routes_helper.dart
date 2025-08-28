import 'package:cm_app/app/models/movie.dart';
import 'package:cm_app/app/screens/content/html_fetcher_dialog.dart';
import 'package:cm_app/app/screens/content/movie/movie_content_page.dart';
import 'package:cm_app/app/screens/content/series/series_content_page.dart';
import 'package:flutter/material.dart';

void goMovieContent(BuildContext context, {required Movie movie}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => HtmlFetcherDialog(
      movie: movie,
      onMovieFetched: (htmlContent) {
        goRoute(
          context,
          builder: (context) =>
              MovieContentPage(htmlContent: htmlContent, movie: movie),
        );
      },
      onSeriesFetched: (htmlContent) {
        goRoute(
          context,
          builder: (context) =>
              SeriesContentPage(htmlContent: htmlContent, movie: movie),
        );
      },
    ),
  );
}

void goRoute(
  BuildContext context, {
  required Widget Function(BuildContext context) builder,
}) {
  Navigator.push(context, MaterialPageRoute(builder: builder));
}
