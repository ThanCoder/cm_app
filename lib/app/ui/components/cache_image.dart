import 'package:cm_app/more_libs/setting_v2.8.3/setting.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';

class CacheImage extends StatelessWidget {
  final String url;
  final String? cachePath;
  const CacheImage({super.key, required this.url, this.cachePath});
  @override
  Widget build(BuildContext context) {
    if (Setting.getAppConfig.isUseCacheImageWidget) {
      return TCacheImage(
        url: url,
        errorBuilder: (context, error, stackTrace) {
          debugPrint('url: $url\n[error]: ${error.toString()}');
          return TImage(source: url);
        },
      );
    }
    return TImage(source: url);
  }
}
