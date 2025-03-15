import 'dart:io';

import 'package:cm_app/app/constants.dart';
import 'package:cm_app/app/models/movie_genres_model.dart';
import 'package:cm_app/app/models/movie_model.dart';
import 'package:cm_app/app/models/movie_year_model.dart';
import 'package:cm_app/app/notifiers/app_notifier.dart';
import 'package:cm_app/app/utils/index.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/cupertino.dart';
import 'package:html/dom.dart';

class CMServices {
  static final CMServices instance = CMServices._();
  CMServices._();
  factory CMServices() => instance;

  CMServices get service => CMServices();

  final _dio = Dio();

  Future<List<MovieModel>> getRelatedList(String url) async {
    List<MovieModel> list = [];
    try {
      final res = await getForwardProxyHtml(url);
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
      var res = await getCacheHtml(
          url: appConfigNotifier.value.hostUrl,
          cacheName: 'year',
          isOverride: isOverride);
      if (res.isEmpty) {
        await getCacheHtml(
            url: appConfigNotifier.value.hostUrl,
            cacheName: 'year',
            isOverride: true);
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
      var res = await getCacheHtml(
          url: appConfigNotifier.value.hostUrl,
          cacheName: 'genres',
          isOverride: isOverride);
      if (res.isEmpty) {
        await getCacheHtml(
            url: appConfigNotifier.value.hostUrl,
            cacheName: 'genres',
            isOverride: true);
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
      final res = await getForwardProxyHtml(appConfigNotifier.value.hostUrl);
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
      final res = await getForwardProxyHtml(url);
      final html = Document.html(res.toString());
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

  Future<String> getForwardProxyHtml(String url) async {
    var result = '';
    try {
      final res = await getDio.get(getForwardProxyUrl(url));
      result = res.data.toString();
    } catch (e) {
      debugPrint('getForwardProxy: ${e.toString()}');
    }
    return result;
  }

  String getForwardProxyUrl(String targetUrl) {
    return '$appForwardProxyHostUrl?url=$targetUrl';
  }

  Future<String> getBrowsesrProxyHtml(String url) async {
    var result = '';
    try {
      final res = await getDio.get('$appBrowserProxyHostUrl?url=$url');
      result = res.data.toString();
    } catch (e) {
      debugPrint('getBrowsesrProxyHtml: ${e.toString()}');
    }
    return result;
  }

  Future<void> downloadCover({
    required String url,
    required String savePath,
  }) async {
    try {
      if (url.isEmpty) return;

      final cacheFile = File(savePath);
      if (await cacheFile.exists()) return;
      //မရှိရင်
      await getDio.download(getForwardProxyUrl(url), savePath);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<String> getCacheHtml({
    required String url,
    required String cacheName,
    bool isOverride = false,
  }) async {
    var res = '';
    try {
      if (url.isEmpty) return res;
      final savePath = '${PathUtil.instance.getCachePath()}/$cacheName.html';
      final cacheFile = File(savePath);
      if (!isOverride && await cacheFile.exists()) {
        res = await cacheFile.readAsString();
        return res;
      }
      //မရှိရင်
      final result = await getForwardProxyHtml(url);
      await cacheFile.writeAsString(result);
      res = result;
    } catch (e) {
      debugPrint(e.toString());
    }
    return res;
  }

  Dio get getDio {
    if (appConfigNotifier.value.isUseProxyServer) {
      final proxyAddress = appConfigNotifier.value.proxyAddress;
      final proxyPort = appConfigNotifier.value.proxyPort;
      _dio.httpClientAdapter = IOHttpClientAdapter(
        createHttpClient: () {
          final client = HttpClient();
          client.findProxy = (uri) {
            // return "PROXY 192.168.191.253:8081";
            return "PROXY $proxyAddress:$proxyPort";
          };
          return client;
        },
      );
    }
    return _dio;
  }
}
