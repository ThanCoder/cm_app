import 'package:cm_app/app/models/movie.dart';
import 'package:cm_app/app/services/dio_services.dart';
import 'package:cm_app/my_libs/setting_v2.2.0/setting.dart';
import 'package:flutter/material.dart';
import 'package:t_html_parser/t_html_extensions.dart';

class CMHomePageServices {
  static final List<Movie> _cacheList = [];

  static List<Movie> get getCacheList => _cacheList;

  static Future<List<Movie>> getHomeMovies({bool isReset = false}) async {
    try {
      print(Setting.getAppConfig.hostUrl);
      if (!isReset && _cacheList.isNotEmpty) {
        return _cacheList;
      }
      final html = await _getHtml(Setting.getAppConfig.hostUrl);
      final eles = html.toHtmlElement;
      _cacheList.clear();
      if (eles == null) return _cacheList;
      for (var ele in eles.querySelectorAll('.peliculas .item')) {
        final movie = Movie.fromElement(ele);
        _cacheList.add(movie);
      }
    } catch (e) {
      debugPrint('[CMHomePageServices:getHomeMovies]${e.toString()}');
    }
    return _cacheList;
  }

  static Future<String> _getHtml(String url) async {
    final proxyUrl = Setting.getForwardProxyUrl(url);
    final res = await DioServices.instance.getDio().get(proxyUrl);
    return res.data ?? '';
  }
}
