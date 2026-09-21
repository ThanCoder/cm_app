import 'package:cm_app/keys.dart';
import 'package:flutter/material.dart';

class MImage extends StatelessWidget {
  const new({super.key, required this.source, this.fit});
  final String source;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    final col = Theme.of(context).colorScheme;
    // return Icon(Icons.broken_image_outlined, size: 80);
    return Image.network(
      '$forwardProxy?url=$source',
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) {
        return Container(
          color: col.surfaceContainerHighest,
          child: const Icon(Icons.broken_image_outlined),
        );
      },
    );
  }
}
