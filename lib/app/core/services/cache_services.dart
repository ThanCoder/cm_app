import 'dart:convert';
import 'dart:io';

import 'package:cm_app/app/core/models/movie_detail.dart';
import 'package:cm_app/app/core/models/series_detail.dart';
import 'package:cm_app/more_libs/setting/core/path_util.dart';

class CacheServices {
  // movies
  static Future<void> setMovieCache(
    String title, {
    required MovieDetail detail,
  }) async {
    final path = PathUtil.getCachePath(
      name: 'movie-${title.replaceAll('/', '-')}.cache.json',
    );

    final file = File(path);
    final contents = jsonEncode(detail.toMap());
    await file.writeAsString(contents);
  }

  static Future<MovieDetail?> getMovieCache(String title) async {
    final path = PathUtil.getCachePath(
      name: 'movie-${title.replaceAll('/', '-')}.cache.json',
    );
    // print('getCache: $path');
    final file = File(path);
    if (!file.existsSync()) return null;
    final source = await file.readAsString();
    final map = jsonDecode(source);
    return MovieDetail.fromMap(map);
  }

  // series
  static Future<void> setSeriesCache(
    String title, {
    required SeriesDetail detail,
  }) async {
    final path = PathUtil.getCachePath(
      name: 'tv-show-${title.replaceAll('/', '-')}.cache.json',
    );
    final file = File(path);
    final contents = jsonEncode(detail.toMap());
    await file.writeAsString(contents);
  }

  static Future<SeriesDetail?> getSeriesCache(String title) async {
    final path = PathUtil.getCachePath(
      name: 'tv-show-${title.replaceAll('/', '-')}.cache.json',
    );
    final file = File(path);
    if (!file.existsSync()) return null;
    final source = await file.readAsString();
    final map = jsonDecode(source);
    return SeriesDetail.fromMap(map);
  }
}
