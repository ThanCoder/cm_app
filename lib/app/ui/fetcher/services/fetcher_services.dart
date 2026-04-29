import 'dart:convert';
import 'dart:io';

import 'package:cm_app/app/ui/fetcher/screens/contents/website_content_page.dart';
import 'package:cm_app/app/ui/fetcher/types/content_responses.dart';
import 'package:cm_app/app/ui/fetcher/types/movie_pagi_response.dart';
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

  Future<MoviePagiResponse> fetchPagiPageList(
    String url, {
    bool useCache = true,
    bool cacheCleanUp = false,
    String firstKeyName = 'cache-pagi-page-',
    required WebsiteContentPageType type,
    required Website website,
  }) async {
    final html = await _getCacheHtml(
      url,
      cacheCleanUp: cacheCleanUp,
      useCache: useCache,
      firstKeyName: firstKeyName,
    );

    var movies = <MovieItem>[];

    if (type == WebsiteContentPageType.movie) {
      movies = website.moviePage.getResultFromHtml(html);
    }
    if (type == WebsiteContentPageType.tvShow) {
      movies = website.tvShowPage.getResultFromHtml(html);
    }
    // pagi
    var pagiList = <Pagination>[];
    if (website.moviePage.paginationQuery != null &&
        type == WebsiteContentPageType.movie) {
      pagiList = website.moviePage.paginationQuery!.getResultFromHtml(html);
    }
    if (website.tvShowPage.paginationQuery != null &&
        type == WebsiteContentPageType.tvShow) {
      pagiList = website.tvShowPage.paginationQuery!.getResultFromHtml(html);
    }

    return MoviePagiResponse(movies: movies, pagiList: pagiList);
  }

  // movie content
  Future<MovieContentResponse?> fetchMoviePageContent(
    String html, {
    required Website website,
  }) async {
    if (website.pageContentQuery == null) return null;

    String descText = website.pageContentQuery!.contentQuery.getResultHtml(
      html,
    );

    final list = website.pageContentQuery!.downloadQuery.getResultFromHtml(
      html,
    );

    return MovieContentResponse(descText: descText, downloadItems: list);
  }

  // tv show content
  Future<TvShowContentResponse?> fetchTVShowPageContent(
    String html, {
    required Website website,
  }) async {
    if (website.pageContentQuery == null) return null;

    // desc
    String descText = website.pageContentQuery!.contentQuery.getResultHtml(
      html,
    );

    // cast
    var castList = <TvShowCast>[];
    if (website.castQuery != null) {
      castList = website.castQuery!.getResultFromHtml(html);
    }

    // seasons
    var seasons = <TvShowSeason>[];
    if (website.seasonQuery != null) {
      seasons = website.seasonQuery!.getResultFromHtml(html);
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
  Future<(List<MovieItem>, List<MovieItem>)> fetchPage(
    String url, {
    required Website website,
  }) async {
    final movieList = <MovieItem>[];
    final tvShowList = <MovieItem>[];
    final html = await _getCacheHtml(url);
    final dom = html.toHtmlDocument;

    for (var ele in dom.querySelectorAll(website.moviePage.selectorAll)) {
      movieList.add(
        MovieItem(
          title: website.moviePage.titleQuery.getResultFromElement(ele),
          url: website.moviePage.urlQuery.getResultFromElement(ele),
          coverUrl: website.moviePage.coverUrlQuery.getResultFromElement(ele),
        ),
      );
    }
    for (var ele in dom.querySelectorAll(website.tvShowPage.selectorAll)) {
      tvShowList.add(
        MovieItem(
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
