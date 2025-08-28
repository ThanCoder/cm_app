import 'package:cm_app/app/services/dio_services.dart';
import 'package:t_html_parser/t_html_parser.dart';

class DownloadLink {
  String title;
  String url;
  String iconUrl;
  String size;
  String quality;
  DownloadLink({
    required this.title,
    required this.url,
    required this.size,
    required this.quality,
    required this.iconUrl,
  });

  factory DownloadLink.fromElement(String html) {
    final ele = html.toHtmlElement!;
    return DownloadLink(
      title: ele.getQuerySelectorText(selector: '.b'),
      url: ele.getQuerySelectorAttr(selector: 'a', attr: 'href'),
      size: ele.getQuerySelectorText(selector: '.c'),
      quality: ele.getQuerySelectorText(selector: '.d'),
      iconUrl: DioServices.instance.getForwardProxyUrl(
        ele.getQuerySelectorAttr(selector: 'img', attr: 'src'),
      ),
    );
  }
  @override
  String toString() {
    return '\nserver => $title\n';
  }
}
