import 'package:cm_app/app/core/models/movie.dart';
import 'package:cm_app/app/ui/components/cache_image.dart';
import 'package:cm_app/more_libs/setting_v2.8.3/core/path_util.dart';
import 'package:cm_app/more_libs/setting_v2.8.3/setting.dart';
import 'package:flutter/material.dart';

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
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            spacing: 3,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: CacheImage(
                        url: Setting.getForwardProxyUrl(movie.poster),
                        cachePath: PathUtil.getCachePath(),
                      ),
                      // child: TCacheImage(
                      //   url: Setting.getForwardProxyUrl(movie.poster),
                      //   cachePath: PathUtil.getCachePath(),
                      // ),
                    ),
                    // imdb
                    Positioned(left: 2, top: 2, child: _getImdb(movie)),
                    Positioned(right: 2, top: 2, child: _getMovieType(movie)),
                    Positioned(
                      left: 2,
                      bottom: 2,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 1,
                          horizontal: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          movie.year,
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                movie.title,
                style: TextStyle(fontSize: 12, color: Colors.white),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
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
        size: 15,
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
