import 'package:cm_app/app/core/models/movie.dart';
import 'package:cm_app/app/ui/components/movie_grid_item.dart';
import 'package:flutter/material.dart';

class OneLineMovieComponent extends StatelessWidget {
  final String title;
  final List<Movie> list;
  final void Function(Movie movie)? onClicked;
  const OneLineMovieComponent({
    super.key,
    required this.title,
    required this.list,
    this.onClicked,
  });

  @override
  Widget build(BuildContext context) {
    return _getViews();
  }

  Widget _getViews() {
    if (list.isEmpty) {
      return SizedBox.shrink();
    }
    return SizedBox(
      height: 200,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 18)),
            Expanded(
              child: ListView.builder(
                itemCount: list.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => _getListItem(list[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getListItem(Movie movie) {
    return Container(
      margin: EdgeInsets.only(right: 5),
      child: SizedBox(
        width: 120,
        height: 150,
        child: MovieGridItem(movie: movie, onClicked: onClicked),
      ),
    );
  }
}
