import 'package:cm_app/app/services/html_query_selector_services.dart';
import 'package:html/dom.dart' as html;

class MovieYearModel {
  String title;
  String url;
  MovieYearModel({
    required this.title,
    required this.url,
  });

  factory MovieYearModel.fromElement(html.Element ele) {
    return MovieYearModel(
      title: getQuerySelectorText(ele, 'a'),
      url: getQuerySelectorAttr(ele, 'a', 'href'),
    );
  }

  @override
  String toString() {
    return title;
  }
}
