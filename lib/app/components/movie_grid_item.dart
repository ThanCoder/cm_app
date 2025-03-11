import 'package:cm_app/app/components/imdb_icon.dart';
import 'package:cm_app/app/components/movie_cache_image_widget.dart';
import 'package:cm_app/app/models/movie_model.dart';
import 'package:flutter/material.dart';

class MovieGridItem extends StatelessWidget {
  MovieModel movie;
  void Function(MovieModel movie) onClicked;
  MovieGridItem({
    super.key,
    required this.movie,
    required this.onClicked,
  });

  Widget _getImdbWidget() {
    if (movie.imdb.isEmpty) {
      return SizedBox.shrink();
    }
    return Container(
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: const Color.fromARGB(184, 15, 15, 15),
        borderRadius: BorderRadius.circular(5),
      ),
      child: ImdbIcon(title: movie.imdb),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onClicked(movie),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: MovieCacheImageWidget(movie: movie),
                ),
              ],
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
                    )),
                child: Text(
                  movie.title,
                  maxLines: 2,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            //imdb
            Positioned(
              left: 0,
              top: 0,
              child: _getImdbWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
