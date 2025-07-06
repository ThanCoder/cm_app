import 'package:cm_app/app/components/movie_cache_image_widget.dart';
import 'package:cm_app/app/models/movie_model.dart';
import 'package:cm_app/app/screens/content/movie_content_screen.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';

class SearchResultList extends StatelessWidget {
  List<MovieModel> list;
  SearchResultList({
    super.key,
    required this.list,
  });

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) {
      return Center(child: Text('မရှိပါ....'));
    }
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final movie = list[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MovieContentScreen(
                  movie: movie,
                ),
              ),
            );
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Row(
              spacing: 5,
              children: [
                SizedBox(
                  width: 110,
                  height: 130,
                  child: MovieCacheImageWidget(movie: movie),
                ),
                Expanded(
                  child: Column(
                    spacing: 5,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(movie.title),
                      Row(
                        spacing: 2,
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 20,
                          ),
                          Text(movie.imdb),
                        ],
                      ),
                      ExpandableText(
                        movie.desc,
                        expandText: 'Read More',
                        collapseOnTextTap: true,
                        collapseText: 'Read Less',
                        maxLines: 3,
                        linkColor: Colors.blue,
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
