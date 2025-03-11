import 'package:cm_app/app/components/movie_grid_item.dart';
import 'package:cm_app/app/models/movie_model.dart';
import 'package:flutter/material.dart';

class MovieSeeAllListView extends StatelessWidget {
  String title;
  List<MovieModel> list;
  int showItemCount;
  void Function(MovieModel movie) onClicked;
  void Function() onSeeAllClicked;
  MovieSeeAllListView({
    super.key,
    required this.title,
    required this.list,
    required this.onClicked,
    required this.onSeeAllClicked,
    this.showItemCount = 7,
  });

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) {
      return SizedBox.shrink();
    }
    return Column(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: onSeeAllClicked,
              child: Text(
                'See All',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              list.take(showItemCount).length,
              (index) {
                final movie = list[index];
                return Container(
                  margin: EdgeInsets.only(right: 5),
                  child: SizedBox(
                    width: 160,
                    height: 180,
                    child: MovieGridItem(movie: movie, onClicked: onClicked),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
