import 'package:cm_app/app/models/movie_model.dart';
import 'package:cm_app/app/widgets/index.dart';
import 'package:flutter/material.dart';

class MovieItem extends StatelessWidget {
  MovieModel movie;
  void Function(MovieModel movie) onClicked;
  MovieItem({
    super.key,
    required this.movie,
    required this.onClicked,
  });

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
                  child: MyImageFile(
                    path: movie.coverPath,
                    width: double.infinity,
                  ),
                ),
              ],
            ),
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
          ],
        ),
      ),
    );
  }
}
