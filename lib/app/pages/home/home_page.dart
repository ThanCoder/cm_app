import 'dart:io';

import 'package:cm_app/app/components/movie_grid_item.dart';
import 'package:cm_app/app/customs/movie_search_delegate.dart';
import 'package:cm_app/app/providers/movie_provider.dart';
import 'package:cm_app/app/screens/content_screens/movie_content_screen.dart';
import 'package:cm_app/app/screens/see_all_movie_screen.dart';
import 'package:cm_app/app/screens/see_all_series_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../widgets/index.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
  }

  bool allRefersh = false;
  bool isLoading = true;

  Future<void> init() async {
    try {
      context.read<MovieProvider>().initHomeList(isListClear: allRefersh);
      allRefersh = false;
    } catch (e) {
      debugPrint('homePage:init ${e.toString()}');
    }
  }

  void _search() {
    showSearch(
      context: context,
      delegate: MovieSearchDelegate(
        onClicked: (movie) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MovieContentScreen(
                movie: movie,
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MovieProvider>();
    final isLoading = provider.isLoading;
    final list = provider.homeList;
    return MyScaffold(
      appBar: AppBar(
        title: Text(appTitle),
        actions: [
          IconButton(
            onPressed: _search,
            icon: Icon(Icons.search),
          ),
          Platform.isLinux
              ? IconButton(
                  onPressed: () {
                    allRefersh = true;
                    init();
                  },
                  icon: Icon(Icons.refresh),
                )
              : SizedBox.shrink(),
        ],
      ),
      body: isLoading
          ? TLoader()
          : list.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 5,
                    children: [
                      Text('List is Empty'),
                      IconButton(
                        color: Colors.blue,
                        onPressed: init,
                        icon: Icon(Icons.refresh),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    allRefersh = true;
                    init();
                  },
                  child: CustomScrollView(
                    slivers: [
                      //movies
                      SliverToBoxAdapter(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Latest Movie',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SeeAllMovieScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                'See All',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(height: 10),
                      ),
                      SliverGrid.builder(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 180,
                          mainAxisExtent: 200,
                          mainAxisSpacing: 5,
                          crossAxisSpacing: 5,
                        ),
                        itemCount: list.take(20).length,
                        itemBuilder: (context, index) => MovieGridItem(
                          movie: list.take(20).toList()[index],
                          onClicked: (movie) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MovieContentScreen(
                                  movie: movie,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(height: 30),
                      ),

                      //series
                      SliverToBoxAdapter(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Latest Series',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          SeeAllSeriesScreen(),
                                    ));
                              },
                              child: Text(
                                'See All',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(height: 10),
                      ),
                      SliverGrid.builder(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 180,
                          mainAxisExtent: 200,
                          mainAxisSpacing: 5,
                          crossAxisSpacing: 5,
                        ),
                        itemCount: list.skip(20).length,
                        itemBuilder: (context, index) => MovieGridItem(
                          movie: list.skip(20).toList()[index],
                          onClicked: (movie) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MovieContentScreen(
                                  movie: movie,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
