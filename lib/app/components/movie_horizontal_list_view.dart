import 'package:cm_app/app/components/movie_grid_item.dart';
import 'package:cm_app/app/models/movie.dart';
import 'package:flutter/cupertino.dart';

class MovieHorizontalListView extends StatelessWidget {
  String title;
  List<Movie> list;
  void Function(Movie movie) onClicked;
  MovieHorizontalListView({
    super.key,
    required this.title,
    required this.list,
    required this.onClicked,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: list.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(right: 5),
                child: SizedBox(
                  width: 140,
                  height: 160,
                  child:
                      MovieGridItem(movie: list[index], onClicked: onClicked),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
