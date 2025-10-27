import 'package:cm_app/app/core/models/movie.dart';
import 'package:cm_app/app/ui/components/cache_image.dart';
import 'package:cm_app/more_libs/setting_v2.8.3/setting.dart';
import 'package:flutter/material.dart';

class PosterAppBar extends StatefulWidget {
  final Movie movie;
  const PosterAppBar({super.key, required this.movie});

  @override
  State<PosterAppBar> createState() => _PosterAppBarState();
}

class _PosterAppBarState extends State<PosterAppBar> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SliverAppBar(
      expandedHeight: size.height * 0.6,
      automaticallyImplyLeading: false,
      flexibleSpace: Stack(
        fit: StackFit.expand,
        children: [
          CacheImage(url: Setting.getForwardProxyUrl(widget.movie.poster)),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  _getAppbarImageGradientColor(),
                  Colors.transparent,
                  _getAppbarImageGradientColor(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getAppbarImageGradientColor() {
    if (Setting.getAppConfig.isDarkTheme) {
      return Colors.black.withValues(alpha: 0.1);
    }
    return Colors.white.withValues(alpha: 0.1);
  }
}
