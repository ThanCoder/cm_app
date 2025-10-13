import 'dart:io';

import 'package:cm_app/more_libs/setting_v2.8.3/core/index.dart';
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
  bool isLoading = false;

  Future<void> init() async {
    try {
      setState(() {
        isLoading = true;
      });
      String defaultCache = PathUtil.getCachePath();
      if (widget.cachePath != null) {
        defaultCache = widget.cachePath!;
      }
      final file = File('$defaultCache/${widget.url.getName()}');
      // မရှိရင် download
      if (file.existsSync()) {
        cacheImageFile = file;
        if (!mounted) return;
        setState(() {
          isLoading = false;
        });
        return;
      }
      await TWidgets.instance.onDownloadImage?.call(widget.url, file.path);
      cacheImageFile = file;
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });

      // debugPrint('download: ${file.path}');
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      debugPrint('[CacheImage:init]: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return TLoader.random();
    }
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
