import 'dart:convert';

import 'package:cm_app/core/models/movie.dart';
import 'package:cm_app/core/models/movie_detail.dart';
import 'package:cm_app/core/models/tv_show.dart';
import 'package:cm_app/core/models/tv_show_detail.dart';
import 'package:cm_app/core/utils/api_utils.dart';
import 'package:cm_app/ui/platforms/components/api_content_fetcher_dialog.dart';
import 'package:cm_app/ui/platforms/components/dialog/error_alert_dialog.dart';
import 'package:cm_app/ui/platforms/pages/movie_detail_page.dart';
import 'package:cm_app/ui/platforms/pages/movies_page.dart';
import 'package:cm_app/ui/platforms/pages/tv_show_detail_page.dart';
import 'package:cm_app/ui/platforms/pages/tv_shows_page.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';

Future<void> goMoviePage(BuildContext context) async {
  context.pushMaterialPageRoute(builder: (mainCtx) => MoviesPage());
}

Future<void> goTvShowPage(BuildContext context) async {
  context.pushMaterialPageRoute(builder: (mainCtx) => TvShowsPage());
}

Future<void> goMovieDetail(
  BuildContext context, {
  required MediaItem item,
}) async {
  if (item.type == .movie) {
    final url = ApiUtils.getAutoForwardProxyUrl(
      '${ApiUtils.currentApiUrl(useYsflix: item.ysflix == 1)}/api/movies/${item.slug}',
    );
    final content = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => ApiContentFetcherDialog(url: url),
    );
    if (content == null) return;
    if (!context.mounted) return;
    // print(':Dev: $content');
    try {
      final json = jsonDecode(content);

      final detail = MovieDetail.fromMap(json['data']);
      context.pushMaterialPageRoute(
        builder: (mainCtx) => MovieDetailPage(movie: detail),
      );
    } catch (e) {
      showErrorDialog(context, '[goMovieDetail]: $e');
    }
    return;
  }
  if (item.type == .tvShow) {
    final url = ApiUtils.getAutoForwardProxyUrl(
      '${ApiUtils.currentApiUrl(useYsflix: item.ysflix == 1)}/api/tv-shows/${item.slug}',
    );
    final content = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => ApiContentFetcherDialog(url: url),
    );
    if (content == null) return;
    if (!context.mounted) return;
    try {
      final json = jsonDecode(content);
      final detail = TvShowDetail.fromMap(json['data']);
      context.pushMaterialPageRoute(
        builder: (mainCtx) => TvShowDetailPage(tvShow: detail),
      );
    } catch (e) {
      showErrorDialog(context, e.toString());
    }
    return;
  }
}

Future<void> goTvShowDetail(
  BuildContext context, {
  required TvShowItem item,
}) async {
  if (item.type == .tvShow) {
    final url = ApiUtils.getAutoForwardProxyUrl(
      '${ApiUtils.currentApiUrl(useYsflix: item.ysflix == 1)}/api/tv-shows/${item.slug}',
    );
    final content = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => ApiContentFetcherDialog(url: url),
    );
    if (content == null) return;
    if (!context.mounted) return;
    try {
      final json = jsonDecode(content);
      final detail = TvShowDetail.fromMap(json['data']);
      context.pushMaterialPageRoute(
        builder: (mainCtx) => TvShowDetailPage(tvShow: detail),
      );
    } catch (e) {
      showErrorDialog(context, e.toString());
    }
    return;
  }
}
