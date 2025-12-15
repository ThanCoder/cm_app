import 'dart:convert';

import 'package:cm_app/app/constants.dart';
import 'package:cm_app/app/core/models/movie.dart';
import 'package:cm_app/app/core/models/movie_year.dart';
import 'package:cm_app/app/core/models/tag_and_genres.dart';
import 'package:cm_app/app/core/services/client_services.dart';
import 'package:cm_app/more_libs/setting/setting.dart';

class MovieServices {
  static Future<List<Movie>> getMovies(String url) async {
    List<Movie> list = [];
    final res = await ClientServices.instance.getUrlContent(
      Setting.getForwardProxyUrl(url),
    );
    final jsonData = jsonDecode(res);
    List<dynamic> jsonList = jsonData['data'] ?? [];
    list = jsonList.map((map) => Movie.fromMap(map)).toList();

    return list;
  }

  static Future<List<Movie>> getMoviesByYears(String year) async {
    List<Movie> list = [];
    final res = await ClientServices.instance.getUrlContent(
      Setting.getForwardProxyUrl('$apiMovieByYearUrl/$year'),
    );
    final jsonData = jsonDecode(res);
    List<dynamic> jsonList = jsonData['data'] ?? [];
    list = jsonList.map((map) => Movie.fromMap(map)).toList();

    return list;
  }

  static Future<List<TagAndGenres>> getTagAndGenresList(String url) async {
    List<TagAndGenres> list = [];
    final res = await ClientServices.instance.getUrlContent(
      Setting.getForwardProxyUrl(url),
    );
    final jsonData = jsonDecode(res);
    List<dynamic> jsonList = jsonData['data'] ?? [];
    list = jsonList.map((map) => TagAndGenres.fromMap(map)).toList();

    return list;
  }

  static Future<List<MovieYear>> getMovieYears() async {
    List<MovieYear> list = [];
    final res = await ClientServices.instance.getUrlContent(
      Setting.getForwardProxyUrl(apiMovieYearsUrl),
    );

    final jsonData = jsonDecode(res);
    List<dynamic> jsonList = jsonData['data'] ?? [];
    list = jsonList.map((map) => MovieYear.fromMap(map)).toList();

    return list;
  }
}
