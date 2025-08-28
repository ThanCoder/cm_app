import 'package:cm_app/app/components/movie_horizontal_list_view.dart';
import 'package:cm_app/app/models/movie.dart';
import 'package:cm_app/app/services/cm_services.dart';

import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';

class RandomMovieListView extends StatelessWidget {
  void Function(Movie movie) onClicked;
  RandomMovieListView({super.key, required this.onClicked});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: CMServices.getRandomList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return TLoader();
        }
        if (snapshot.hasData) {
          final list = snapshot.data ?? [];
          if (list.isEmpty) return SizedBox.shrink();

          return MovieHorizontalListView(
            title: 'Random Movies',
            list: list,
            onClicked: onClicked,
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}
