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
        title: 'mmsubmovie',
        url: 'https://mmsubmovie.com',
        hostUrl: 'https://mmsubmovie.com',
        moviePage: WebsitePage(
          title: 'Movie',
          moreUrl: 'https://mmsubmovie.com/movies',
          selectorAll: '.movies',
          titleQuery: Query(attribute: 'text', selector: '.data a'),
          urlQuery: Query(attribute: 'href', selector: '.data a'),
          coverUrlQuery: Query(attribute: 'src', selector: '.poster img'),
        ),
        tvShowPage: WebsitePage(
          title: 'TV Shows',
          moreUrl: 'https://mmsubmovie.com/tvshows',
          selectorAll: '.tvshows',
          titleQuery: Query(attribute: 'text', selector: '.data a'),
          urlQuery: Query(attribute: 'href', selector: '.data a'),
          coverUrlQuery: Query(attribute: 'src', selector: '.poster img'),
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
