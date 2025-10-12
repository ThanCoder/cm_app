import 'package:cm_app/app/core/models/movie.dart';
import 'package:cm_app/more_libs/setting_v2.8.3/setting.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';

class MovieGridItem extends StatelessWidget {
  final Movie movie;
  final void Function(Movie movie)? onClicked;
  const MovieGridItem({super.key, required this.movie, this.onClicked});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onClicked?.call(movie),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Stack(
          children: [
            Positioned.fill(
              child: TImage(source: Setting.getForwardProxyUrl(movie.poster)),
              // child: TCacheImage(
              //   url: Setting.getForwardProxyUrl(movie.poster),
              //   cachePath: PathUtil.getCachePath(),
              // ),
            ),
            // imdb
            Positioned(left: 0, child: _getImdb(movie)),
            Positioned(right: 0, child: _getMovieType(movie)),

            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(4),
                    bottomRight: Radius.circular(4),
                  ),
                ),
                child: Text(
                  movie.title,
                  style: TextStyle(fontSize: 13, color: Colors.white),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getMovieType(Movie movie) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: .5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Icon(
        movie.type == MovieTypes.tvShow ? Icons.tv : Icons.movie,
        color: Colors.yellow,
        size: 20,
      ),
    );
  }

  Widget _getImdb(Movie movie) {
    return Container(
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Icon(Icons.star, color: Colors.yellow, size: 15),
          Text(
            movie.rating,
            style: TextStyle(color: Colors.white, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
