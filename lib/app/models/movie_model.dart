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
  MovieModel({
    required this.title,
    required this.url,
    required this.coverUrl,
    required this.imdb,
    this.coverPath = '',
  });

  factory MovieModel.fromElement(html.Element ele) {
    var title = '';
    var url = '';
    var coverUrl = '';
    var coverPath = '';
    var imdb = '';
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
    );
  }
  @override
  String toString() {
    return '\ntitle => $title\nurl => $url\ncoverUrl => $coverUrl\nimdb => $imdb';
  }
}
