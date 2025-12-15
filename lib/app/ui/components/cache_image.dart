import 'dart:io';
import 'package:cm_app/app/core/app_setting/cache_image_setting_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';

class CacheImage extends StatelessWidget {
  final String url;
  const CacheImage({super.key, required this.url});
  @override
  Widget build(BuildContext context) {
    if (CacheImageSettingListTile.isUseCacheImage) {
      final cacheFile = File(TWidgets.instance.getCachePath?.call(url) ?? '');
      if (cacheFile.existsSync()) {
        // return TImage(source: url);
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
    print('error');
    return TImage(source: url);
  }
}
