import 'dart:async';

import 'package:cm_app/app/core/models/movie.dart';
import 'package:cm_app/app/route_helper.dart';
import 'package:cm_app/app/services/movie_services.dart';
import 'package:cm_app/app/ui/components/movie_grid_item.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isSearching = false;
  List<Movie> list = [];
  Timer? _timer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search')),
      body: CustomScrollView(
        slivers: [_getSearchbar(), _getSearchingProgress(), _getResultList()],
      ),
    );
  }

  Widget _getSearchbar() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TSearchField(
          autofocus: true,
          onSubmitted: _onSearch,
          onChanged: (text) {
            if (isSearching) return;

            if (_timer?.isActive ?? false) {
              _timer?.cancel();
            }

            Timer(Duration(milliseconds: 1200), () => _onSearch(text));
          },
        ),
      ),
    );
  }

  Widget _getSearchingProgress() {
    return SliverToBoxAdapter(
      child: !isSearching
          ? null
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: LinearProgressIndicator(),
            ),
    );
  }

  Widget _getResultList() {
    return SliverGrid.builder(
      itemCount: list.length,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 180,
        mainAxisExtent: 220,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
      itemBuilder: (context, index) => MovieGridItem(
        movie: list[index],
        onClicked: (movie) => goMovieDetailScreen(context, movie: movie),
      ),
    );
  }

  Future<void> _onSearch(String text) async {
    try {
      setState(() {
        isSearching = true;
      });
      final url = '${MovieServices.apiSearchUrl}=$text';
      list = await MovieServices.getMovies(url);

      if (!mounted) return;
      setState(() {
        isSearching = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isSearching = false;
      });
      showTMessageDialogError(context, e.toString());
    }
  }
}
