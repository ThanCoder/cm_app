import 'dart:io';

import 'package:cm_app/app/components/movie_grid_item.dart';
import 'package:cm_app/app/components/random_movie_list_view.dart';
import 'package:cm_app/app/models/movie.dart';
import 'package:cm_app/app/routes_helper.dart';
import 'package:cm_app/app/screens/movie_result_screen.dart';
import 'package:cm_app/app/screens/search/search_screen.dart';
import 'package:cm_app/app/services/cm_home_page_services.dart';
import 'package:cm_app/my_libs/setting_v2.2.0/setting.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_pkg/than_pkg.dart';

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

  bool isLoading = false;
  bool isInternetConnected = true;
  List<Movie> homeList = [];

  Future<void> init({bool isReset = false}) async {
    try {
      if (!isReset && CMHomePageServices.getCacheList.isNotEmpty) {
        homeList = CMHomePageServices.getCacheList;
        setState(() {});
        return;
      }
      setState(() {
        isLoading = true;
      });

      isInternetConnected = await ThanPkg.platform.isInternetConnected();
      if (!mounted) return;
      if (!isInternetConnected) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      homeList = await CMHomePageServices.getHomeMovies(isReset: isReset);
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      debugPrint('homePage:init ${e.toString()}');
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Setting.appVersionLabel),
        actions: [
          IconButton(onPressed: _search, icon: Icon(Icons.search)),
          Platform.isLinux
              ? IconButton(
                  onPressed: () => init(isReset: true),
                  icon: Icon(Icons.refresh),
                )
              : SizedBox.shrink(),
        ],
      ),
      body: _getList(),
    );
  }

  Widget _getList() {
    if (!isInternetConnected) {
      return Center(
        child: Text('Your Are Offline', style: TextStyle(color: Colors.red)),
      );
    }
    if (isLoading) {
      return Center(child: TLoader.random());
    }
    if (homeList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('List Empty!'),
            IconButton(onPressed: () => init(), icon: Icon(Icons.refresh)),
          ],
        ),
      );
    }
    final movieList = homeList.sublist(
      0,
      homeList.length > 20 ? 20 : homeList.length,
    );
    final seriesList = homeList.length > 20 ? homeList.sublist(20) : [];
    return RefreshIndicator.adaptive(
      onRefresh: () async {
        await init(isReset: true);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomScrollView(
          slivers: [
            //random movies
            SliverToBoxAdapter(
              child: RandomMovieListView(onClicked: onClicked),
            ),
            // movie
            ..._getSeeAllWidet(
              title: 'Movie',
              list: movieList,
              onSeeAllClicked: (title) => onSeeAllClicked(title, 'movies'),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 16)),
            ..._getSeeAllWidet(
              title: 'Series',
              list: seriesList as List<Movie>,
              onSeeAllClicked: (title) => onSeeAllClicked(title, 'tvshows'),
            ),

            //series
          ],
        ),
      ),
    );
  }

  List<Widget> _getSeeAllWidet({
    required String title,
    required List<Movie> list,
    required void Function(String title) onSeeAllClicked,
  }) {
    return [
      SliverToBoxAdapter(
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Spacer(),
            _getMoreButton(onPressed: () => onSeeAllClicked(title)),
          ],
        ),
      ),
      SliverToBoxAdapter(child: SizedBox(height: 10)),
      SliverGrid.builder(
        itemCount: list.length,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 160,
          mainAxisExtent: 180,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
        ),
        itemBuilder: (context, index) =>
            MovieGridItem(movie: list[index], onClicked: onClicked),
      ),
      SliverToBoxAdapter(child: SizedBox(height: 10)),
      SliverToBoxAdapter(
        child: _getMoreButton(
          text: 'See All',
          onPressed: () => onSeeAllClicked(title),
        ),
      ),
    ];
  }

  Widget _getMoreButton({
    required VoidCallback onPressed,
    String text = 'More >',
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(textStyle: TextStyle(color: Colors.teal)),
      onPressed: onPressed,
      child: Text(text),
    );
  }

  void onSeeAllClicked(String title, String queryName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieResultScreen(
          title: title,
          url: '${Setting.getAppConfig.hostUrl}/$queryName',
        ),
      ),
    );
  }

  void onClicked(Movie movie) {
    goMovieContent(context, movie: movie);
  }

  void _search() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SearchScreen()),
    );
  }
}
