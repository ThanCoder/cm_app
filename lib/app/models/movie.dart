import 'package:html/dom.dart' as html;
import 'package:t_html_parser/t_html_parser.dart';
import 'package:than_pkg/than_pkg.dart';

import 'package:cm_app/my_libs/setting_v2.2.0/setting.dart';

class Movie {
  String title;
  String url;
  String coverUrl;
  String imdb;
  String desc;
  bool isSeries;
  Movie({
    required this.title,
    required this.url,
    required this.coverUrl,
    required this.imdb,
    this.desc = '',
    this.isSeries = false,
  });

  factory Movie.fromOvalElement(html.Element ele) {
    final map = TExtractor(
      rules: {
        'coverUrl': TSelectorRules('img', attribute: 'src'),
        'url': TSelectorRules('.a', attribute: 'href'),
        'title': TSelectorRules('.ttps'),
        'imdb': TSelectorRules('.imdb'),
      },
    ).extract(ele.outerHtml);

    return Movie(
      title: map.getString(['title']).trim(),
      url: map.getString(['url']).trim(),
      coverUrl: Setting.getForwardProxyUrl(map.getString(['coverUrl']).trim()),
      imdb: map.getString(['imdb']).trim(),
    );
  }

  factory Movie.fromElement(html.Element ele) {
    final map = TExtractor(
      rules: {
        'title': TSelectorRules('.fixyear h2'),
        'imdb': TSelectorRules('.imdb'),
        'desc': TSelectorRules('.boxinfo .ttx'),
        'url': TSelectorRules('a', attribute: 'href'),
        'coverUrl': TSelectorRules('.image img', attribute: 'src'),
      },
    ).extract(ele.outerHtml);
    return Movie(
      title: map.getString(['title']).trim(),
      url: map.getString(['url']).trim(),
      coverUrl: Setting.getForwardProxyUrl(map.getString(['coverUrl']).trim()),
      imdb: map.getString(['imdb']).trim(),
      desc: map.getString(['desc']).trim(),
    );
  }

  @override
  String toString() {
    return title;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'url': url,
      'coverUrl': coverUrl,
      'imdb': imdb,
      'desc': desc,
      'isSeries': isSeries,
    };
  }

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      title: map['title'] as String,
      url: map['url'] as String,
      coverUrl: map['coverUrl'] as String,
      imdb: map['imdb'] as String,
      desc: map['desc'] as String,
      isSeries: map['isSeries'] as bool,
    );
  }
}
