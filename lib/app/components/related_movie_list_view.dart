import 'package:cm_app/app/components/movie_grid_item.dart';
import 'package:cm_app/app/models/movie_model.dart';
import 'package:cm_app/app/services/c_m_services.dart';
import 'package:cm_app/app/widgets/core/t_loader.dart';
import 'package:flutter/material.dart';

class RelatedMovieListView extends StatelessWidget {
  String url;
  void Function(MovieModel movie) onClicked;
  RelatedMovieListView({
    super.key,
    required this.url,
    required this.onClicked,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: CMServices.instance.getRelatedList(url),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return TLoader();
        }
        if (snapshot.hasData) {
          final list = snapshot.data ?? [];
          if (list.isEmpty) return SizedBox.shrink();

          return Column(
            spacing: 5,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Related Movies'),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  spacing: 5,
                  children: List.generate(list.length, (index) {
                    return SizedBox(
                      width: 140,
                      height: 160,
                      child: MovieGridItem(
                          movie: list[index], onClicked: onClicked),
                    );
                  }),
                ),
              ),
            ],
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}
