import 'dart:convert';

import 'package:cm_app/app/core/models/movie.dart';
import 'package:cm_app/app/services/client_services.dart';
import 'package:cm_app/more_libs/setting_v2.8.3/setting.dart';

class MovieServices {
  static final String apiMovieUrl = 'https://www.homietv.com/api/movies';
  static final String apiTvShowUrl = 'https://www.homietv.com/api/tv-shows';

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
}
