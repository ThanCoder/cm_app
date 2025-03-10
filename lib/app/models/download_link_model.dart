// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/widgets.dart';
import 'package:html/dom.dart' as html;

class DownloadLinkModel {
  String title;
  String url;
  String iconUrl;
  String size;
  String quality;
  DownloadLinkModel({
    required this.title,
    required this.url,
    required this.size,
    required this.quality,
    required this.iconUrl,
  });

  factory DownloadLinkModel.fromElement(html.Element ele) {
    var url = '';
    var title = '';
    var iconUrl = '';
    var size = '';
    var quality = '';
    if (ele.attributes['href'] != null) {
      try {
        url = ele.attributes['href'] ?? '';
      } catch (e) {
        debugPrint(e.toString());
      }
    }
    if (ele.querySelector('.b img') != null) {
      try {
        iconUrl = ele.querySelector('.b img')!.attributes['src'] ?? '';
      } catch (e) {
        debugPrint(e.toString());
      }
    }
    if (ele.querySelector('.b') != null) {
      try {
        title = ele.querySelector('.b')!.text;
      } catch (e) {
        debugPrint(e.toString());
      }
    }
    if (ele.querySelector('.c') != null) {
      try {
        size = ele.querySelector('.c')!.text;
      } catch (e) {
        debugPrint(e.toString());
      }
    }
    if (ele.querySelector('.d') != null) {
      try {
        quality = ele.querySelector('.d')!.text;
      } catch (e) {
        debugPrint(e.toString());
      }
    }
    return DownloadLinkModel(
      title: title,
      url: url,
      size: size,
      quality: quality,
      iconUrl: iconUrl,
    );
  }
  @override
  String toString() {
    return '\nserver => $title\n';
  }
}
