import 'package:cm_app/app/components/imdb_icon.dart';
import 'package:cm_app/app/models/movie.dart';
import 'package:cm_app/my_libs/setting_v2.2.0/core/index.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/widgets/index.dart';

class MovieGridItem extends StatelessWidget {
  Movie movie;
  void Function(Movie movie) onClicked;
  void Function(Movie movie)? onMenuClicked;
  MovieGridItem({
    super.key,
    required this.movie,
    required this.onClicked,
    this.onMenuClicked,
  });

  Widget _getImdbWidget() {
    if (movie.imdb.isEmpty) {
      return SizedBox.shrink();
    }
    return ImdbIcon(title: movie.imdb);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onClicked(movie),
      onLongPress: () => onMenuClicked?.call(movie),
      onSecondaryTap: () => onMenuClicked?.call(movie),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Stack(
          children: [
            Positioned.fill(
              child: TCacheImage(
                url: movie.coverUrl,
                cachePath: PathUtil.getCachePath(),
              ),
            ),
            //text
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(139, 27, 27, 27),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  ),
                ),
                child: Text(
                  movie.title,
                  maxLines: 2,
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
            //imdb
            Positioned(left: 0, top: 0, child: _getImdbWidget()),
          ],
        ),
      ),
    );
  }
}
