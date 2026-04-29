import 'package:cm_app/app/ui/fetcher/types/content_types.dart';
import 'package:cm_app/app/ui/fetcher/types/query.dart';
import 'package:cm_app/app/ui/fetcher/types/website.dart';

class WebsiteServices {
  static final WebsiteServices instace = WebsiteServices._();
  const WebsiteServices._();
  factory WebsiteServices() => instace;

  Future<List<Website>> getList() async {
    final list = <Website>[];
    list.add(
      Website(
        title: 'MM SubMovie',
        url: 'https://mmsubmovie.com',
        hostUrl: 'https://mmsubmovie.com',
        moviePage: WebsitePage(
          title: 'Movie',
          moreUrl: 'https://mmsubmovie.com/movies',
          selectorAll: '.movies',
          titleQuery: Query(attribute: 'text', selector: '.data a'),
          urlQuery: Query(attribute: 'href', selector: '.data a'),
          coverUrlQuery: Query(attribute: 'src', selector: '.poster img'),
          paginationQuery: PagePaginationQuery(
            selectorAll: '.pagination a',
            titleQuery: Query(selector: '', attribute: 'text'),
            urlQuery: Query(selector: '', attribute: 'href'),
          ),
        ),
        tvShowPage: WebsitePage(
          title: 'TV Shows',
          moreUrl: 'https://mmsubmovie.com/tvshows',
          selectorAll: '.tvshows',
          titleQuery: Query(attribute: 'text', selector: '.data a'),
          urlQuery: Query(attribute: 'href', selector: '.data a'),
          coverUrlQuery: Query(attribute: 'src', selector: '.poster img'),
          paginationQuery: PagePaginationQuery(
            selectorAll: '.pagination a',
            titleQuery: Query(selector: '', attribute: 'text'),
            urlQuery: Query(selector: '', attribute: 'href'),
          ),
        ),
        seasonQuery: TvShowSeasonQuery(
          selectorAll: '#seasons .se-c',
          seasonTitleQuery: Query(selector: '.title', attribute: 'text'),
          episodeQuery: TvShowEpisodeQuery(
            selectorAll: '.se-a .episodios li',
            titleQuery: Query(selector: '.episodiotitle a', attribute: 'text'),
            numberQuery: Query(selector: '.numerando', attribute: 'text'),
            coverUrlQuery: Query(selector: '.imagen img', attribute: 'src'),
            urlQuery: Query(selector: '.episodiotitle a', attribute: 'href'),
          ),
        ),
        castQuery: TvShowCastQuery(
          selectorAll: '.persons .person',
          nameQuery: Query(selector: '.name a', attribute: 'text'),
          characterQuery: Query(selector: '.caracter', attribute: 'text'),
          profileUrlQuery: Query(selector: 'img', attribute: 'src'),
        ),
        pageContentQuery: PageContentQuery(
          contentQuery: Query(attribute: 'text', selector: '.wp-content'),
          downloadQuery: DownloadQuery(
            selectorAll: '#download tbody tr',
            urlQuery: Query(attribute: 'href', selector: 'a'),
            qualityQuery: Query(attribute: 'text', selector: '.quality'),
            sizeQuery: Query(attribute: 'text', selector: 'td', index: 3),
          ),
        ),
      ),
    );
    return list;
  }
}
