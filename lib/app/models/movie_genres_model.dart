import 'package:html/dom.dart' as html;

import '../services/html_query_selector_services.dart';

class MovieGenresModel {
  String title;
  String count;
  String url;
  MovieGenresModel({
    required this.title,
    required this.count,
    required this.url,
  });

  factory MovieGenresModel.fromElement(html.Element ele) {
    return MovieGenresModel(
      title: getQuerySelectorText(ele, 'a'),
      count: getQuerySelectorText(ele, 'span'),
      url: getQuerySelectorAttr(ele, 'a', 'href'),
    );
  }
  @override
  String toString() {
    return title;
  }
}
