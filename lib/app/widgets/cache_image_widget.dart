import 'package:cm_app/app/services/index.dart';
import 'package:cm_app/app/utils/index.dart';
import 'package:cm_app/app/widgets/core/index.dart';
import 'package:flutter/material.dart';

class CacheImageWidget extends StatefulWidget {
  String url;
  String? savedPath;
  BoxFit fit;
  CacheImageWidget({
    super.key,
    required this.url,
    this.savedPath,
    this.fit = BoxFit.cover,
  });

  @override
  State<CacheImageWidget> createState() => _CacheImageWidgetState();
}

class _CacheImageWidgetState extends State<CacheImageWidget> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
    super.initState();
  }

  bool isLoading = true;
  String savePath = '';

  Future<void> init() async {
    try {
      savePath =
          '${PathUtil.instance.getCachePath()}/${widget.url.split('/').last}';
      if (widget.savedPath != null && widget.savedPath!.isNotEmpty) {
        savePath = widget.savedPath!;
      }
      //download cache
      await DioServices.instance.downloadCover(
        url: widget.url,
        savePath: savePath,
      );

      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      debugPrint('init ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return TLoader();
    } else {
      return MyImageFile(
          path: savePath, width: double.infinity, fit: widget.fit);
    }
  }
}
