import 'package:cm_app/app/core/models/movie.dart';
import 'package:cm_app/app/ui/components/movie_bookmark_button.dart';
import 'package:cm_app/more_libs/setting_v2.8.3/setting.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/widgets/t_image.dart';

class PosterAppBar extends StatelessWidget {
  final Movie movie;
  final void Function()? onInit;
  const PosterAppBar({super.key, required this.movie, this.onInit});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SliverAppBar(
      expandedHeight: size.height * 0.5,
      flexibleSpace: Stack(
        fit: StackFit.expand,
        children: [
          TImage(source: Setting.getForwardProxyUrl(movie.poster)),
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
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Container(
          padding: EdgeInsets.only(left: 6, bottom: 2, top: 2),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
      ),
      actions: [
        // bookmark
        MovieBookmarkButton(movie: movie),
        IconButton(
          onPressed: () => onInit?.call(),
          icon: Container(
            padding: EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Icon(Icons.refresh, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Color _getAppbarImageGradientColor() {
    if (Setting.getAppConfig.isDarkTheme) {
      return Colors.black.withValues(alpha: 0.1);
    }
    return Colors.white.withValues(alpha: 0.1);
  }
}
