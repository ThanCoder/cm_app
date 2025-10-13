import 'dart:io';

import 'package:flutter/material.dart';
import 'package:t_widgets/internal.dart';
import 'package:t_widgets/t_widgets.dart';

class CacheImage extends StatefulWidget {
  final String url;
  final String? cachePath;
  const CacheImage({super.key, required this.url, this.cachePath});

  @override
  State<CacheImage> createState() => _CacheImageState();
}

class _CacheImageState extends State<CacheImage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
  }

  File? cacheImageFile;

  Future<void> init() async {
    try {
      if (widget.cachePath == null) return;
      final file = File('${widget.cachePath}/${widget.url.getName()}');
      // မရှိရင် download
      if (file.existsSync()) {
        cacheImageFile = file;
        return;
      }
      await TWidgets.instance.onDownloadImage?.call(widget.url, file.path);
      cacheImageFile = file;

      // debugPrint('download: ${file.path}');
    } catch (e) {
      debugPrint('[CacheImage:init]: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (cacheImageFile != null) {
      // print('cache: $cacheImageFile');
      return Image.file(
        fit: BoxFit.cover,
        cacheImageFile!,
        errorBuilder: (context, error, stackTrace) {
          debugPrint(
            '[CacheImage:Image.file:errorBuilder]: ${error.toString()}',
          );

          if (cacheImageFile!.existsSync()) {
            cacheImageFile!.deleteSync();
          }
          return Center(child: Text('Image Error'));
        },
      );
    }
    return TImage(source: widget.url);
  }
}
