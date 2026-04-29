import 'dart:convert';
import 'dart:io';

import 'package:cm_app/app/ui/fetcher/types/content_responses.dart';
import 'package:cm_app/app/ui/fetcher/types/website.dart';
import 'package:cm_app/more_libs/setting/core/path_util.dart';
import 'package:crypto/crypto.dart';
import 'package:t_client/t_client.dart';
import 'package:t_html_parser/core/types/attributes.dart';
import 'package:t_html_parser/t_html_parser.dart';

class FetcherServices {
  static final FetcherServices instace = FetcherServices._();
  FetcherServices._();
  factory FetcherServices() => instace;
  final client = TClient();

  // movie content
  Future<MovieContentResponse?> fetchMoviePageContent(
    String html, {
    required Website website,
  }) async {
    if (website.pageContentQuery == null) return null;

    final dom = html.toHtmlDocument;

    String descText = '';
    final desc = dom.querySelector('.wp-content');
    if (desc != null) {
      descText = desc.getQuerySelectorText(selector: '');
    }

    final list = <MovieContentDownloadItem>[];
    for (var ele in dom.querySelectorAll(
      website.pageContentQuery!.downloadQuery.selectorAll,
    )) {
      final url = website.pageContentQuery!.downloadQuery.urlQuery
          .getResultFromElement(ele);
      final quality = website.pageContentQuery!.downloadQuery.qualityQuery
          .getResultFromElement(ele);
      final size = '-1';
      // print('quality: $quality - url: $url');
      // break;
      list.add(
        MovieContentDownloadItem(
          title: 'Download',
          quality: quality,
          url: url,
          size: size,
        ),
      );
    }
    return MovieContentResponse(descText: descText, downloadItems: list);
  }

  // tv show content
  Future<TvShowContentResponse?> fetchTVShowPageContent(
    String html, {
    required Website website,
  }) async {
    if (website.pageContentQuery == null) return null;

    final dom = html.toHtmlDocument;
    // desc
    String descText = '';

    final desc = dom.querySelector('.wp-content');
    if (desc != null) {
      descText = desc.getQuerySelectorText(selector: '');
    }
    // cast
    final castList = <TvShowCast>[];
    for (var castEle in dom.querySelectorAll('.persons .person')) {
      final name = castEle.getQuerySelectorText(selector: '.name a');
      final character = castEle.getQuerySelectorText(selector: '.caracter');
      final profileUrl = castEle.getQuerySelectorAttr(
        selector: 'img',
        attr: Attribute('src'),
      );
      // print('name: $name - character: $character - url: $profileUrl');
      // break;
      castList.add(
        TvShowCast(
          name: name,
          profileUrl: profileUrl,
          characterName: character,
        ),
      );
    }

    // seasons
    final seasons = <TvShowSeason>[];

    for (var season in dom.querySelectorAll('#seasons .se-c')) {
      final title = season.getQuerySelectorText(selector: '.title');
      final episodios = <TvShowEpisode>[];

      for (var epEle in season.querySelectorAll('.se-a .episodios li')) {
        final coverUrl = epEle.getQuerySelectorAttr(
          selector: '.imagen img',
          attr: Attribute('src'),
        );
        final number = epEle.getQuerySelectorText(selector: '.numerando');
        final title = epEle.getQuerySelectorText(selector: '.episodiotitle a');
        final url = epEle.getQuerySelectorAttr(
          selector: '.episodiotitle a',
          attr: Attribute('href'),
        );
        episodios.add(
          TvShowEpisode(
            title: title,
            number: number,
            url: url,
            coverUrl: coverUrl,
          ),
        );
        // print('title: $title - number: $number - url: $url');
        // break;
      }
      seasons.add(TvShowSeason(title: title, episodios: episodios));
    }
    return TvShowContentResponse(
      descText: descText,
      seasons: seasons,
      castList: castList,
    );
  }

  Future<String> fetchPageHtml(
    String url, {
    String firstKeyName = 'cache-page-',
    bool useCache = true,
    bool cacheCleanUp = false,
  }) async {
    final html = await _getCacheHtml(
      url,
      firstKeyName: firstKeyName,
      useCache: useCache,
      cacheCleanUp: cacheCleanUp,
    );
    return html;
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
