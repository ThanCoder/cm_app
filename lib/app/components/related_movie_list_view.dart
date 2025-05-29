import 'package:cm_app/app/components/movie_horizontal_list_view.dart';
import 'package:cm_app/app/models/movie_model.dart';
import 'package:cm_app/app/services/c_m_services.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';

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
      future: CMServices.getRelatedList(url),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return TLoader();
        }
        if (snapshot.hasData) {
          final list = snapshot.data ?? [];
          if (list.isEmpty) return SizedBox.shrink();

          return MovieHorizontalListView(
            title: 'Related Movies',
            list: list,
            onClicked: onClicked,
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}
