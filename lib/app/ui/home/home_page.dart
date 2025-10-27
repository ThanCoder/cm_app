import 'package:cm_app/app/constants.dart';
import 'package:cm_app/app/core/models/movie.dart';
import 'package:cm_app/app/route_helper.dart';
import 'package:cm_app/app/ui/components/grid_movie_component.dart';
import 'package:cm_app/app/ui/drawer_menu/home_drawer.dart';
import 'package:cm_app/app/ui/home/recent_movie_component.dart';
import 'package:cm_app/app/ui/home/trending_movie_component.dart';
import 'package:cm_app/app/ui/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:than_pkg/than_pkg.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<GridMovieComponentState> movieKey = GlobalKey();
  final GlobalKey<GridMovieComponentState> tvShowKey = GlobalKey();
  final GlobalKey<TrendingMovieComponentState> trendingMovieKey = GlobalKey();
  final GlobalKey<TrendingMovieComponentState> trendingTvShowKey = GlobalKey();
  Future<void> init() async {
    movieKey.currentState?.init();
    tvShowKey.currentState?.init();
    trendingMovieKey.currentState?.init();
    trendingTvShowKey.currentState?.init();
  }

  @override
  Widget build(BuildContext context) {
    // print(movieList);
    return Scaffold(
      drawer: HomeDrawer(),
      body: RefreshIndicator.adaptive(
        onRefresh: init,
        child: CustomScrollView(slivers: _getViews()),
      ),
      // floatingActionButton: FloatingActionButton(onPressed: init),
    );
  }

  List<Widget> _getViews() {
    return [
      _getAppbar(),
      // search
      _getSearchBar(),
      // recent
      SliverToBoxAdapter(
        child: RecentMovieComponent(onClicked: _goMovieDetailScreen),
      ),
      // trending
      SliverToBoxAdapter(
        child: TrendingMovieComponent(
          key: trendingMovieKey,
          title: 'Trending Movies',
          url: apiMovieTrendingUrl,
          onClicked: _goMovieDetailScreen,
        ),
      ),
      SliverToBoxAdapter(child: SizedBox(height: 10)),
      SliverToBoxAdapter(
        child: TrendingMovieComponent(
          key: trendingTvShowKey,
          title: 'Trending TV Shows',
          url: apiTvShowTrendingUrl,
          onClicked: _goMovieDetailScreen,
        ),
      ),
      SliverToBoxAdapter(child: SizedBox(height: 10)),
      // grid
      SliverToBoxAdapter(
        child: GridMovieComponent(
          key: movieKey,
          url: apiMovieUrl,
          title: 'Movies',
          type: MovieTypes.movie,
        ),
      ),
      SliverToBoxAdapter(child: SizedBox(height: 15)),
      SliverToBoxAdapter(
        child: GridMovieComponent(
          key: tvShowKey,
          url: apiTvShowUrl,
          title: 'TV Shows',
          type: MovieTypes.tvShow,
        ),
      ),
    ];
  }

  Widget _getAppbar() {
    return SliverAppBar(
      title: Text('CM Movie'),
      pinned: false,
      snap: true,
      floating: true,
      actions: [
        !TPlatform.isDesktop
            ? SizedBox.shrink()
            : IconButton(onPressed: init, icon: Icon(Icons.refresh)),
      ],
    );
  }

  Widget _getSearchBar() {
    return SliverAppBar(
      title: GestureDetector(
        onTap: _goSearchScreen,
        child: Card(
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Search...'),
              ),
              Spacer(),
              IconButton(onPressed: _goSearchScreen, icon: Icon(Icons.search)),
            ],
          ),
        ),
      ),
      automaticallyImplyLeading: false,
    );
  }

  void _goMovieDetailScreen(Movie movie) {
    goMovieDetailScreen(context, movie: movie);
  }

  void _goSearchScreen() {
    goRoute(context, builder: (context) => SearchScreen());
  }
}
