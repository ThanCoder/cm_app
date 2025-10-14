import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';

class CacheImage extends StatelessWidget {
  final String url;
  final String? cachePath;
  const CacheImage({super.key, required this.url, this.cachePath});
  @override
  Widget build(BuildContext context) {
    return TCacheImage(url: url);
  }
}
