import 'dart:io';

import 'package:cm_app/more_libs/setting_v2.8.3/setting.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';

class CacheImage extends StatelessWidget {
  final String url;
  const CacheImage({super.key, required this.url});
  @override
  Widget build(BuildContext context) {
    if (Setting.getAppConfig.isUseCacheImageWidget) {
      final cacheFile = File(TWidgets.instance.getCachePath?.call(url) ?? '');
      if (cacheFile.existsSync()) {
        return TImageFile(path: cacheFile.path, errorBuilder: _errorBuilder);
      }
      return FutureBuilder(
        future: TWidgets.instance.onDownloadImage?.call(url, cacheFile.path),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return TLoader.random();
          }
          return TImageFile(path: cacheFile.path, errorBuilder: _errorBuilder);
        },
      );
    }
    return TImage(source: url);
  }

  Widget _errorBuilder(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
  ) {
    return TImage(source: url);
  }
}
