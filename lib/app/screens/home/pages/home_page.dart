import 'dart:io';

import 'package:cm_app/app/components/movie_grid_item.dart';
import 'package:cm_app/app/components/random_movie_list_view.dart';
import 'package:cm_app/app/customs/movie_search_delegate.dart';
import 'package:cm_app/app/models/movie_model.dart';
import 'package:cm_app/app/providers/movie_provider.dart';
import 'package:cm_app/my_libs/general_server_v1.0.0/general_server_noti_button.dart';
import 'package:cm_app/my_libs/setting/app_notifier.dart';
import 'package:cm_app/app/screens/content/movie_content_screen.dart';
import 'package:cm_app/app/screens/movie_result_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:t_widgets/t_widgets.dart';

import '../../../constants.dart';

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
      // allRefersh = false;
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

  Widget _getList(List<MovieModel> list) {
    return CustomScrollView(
      slivers: [
        // app bar
        SliverAppBar(
          title: Text(appTitle),
          snap: true,
          floating: true,
          actions: [
            IconButton(
              onPressed: _search,
              icon: Icon(Icons.search),
            ),
            GeneralServerNotiButton(),
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

        //random movies
        SliverToBoxAdapter(
          child: RandomMovieListView(
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

        //movies
        SliverToBoxAdapter(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Latest Movie',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieResultScreen(
                        title: 'Movies',
                        url: '${appConfigNotifier.value.hostUrl}/movies',
                      ),
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
            maxCrossAxisExtent: 160,
            mainAxisExtent: 180,
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
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieResultScreen(
                        title: 'Series',
                        url: '${appConfigNotifier.value.hostUrl}/tvshows',
                      ),
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
            maxCrossAxisExtent: 160,
            mainAxisExtent: 180,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MovieProvider>();
    final isLoading = provider.isLoading;
    final list = provider.homeList;
    return Scaffold(
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
                  child: _getList(list),
                ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     CMServices.instance.getYearList();
      //   },
      //   child: Icon(Icons.add),
      // ),
    );
  }
}
