import 'dart:convert';
import 'dart:io';

import 'package:cm_app/app/ui/fetcher/types/website.dart';
import 'package:cm_app/more_libs/setting/core/path_util.dart';
import 'package:crypto/crypto.dart';
import 'package:t_client/t_client.dart';
import 'package:t_html_parser/t_html_parser.dart';

class FetcherServices {
  static final FetcherServices instace = FetcherServices._();
  FetcherServices._();
  factory FetcherServices() => instace;
  final client = TClient();

  Future<void> fetchPageContent(String url, {required Website website}) async {
    if (website.pageContentQuery == null) return;

    final html = await _getCacheHtml(url, firstKeyName: 'cache-content-page-');
    final dom = html.toHtmlDocument;
    for (var ele in dom.querySelectorAll(
      website.pageContentQuery!.downloadQuery.selectorAll,
    )) {
      final url = website.pageContentQuery!.downloadQuery.urlQuery
          .getResultFromElement(ele);
      final quality = website.pageContentQuery!.downloadQuery.qualityQuery
          .getResultFromElement(ele);
      // final size = ele.
      // print('text: $text - quality: $quality - url: $url');
      break;
    }
  }

  ///Return (movies,tvshows)
  Future<(List<WebsitePageResult>, List<WebsitePageResult>)> fetchPage(
    String url, {
    required Website website,
  }) async {
    final movieList = <WebsitePageResult>[];
    final tvShowList = <WebsitePageResult>[];
    final html = await _getCacheHtml(url);
    final dom = html.toHtmlDocument;

    for (var ele in dom.querySelectorAll(website.moviePage.selectorAll)) {
      movieList.add(
        WebsitePageResult(
          key: website.moviePage.title,
          title: website.moviePage.titleQuery.getResultFromElement(ele),
          url: website.moviePage.urlQuery.getResultFromElement(ele),
          coverUrl: website.moviePage.coverUrlQuery.getResultFromElement(ele),
        ),
      );
    }
    for (var ele in dom.querySelectorAll(website.tvShowPage.selectorAll)) {
      tvShowList.add(
        WebsitePageResult(
          key: website.tvShowPage.title,
          title: website.tvShowPage.titleQuery.getResultFromElement(ele),
          url: website.tvShowPage.urlQuery.getResultFromElement(ele),
          coverUrl: website.tvShowPage.coverUrlQuery.getResultFromElement(ele),
        ),
      );
    }
    // print(list);
    return (movieList, tvShowList);
  }

  Future<String> _getCacheHtml(
    String url, {
    bool useCache = true,
    bool cacheCleanUp = false,
    String firstKeyName = 'cache-page-',
  }) async {
    final cacheName = sha1.convert(utf8.encode(url)).toString();
    final cacheFile = File(
      PathUtil.getCachePath(name: '$firstKeyName$cacheName.html'),
    );
    if (useCache && cacheFile.existsSync()) {
      return await cacheFile.readAsString();
    }
    if (!useCache && cacheCleanUp && cacheFile.existsSync()) {
      await cacheFile.delete();
    }
    // no cache
    final res = await client.get(url);
    if (res.statusCode == 200) {
      await cacheFile.writeAsString(res.data.toString());
    }
    return res.data.toString();
  }
}
