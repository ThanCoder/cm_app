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
}
