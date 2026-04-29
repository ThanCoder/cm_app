// enum QuerType {single,list}

import 'package:t_html_parser/core/types/attributes.dart';
import 'package:t_html_parser/t_html_parser.dart';

class Query {
  final int index;
  final String attribute;
  final String selector;

  const Query({
    this.index = -1,
    required this.selector,
    required this.attribute,
  });

  String getResultHtml(String html) {
    return getResultFromElement(html.toHtmlElement!);
  }

  String getResultFromElement(Element ele) {
    if (attribute == 'html') {
      if (index != -1) {
        final eles = ele.querySelectorAll(selector);
        if (eles.length > index) {
          return eles[index].getQuerySelectorHtml(selector: '');
        }
      }
      return ele.getQuerySelectorHtml(selector: selector);
    }
    if (attribute == 'text') {
      if (index != -1) {
        final eles = ele.querySelectorAll(selector);
        if (eles.length > index) {
          return eles[index].getQuerySelectorText(selector: '');
        }
      }
      return ele.getQuerySelectorText(selector: selector);
    }
    // attribute
    if (index != -1) {
      final eles = ele.querySelectorAll(selector);
      if (eles.length > index) {
        return eles[index].getQuerySelectorAttr(
          attr: Attribute(attribute),
          selector: '',
        );
      }
    }

    return ele.getQuerySelectorAttr(
      selector: selector,
      attr: Attribute(attribute),
    );
  }
}
