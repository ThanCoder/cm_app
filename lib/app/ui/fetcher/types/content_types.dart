import 'package:cm_app/app/ui/fetcher/types/content_responses.dart';
import 'package:t_html_parser/t_html_parser.dart';

import 'query.dart';

class PageContentQuery {
  final Query contentQuery;
  final DownloadQuery downloadQuery;

  const PageContentQuery({
    required this.contentQuery,
    required this.downloadQuery,
  });
}

class DownloadQuery {
  final String selectorAll;
  final Query urlQuery;
  final Query qualityQuery;
  final Query sizeQuery;

  const DownloadQuery({
    required this.selectorAll,
    required this.urlQuery,
    required this.qualityQuery,
    required this.sizeQuery,
  });

  List<MovieContentDownloadItem> getResultFromHtml(String html) {
    final list = <MovieContentDownloadItem>[];

    for (var ele in html.toHtmlDocument.querySelectorAll(selectorAll)) {
      final url = urlQuery.getResultFromElement(ele);
      final quality = qualityQuery.getResultFromElement(ele);
      String size = sizeQuery.getResultFromElement(ele);

      list.add(
        MovieContentDownloadItem(
          title: 'Download',
          quality: quality,
          url: url,
          size: size,
        ),
      );
    }
    return list;
  }
}
