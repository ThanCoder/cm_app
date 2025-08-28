// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:html/dom.dart';

import 'package:cm_app/app/models/movie.dart';
import 'package:cm_app/app/models/movie_genres_model.dart';
import 'package:cm_app/app/models/movie_year_model.dart';
import 'package:cm_app/app/services/dio_services.dart';
import 'package:cm_app/my_libs/setting_v2.2.0/setting.dart';

class MovieResult {
  List<Movie> list;
  String nextUrl;
  String? error;
  MovieResult({required this.list, required this.nextUrl, this.error});
}

class CMServices {
  static Future<List<Movie>> getRelatedList(String url) async {
    List<Movie> list = [];
    try {
      final res = await DioServices.instance.getHtml(url);
      final dom = Document.html(res);
      final eles = dom.querySelectorAll('.owl-carousel .item');
      for (var ele in eles) {
        final movie = Movie.fromOvalElement(ele);

        list.add(movie);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return list;
  }

  static Future<List<MovieYearModel>> getYearList({
    bool isOverride = false,
  }) async {
    List<MovieYearModel> list = [];
    try {
      var res = await DioServices.instance.getCacheHtml(
        url: DioServices.instance.getForwardProxyUrl(
          Setting.getAppConfig.hostUrl,
        ),
        cacheName: 'year',
        isOverride: isOverride,
      );
      if (res.isEmpty) {
        await DioServices.instance.getCacheHtml(
          url: DioServices.instance.getForwardProxyUrl(
            Setting.getAppConfig.hostUrl,
          ),
          cacheName: 'year',
          isOverride: true,
        );
      }
      final dom = Document.html(res);
      final eles = dom.querySelectorAll('.filtro_y li');
      // print(eles.length);
      for (var ele in eles) {
        list.add(MovieYearModel.fromElement(ele));
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return list;
  }

  static Future<List<MovieGenresModel>> getGenresList({
    bool isOverride = false,
  }) async {
    List<MovieGenresModel> list = [];
    try {
      var res = await DioServices.instance.getCacheHtml(
        url: DioServices.instance.getForwardProxyUrl(
          Setting.getAppConfig.hostUrl,
        ),
        cacheName: 'genres',
        isOverride: isOverride,
      );
      if (res.isEmpty) {
        await DioServices.instance.getCacheHtml(
          url: DioServices.instance.getForwardProxyUrl(
            Setting.getAppConfig.hostUrl,
          ),
          cacheName: 'genres',
          isOverride: true,
        );
      }
      final dom = Document.html(res);
      final eles = dom.querySelectorAll('.cat-item');
      for (var ele in eles) {
        list.add(MovieGenresModel.fromElement(ele));
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return list;
  }

  static Future<List<Movie>> getRandomList() async {
    List<Movie> list = [];
    try {
      final res = await DioServices.instance.getHtml(
        Setting.getAppConfig.hostUrl,
      );
      final dom = Document.html(res);
      final eles = dom.querySelectorAll('.owl-carousel .item');
      for (var ele in eles) {
        final movie = Movie.fromOvalElement(ele);
        list.add(movie);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return list;
  }

  static Future<MovieResult> getMovieList({required String url}) async {
    List<Movie> list = [];
    String? error;
    var nextUrl = '';
    try {
      // final res = await getDio.get(url);
      final res = await DioServices.instance.getHtml(url);
      final html = Document.html(res);
      final eles = html.querySelectorAll('.box_item .items .item');
      for (var ele in eles) {
        final movie = Movie.fromElement(ele);
        list.add(movie);
      }

      //page next url
      if (html.querySelector('.respo_pag .pag_b a') != null) {
        nextUrl =
            html.querySelector('.respo_pag .pag_b a')!.attributes['href'] ?? '';
      }
    } catch (e) {
      error = e.toString();
    }
    return MovieResult(list: list, nextUrl: nextUrl, error: error);
  }
}
