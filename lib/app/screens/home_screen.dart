import 'package:cm_app/app/pages/home/genres_page.dart';
import 'package:cm_app/app/pages/home/library_page.dart';
import 'package:flutter/material.dart';

import '../pages/index.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: TabBarView(
          children: [
            HomePage(),
            GenresPage(),
            LibraryPage(),
            AppMorePage(),
          ],
        ),
        bottomNavigationBar: TabBar(
          tabs: [
            Tab(
              text: 'Home',
              icon: Icon(Icons.home),
            ),
            Tab(
              text: 'Genres',
              icon: Icon(Icons.movie_filter_rounded),
            ),
            Tab(
              text: 'Library',
              icon: Icon(Icons.library_books_rounded),
            ),
            Tab(
              text: 'More',
              icon: Icon(Icons.grid_view_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
