import 'package:cm_app/app/ui/fetcher/types/content_responses.dart';
import 'package:t_html_parser/t_html_parser.dart';

import 'package:cm_app/app/ui/fetcher/types/content_types.dart';
import 'package:cm_app/app/ui/fetcher/types/movie_pagi_response.dart';
import 'package:cm_app/app/ui/fetcher/types/query.dart';

class Website {
  final String title;
  final String url;
  final String hostUrl;
  final WebsitePage moviePage;
  final WebsitePage tvShowPage;
  final PageContentQuery? pageContentQuery;
  final TvShowCastQuery? castQuery;
  final TvShowSeasonQuery? seasonQuery;

  const Website({
    required this.title,
    required this.url,
    required this.hostUrl,
    required this.moviePage,
    required this.tvShowPage,
    this.pageContentQuery,
    this.castQuery,
    this.seasonQuery,
  });
}

class WebsitePage {
  final String title;
  final String moreUrl;
  final String selectorAll;
  final Query titleQuery;
  final Query urlQuery;
  final Query coverUrlQuery;
  final PagePaginationQuery? paginationQuery;

  const WebsitePage({
    required this.title,
    required this.moreUrl,
    required this.selectorAll,
    required this.titleQuery,
    required this.urlQuery,
    required this.coverUrlQuery,
    this.paginationQuery,
  });

  List<MovieItem> getResultFromHtml(String html) {
    final movies = <MovieItem>[];

    for (var ele in html.toHtmlDocument.querySelectorAll(selectorAll)) {
      final coverUrl = coverUrlQuery.getResultFromElement(ele);
      final url = urlQuery.getResultFromElement(ele);
      final title = titleQuery.getResultFromElement(ele);

      // print('title: $title - url: $url - coverUrl: $coverUrl');
      // break;
      movies.add(MovieItem(title: title, url: url, coverUrl: coverUrl));
    }
    return movies;
  }
}

class PagePaginationQuery {
  final String selectorAll;
  final Query titleQuery;
  final Query urlQuery;

  const PagePaginationQuery({
    required this.selectorAll,
    required this.titleQuery,
    required this.urlQuery,
  });

  List<Pagination> getResultFromHtml(String html) {
    final pagiList = <Pagination>[];
    for (var ele in html.toHtmlDocument.querySelectorAll(selectorAll)) {
      final title = titleQuery.getResultFromElement(ele);
      final url = urlQuery.getResultFromElement(ele);

      if (title.isEmpty || url.isEmpty) continue;
      // print('title: $title - url: $url');
      pagiList.add(Pagination(title: title, url: url));
    }
    return pagiList;
  }
}

class TvShowCastQuery {
  final String selectorAll;
  final Query nameQuery;
  final Query characterQuery;
  final Query profileUrlQuery;

  const TvShowCastQuery({
    required this.selectorAll,
    required this.nameQuery,
    required this.characterQuery,
    required this.profileUrlQuery,
  });

  List<TvShowCast> getResultFromHtml(String html) {
    final castList = <TvShowCast>[];

    for (var ele in html.toHtmlDocument.querySelectorAll(selectorAll)) {
      final name = nameQuery.getResultFromElement(ele);
      final character = characterQuery.getResultFromElement(ele);
      final profileUrl = profileUrlQuery.getResultFromElement(ele);

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
    return castList;
  }
}

class TvShowSeasonQuery {
  final String selectorAll;
  final Query seasonTitleQuery;
  final TvShowEpisodeQuery episodeQuery;

  const TvShowSeasonQuery({
    required this.selectorAll,
    required this.seasonTitleQuery,
    required this.episodeQuery,
  });
  List<TvShowSeason> getResultFromHtml(String html) {
    final seasons = <TvShowSeason>[];

    for (var ele in html.toHtmlDocument.querySelectorAll(selectorAll)) {
      final title = seasonTitleQuery.getResultFromElement(ele);
      final episodios = episodeQuery.getResultFromElement(ele);
      seasons.add(TvShowSeason(title: title, episodios: episodios));
    }
    return seasons;
  }
}

class TvShowEpisodeQuery {
  final String selectorAll;
  final Query titleQuery;
  final Query numberQuery;
  final Query coverUrlQuery;
  final Query urlQuery;

  const TvShowEpisodeQuery({
    required this.selectorAll,
    required this.titleQuery,
    required this.numberQuery,
    required this.coverUrlQuery,
    required this.urlQuery,
  });

  List<TvShowEpisode> getResultFromElement(Element parentEle) {
    final episodios = <TvShowEpisode>[];
    for (var ele in parentEle.querySelectorAll(selectorAll)) {
      final coverUrl = coverUrlQuery.getResultFromElement(ele);
      final number = numberQuery.getResultFromElement(ele);
      final title = titleQuery.getResultFromElement(ele);
      final url = urlQuery.getResultFromElement(ele);
      episodios.add(
        TvShowEpisode(
          title: title,
          number: number,
          url: url,
          coverUrl: coverUrl,
        ),
      );
    }
    return episodios;
  }
}
