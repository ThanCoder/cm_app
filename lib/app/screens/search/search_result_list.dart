import 'package:cm_app/app/models/movie.dart';
import 'package:cm_app/app/routes_helper.dart';
import 'package:cm_app/my_libs/setting_v2.2.0/core/index.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/widgets/index.dart';

class SearchResultList extends StatelessWidget {
  List<Movie> list;
  SearchResultList({super.key, required this.list});

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
            goMovieContent(context, movie: movie);
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Row(
              spacing: 5,
              children: [
                SizedBox(
                  width: 110,
                  height: 130,
                  child: TCacheImage(
                    url: movie.coverUrl,
                    cachePath: PathUtil.getCachePath(),
                  ),
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
                          Icon(Icons.star, color: Colors.amber, size: 20),
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
                        style: TextStyle(fontSize: 13),
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
