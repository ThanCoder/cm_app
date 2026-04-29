import 'package:cm_app/app/ui/fetcher/types/content_types.dart';
import 'package:cm_app/app/ui/fetcher/types/query.dart';

class Website {
  final String title;
  final String url;
  final String hostUrl;
  final WebsitePage moviePage;
  final WebsitePage tvShowPage;
  final PageContentQuery? pageContentQuery;

  const Website({
    required this.title,
    required this.url,
    required this.hostUrl,
    required this.moviePage,
    required this.tvShowPage,
    this.pageContentQuery,
  });
}

class WebsitePage {
  final String title;
  final String moreUrl;
  final String selectorAll;
  final Query titleQuery;
  final Query urlQuery;
  final Query coverUrlQuery;

  const WebsitePage({
    required this.title,
    required this.moreUrl,
    required this.selectorAll,
    required this.titleQuery,
    required this.urlQuery,
    required this.coverUrlQuery,
  });
}

// result
class WebsitePageResult {
  final String key;
  final String title;
  final String url;
  final String coverUrl;

  const WebsitePageResult({
    required this.key,
    required this.title,
    required this.url,
    required this.coverUrl,
  });
}
