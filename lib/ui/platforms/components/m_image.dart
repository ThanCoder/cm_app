import 'package:cached_network_image/cached_network_image.dart';
import 'package:cm_app/core/utils/api_utils.dart';
import 'package:flutter/material.dart';

class MImage extends StatelessWidget {
  const new({
    super.key,
    required this.source,
    this.fit,
    this.height,
    this.width,
  });
  final String source;
  final BoxFit? fit;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    // final col = Theme.of(context).colorScheme;
    // return Icon(Icons.broken_image_outlined, size: 80);
    // print('url: ${ApiUtils.getAutoForwardProxyUrl(source)}');
    return CachedNetworkImage(
      imageUrl:ApiUtils.getAutoForwardProxyUrl(source),
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
      errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
    );

    // return Image.network(
    //   ApiUtils.getAutoForwardProxyUrl(source),
    //   width: width,
    //   height: height,
    //   fit: BoxFit.cover,
    //   errorBuilder: (_, _, _) {
    //     return Container(
    //       color: col.surfaceContainerHighest,
    //       child: const Icon(Icons.broken_image_outlined, size: 80),
    //     );
    //   },
    // );
  }
}
