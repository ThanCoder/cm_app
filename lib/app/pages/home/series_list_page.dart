import 'package:cm_app/app/components/movie_see_all_list_view.dart';
import 'package:cm_app/app/providers/index.dart';
import 'package:cm_app/app/screens/see_all_series_screen.dart';
import 'package:cm_app/app/screens/content_screens/series_content_screen.dart';
import 'package:cm_app/app/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SeriesListPage extends StatelessWidget {
  const SeriesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SeriesProvider>();
    final isLoading = provider.isLoading;
    final list = provider.getList;
    if (isLoading) {
      return TLoader();
    }
    return MovieSeeAllListView(
      title: 'Latest Series',
      list: list,
      onClicked: (movie) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SeriesContentScreen(movie: movie),
          ),
        );
      },
      onSeeAllClicked: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SeeAllSeriesScreen(),
          ),
        );
      },
    );
  }
}
