import 'dart:convert';

import 'package:cm_app/core/models/movie.dart';
import 'package:cm_app/core/models/movie_detail.dart';
import 'package:cm_app/core/models/tv_show_detail.dart';
import 'package:cm_app/core/utils/api_utils.dart';
import 'package:cm_app/ui/platforms/components/api_content_fetcher_dialog.dart';
import 'package:cm_app/ui/platforms/components/dialog/error_alert_dialog.dart';
import 'package:cm_app/ui/platforms/pages/movie_detail_page.dart';
import 'package:cm_app/ui/platforms/pages/tv_show_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';

Future<void> goMovieDetail(
  BuildContext context, {
  required MediaItem item,
}) async {
  if (item.type == .movie) {
    final url = ApiUtils.getAutoForwardProxyUrl(
      '${ApiUtils.currentApiUrl}/movies/${item.slug}',
    );
    print(url);
    final content = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => ApiContentFetcherDialog(url: url),
    );
    if (content == null) return;
    if (!context.mounted) return;

    try {
      final json = jsonDecode(content);
      print(json);

      final detail = MovieDetail.fromMap(json['data']);
      context.pushMaterialPageRoute(
        builder: (mainCtx) => MovieDetailPage(movie: detail),
      );
    } catch (e) {
      showErrorDialog(context, e.toString());
    }
    return;
  }
  if (item.type == .tvShow) {
    final url = ApiUtils.getAutoForwardProxyUrl(
      '${ApiUtils.currentApiUrl}/tv-shows/${item.slug}',
    );
    print(url);
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
