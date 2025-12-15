import 'package:cm_app/app/core/models/movie.dart';
import 'package:cm_app/app/core/services/movie_recent_services.dart';
import 'package:cm_app/app/ui/details/movie_detail_screen.dart';
import 'package:cm_app/app/ui/details/series_detail_screen.dart';
import 'package:flutter/material.dart';

void goRoute(
  BuildContext context, {
  required Widget Function(BuildContext context) builder,
}) {
  Navigator.push(context, MaterialPageRoute(builder: builder));
}

void goMovieDetailScreen(BuildContext context, {required Movie movie}) {
  // add recent
  MovieRecentServices.addRecent(movie);

  if (movie.type == MovieTypes.tvShow) {
    goRoute(context, builder: (context) => SeriesDetailScreen(movie: movie));
  } else {
    goRoute(context, builder: (context) => MovieDetailScreen(movie: movie));
  }
}
