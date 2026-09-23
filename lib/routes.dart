import 'dart:convert';

import 'package:cm_app/core/models/movie.dart';
import 'package:cm_app/core/models/movie_detail.dart';
import 'package:cm_app/core/models/tv_show.dart';
import 'package:cm_app/core/models/tv_show_detail.dart';
import 'package:cm_app/core/utils/api_utils.dart';
import 'package:cm_app/core/utils/cache_utils.dart';
import 'package:cm_app/platforms/components/api_content_fetcher_dialog.dart';
import 'package:cm_app/platforms/components/dialog/error_alert_dialog.dart';
import 'package:cm_app/platforms/pages/movie_detail_page.dart';
import 'package:cm_app/platforms/pages/movies_page.dart';
import 'package:cm_app/platforms/pages/tv_show_detail_page.dart';
import 'package:cm_app/platforms/pages/tv_shows_page.dart';
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
  final id = item.slug;

  if (item.type == .movie) {
    final url = ApiUtils.getAutoForwardProxyUrl(
      '${ApiUtils.currentApiUrl(useYsflix: item.ysflix == 1)}/api/movies/${item.slug}',
    );
    // check cache
    final cached = await CacheUtils.getContent(id);
    if (!context.mounted) return;
    if (cached != null) {
      try {
        final json = jsonDecode(cached);
        final detail = MovieDetail.fromMap(json['data']);
        // go
        context.pushMaterialPageRoute(
          builder: (mainCtx) => MovieDetailPage(
            movie: detail,
            fetchUrl: url,
            contentId: id,
            contentHashId: CacheUtils.getHashId(cached),
          ),
        );
      } catch (e) {
        showErrorDialog(context, '[goMovieDetail]: $e');
      }
      return;
    }

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
      // save cache
      await CacheUtils.setContent(id, content);
      if (!context.mounted) return;
      context.pushMaterialPageRoute(
        builder: (mainCtx) => MovieDetailPage(
          movie: detail,
          fetchUrl: url,
          contentId: id,
          contentHashId: CacheUtils.getHashId(content),
        ),
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
    // check cache
    final cached = await CacheUtils.getContent(id);
    if (!context.mounted) return;
    if (cached != null) {
      try {
        final json = jsonDecode(cached);
        final detail = TvShowDetail.fromMap(json['data']);
        // go
        context.pushMaterialPageRoute(
          builder: (mainCtx) => TvShowDetailPage(
            tvShow: detail,
            fetchUrl: url,
            contentId: id,
            contentHashId: CacheUtils.getHashId(cached),
          ),
        );
      } catch (e) {
        showErrorDialog(context, '[goMovieDetail]: $e');
      }
      return;
    }

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
      // save cache
      await CacheUtils.setContent(id, content);
      if (!context.mounted) return;

      context.pushMaterialPageRoute(
        builder: (mainCtx) => TvShowDetailPage(
          tvShow: detail,
          fetchUrl: url,
          contentId: id,
          contentHashId: CacheUtils.getHashId(content),
        ),
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
  if (item.type != .tvShow) return;

  final url = ApiUtils.getAutoForwardProxyUrl(
    '${ApiUtils.currentApiUrl(useYsflix: item.ysflix == 1)}/api/tv-shows/${item.slug}',
  );

  // check cache
  final id = item.slug;
  final cached = await CacheUtils.getContent(id);
  if (!context.mounted) return;
  if (cached != null) {
    try {
      final json = jsonDecode(cached);
      final detail = TvShowDetail.fromMap(json['data']);
      context.pushMaterialPageRoute(
        builder: (mainCtx) => TvShowDetailPage(
          tvShow: detail,
          fetchUrl: url,
          contentId: id,
          contentHashId: CacheUtils.getHashId(cached),
        ),
      );
    } catch (e) {
      showErrorDialog(context, '[goMovieDetail]: $e');
    }
    return;
  }

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
    // save cache
    await CacheUtils.setContent(id, content);
    if (!context.mounted) return;

    context.pushMaterialPageRoute(
      builder: (mainCtx) => TvShowDetailPage(
        tvShow: detail,
        fetchUrl: url,
        contentId: id,
        contentHashId: CacheUtils.getHashId(content),
      ),
    );
  } catch (e) {
    showErrorDialog(context, e.toString());
  }
  return;
}
