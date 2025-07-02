import 'package:cm_app/app/components/movie_grid_item.dart';
import 'package:cm_app/app/models/movie_model.dart';
import 'package:flutter/material.dart';

class MovieSeeAllListView extends StatelessWidget {
  String title;
  List<MovieModel> list;
  int showItemCount;
  void Function(MovieModel movie) onClicked;
  void Function(String title, List<MovieModel> list) onSeeAllClicked;
  void Function(MovieModel movie)? onMenuClicked;
  double? width;
  double? height;
  EdgeInsetsGeometry? margin;
  double padding;
  int showCount;
  int? showLines;
  double fontSize;

  MovieSeeAllListView({
    super.key,
    required this.title,
    required this.list,
    required this.onClicked,
    required this.onSeeAllClicked,
    this.onMenuClicked,
    this.showItemCount = 7,
    this.width = 160,
    this.height = 180,
    this.showCount = 8,
    this.margin,
    this.showLines,
    this.fontSize = 11,
    this.padding = 6,
  });

  @override
  Widget build(BuildContext context) {
    final showList = list.take(showCount).toList();
    if (showList.isEmpty) return const SizedBox.shrink();
    if (showLines != null && showList.length > 1) {
      showLines = 2;
    }

    return Container(
      padding: EdgeInsets.all(padding),
      margin: margin,
      child: SizedBox(
        height: (showLines ?? 1) * 160,
        child: Column(
          spacing: 5,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title),
                list.length > showCount
                    ? GestureDetector(
                        onTap: () => onSeeAllClicked(title, list),
                        child: const MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Text(
                            'See All',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
            Expanded(
              child: GridView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: showList.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 170,
                  mainAxisExtent: 130,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                ),
                itemBuilder: (context, index) => MovieGridItem(
                  movie: showList[index],
                  onClicked: onClicked,
                  onMenuClicked: onMenuClicked,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
