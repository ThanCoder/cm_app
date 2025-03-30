import 'package:cm_app/app/models/movie_genres_model.dart';
import 'package:cm_app/app/models/movie_model.dart';
import 'package:cm_app/app/models/movie_year_model.dart';
import 'package:cm_app/app/notifiers/app_notifier.dart';
import 'package:cm_app/app/services/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:html/dom.dart';

class CMServices {
  static final CMServices instance = CMServices._();
  CMServices._();
  factory CMServices() => instance;

  CMServices get service => CMServices();

  Future<List<MovieModel>> getRelatedList(String url) async {
    List<MovieModel> list = [];
    try {
      final res = await DioServices.instance.getForwardProxyHtml(url);
      final dom = Document.html(res);
      final eles = dom.querySelectorAll('.owl-carousel .item');
      for (var ele in eles) {
        final movie = MovieModel.fromOvalElement(ele);

        list.add(movie);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return list;
  }

  Future<List<MovieYearModel>> getYearList({bool isOverride = false}) async {
    List<MovieYearModel> list = [];
    try {
      var res = await DioServices.instance.getCacheHtml(
          url: appConfigNotifier.value.hostUrl,
          cacheName: 'year',
          isOverride: isOverride);
      if (res.isEmpty) {
        await DioServices.instance.getCacheHtml(
          url: appConfigNotifier.value.hostUrl,
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

  Future<List<MovieGenresModel>> getGenresList(
      {bool isOverride = false}) async {
    List<MovieGenresModel> list = [];
    try {
      var res = await DioServices.instance.getCacheHtml(
        url: appConfigNotifier.value.hostUrl,
        cacheName: 'genres',
        isOverride: isOverride,
      );
      if (res.isEmpty) {
        await DioServices.instance.getCacheHtml(
          url: appConfigNotifier.value.hostUrl,
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

  Future<List<MovieModel>> getRandomList() async {
    List<MovieModel> list = [];
    try {
      final res = await DioServices.instance
          .getForwardProxyHtml(appConfigNotifier.value.hostUrl);
      final dom = Document.html(res);
      final eles = dom.querySelectorAll('.owl-carousel .item');
      for (var ele in eles) {
        final movie = MovieModel.fromOvalElement(ele);

        list.add(movie);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return list;
  }

  Future<void> getMovieList({
    required String url,
    required void Function(List<MovieModel> list, String nextUrl) onResult,
    void Function(String err)? onError,
  }) async {
    List<MovieModel> list = [];
    try {
      // final res = await getDio.get(url);
      final res = await DioServices.instance.getForwardProxyHtml(url);
      final html = Document.html(res);
      final eles = html.querySelectorAll('.box_item .items .item');
      for (var ele in eles) {
        final movie = MovieModel.fromElement(ele);
        list.add(movie);
        //download cover
        // await downloadCover(url: movie.coverUrl, savePath: movie.coverPath);
      }
      var nextUrl = '';
      //page next url
      if (html.querySelector('.respo_pag .pag_b a') != null) {
        nextUrl =
            html.querySelector('.respo_pag .pag_b a')!.attributes['href'] ?? '';
      }
      onResult(list, nextUrl);
    } catch (e) {
      if (onError != null) {
        onError(e.toString());
      }
    }
  }
}
