import 'package:cm_app/more_libs/setting/core/path_util.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_pkg/than_pkg.dart';

class CacheImage extends StatelessWidget {
  final String url;
  final VoidCallback? onTap;
  final Widget Function(String message)? placeholder;
  const CacheImage({
    super.key,
    required this.url,
    this.onTap,
    this.placeholder,
  });

  static String getCachePath(String url) => PathUtil.getCachePath(
    name: '${url.getName().replaceAll('/', '-').replaceAll(':', '-')}.png',
  );

  @override
  Widget build(BuildContext context) {
    return TCacheImage(
      url: url,
      placeholder: (message) =>
          placeholder != null ? placeholder!(message) : TImageFile(path: ''),
    );
    // return CachedNetworkImage(
    //   imageUrl: url,
    //   fit: BoxFit.cover,
    //   // placeholder: (context, url) => Text('placeholder'),
    //   errorWidget: (context, url, error) => Icon(Icons.broken_image_rounded),
    //   progressIndicatorBuilder: (context, url, progress) => TLoader.random(),
    // );
  }
}
