import 'package:cm_app/app/constants.dart';
import 'package:cm_app/app/route_helper.dart';
import 'package:cm_app/app/ui/home/movie_year_page.dart';
import 'package:cm_app/app/ui/home/tag_and_genres_page.dart';
import 'package:cm_app/app/ui/screens/see_all_tags_screen.dart';
import 'package:flutter/material.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,

      child: Scaffold(
        appBar: AppBar(
          title: Text('Library'),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              // movie years
              Tab(text: 'Movie Years', icon: Icon(Icons.calendar_month)),

              // movie
              Tab(text: 'Movie Genres', icon: Icon(Icons.tag_sharp)),
              Tab(text: 'Movie Tags ', icon: Icon(Icons.tag_sharp)),
              // tv
              Tab(text: 'TV Genres', icon: Icon(Icons.tag_sharp)),
              Tab(text: 'TV Tags ', icon: Icon(Icons.tag_sharp)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            MovieYearPage(
              onClicked: (item) => _goSeeAllScreen(
                'Movie Years: ${item.year}',
                '$apiMovieByYearUrl/${item.year}',
              ),
            ),
            // movie
            TagAndGenresPage(
              url: apiMovieGenresUrl,
              onClicked: (item) => _goSeeAllScreen(
                'Movie Genres',
                '$apiMovieGenresUrl/${item.id}',
              ),
            ),
            TagAndGenresPage(
              url: apiMovieTagsUrl,
              onClicked: (item) =>
                  _goSeeAllScreen('Movie Tags', '$apiMovieTagsUrl/${item.id}'),
            ),
            // tv
            TagAndGenresPage(
              url: apiTvShowGenresUrl,
              onClicked: (item) => _goSeeAllScreen(
                'TV Show Genres',
                '$apiTvShowGenresUrl/${item.id}',
              ),
            ),
            TagAndGenresPage(
              url: apiTvShowTagsUrl,
              onClicked: (item) => _goSeeAllScreen(
                'TV Show Tags',
                '$apiTvShowTagsUrl/${item.id}',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _goSeeAllScreen(String title, String url) {
    goRoute(
      context,
      builder: (context) => SeeAllTagsScreen(title: Text(title), url: url),
    );
  }
}
