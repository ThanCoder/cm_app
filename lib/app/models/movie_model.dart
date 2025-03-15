// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cm_app/app/utils/index.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as html;

import '../services/html_query_selector_services.dart';

class MovieModel {
  String title;
  String url;
  String coverUrl;
  String coverPath;
  String imdb;
  String desc;
  MovieModel({
    required this.title,
    required this.url,
    required this.coverUrl,
    required this.imdb,
    this.coverPath = '',
    this.desc = '',
  });

  factory MovieModel.fromMap(Map<String, dynamic> map) {
    return MovieModel(
      title: map['title'],
      url: map['url'],
      coverUrl: map['cover_url'],
      imdb: map['imdb'],
      desc: map['desc'],
      coverPath: map['cover_path'],
    );
  }
  Map<String, dynamic> toMap() => {
        'title': title,
        'url': url,
        'cover_url': coverUrl,
        'cover_path': coverPath,
        'imdb': imdb,
        'desc': desc,
      };

  factory MovieModel.fromElement(html.Element ele) {
    var title = getQuerySelectorText(ele, '.fixyear h2');
    var url = getQuerySelectorAttr(ele, 'a', 'href');
    var coverUrl = getQuerySelectorAttr(ele, '.image img', 'src');
    var imdb = getQuerySelectorText(ele, '.imdb');
    var desc = getQuerySelectorText(ele, '.boxinfo .ttx');

    var coverPath = '';
    if (coverUrl.isNotEmpty) {
      coverPath =
          '${PathUtil.instance.getCachePath()}/${coverUrl.split('/').last}';
    }
    return MovieModel(
      title: title.trim(),
      url: url.trim(),
      coverUrl: coverUrl.trim(),
      coverPath: coverPath.trim(),
      imdb: imdb.trim(),
      desc: desc.trim(),
    );
  }

  factory MovieModel.fromOvalElement(html.Element ele) {
    var coverUrl = getQuerySelectorAttr(ele, 'img', 'src');
    var coverPath = '';
    if (coverUrl.isNotEmpty) {
      coverPath =
          '${PathUtil.instance.getCachePath()}/${coverUrl.split('/').last}';
    }
    return MovieModel(
      title: getQuerySelectorText(ele, '.ttps'),
      url: getQuerySelectorAttr(ele, 'a', 'href'),
      coverUrl: coverUrl,
      coverPath: coverPath,
      imdb: getQuerySelectorText(ele, '.imdb'),
    );
  }

  static List<String> getContentCoverList(String htmlStr) {
    List<String> list = [];
    try {
      final dom = html.Document.html(htmlStr);
      final eles = dom.querySelectorAll('.galeria_img img');

      for (var ele in eles) {
        try {
          final url = ele.attributes['src'] ?? '';
          if (url.isEmpty) continue;
          list.add(url);
        } catch (e) {
          debugPrint(e.toString());
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return list;
  }

  @override
  String toString() {
    return '\ntitle => $title\nurl => $url\ncoverUrl => $coverUrl\nimdb => $imdb';
  }
}
