// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cm_app/app/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as html;

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
    var title = '';
    var url = '';
    var coverUrl = '';
    var coverPath = '';
    var imdb = '';
    var desc = '';
    if (ele.querySelector('.fixyear h2') != null) {
      try {
        title = ele.querySelector('.fixyear h2')!.text;
      } catch (e) {
        debugPrint(e.toString());
      }
    }
    if (ele.querySelector('a') != null) {
      try {
        url = ele.querySelector('a')!.attributes['href'] ?? '';
      } catch (e) {
        debugPrint(e.toString());
      }
    }
    if (ele.querySelector('.image img') != null) {
      try {
        coverUrl = ele.querySelector('.image img')!.attributes['src'] ?? '';
      } catch (e) {
        debugPrint(e.toString());
      }
    }
    if (ele.querySelector('.imdb') != null) {
      try {
        imdb = ele.querySelector('.imdb')!.text;
      } catch (e) {
        debugPrint(e.toString());
      }
    }
    if (ele.querySelector('.boxinfo .ttx') != null) {
      try {
        desc = ele.querySelector('.boxinfo .ttx')!.text;
      } catch (e) {
        debugPrint(e.toString());
      }
    }
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
