import 'package:cm_app/app/constants.dart';
import 'package:cm_app/app/core/models/movie.dart';
import 'package:cm_app/app/route_helper.dart';
import 'package:cm_app/app/ui/home/grid_movie_component.dart';
import 'package:cm_app/app/ui/drawer_menu/home_drawer.dart';
import 'package:cm_app/app/ui/home/recent_movie_component.dart';
import 'package:cm_app/app/ui/home/trending_movie_component.dart';
import 'package:cm_app/app/ui/screens/search_screen.dart';
import 'package:cm_app/more_libs/language/language_controller.dart';
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
    movieKey.currentState?.init(isUsedCached: false);
    tvShowKey.currentState?.init(isUsedCached: false);
    trendingMovieKey.currentState?.init(isUsedCached: false);
    trendingTvShowKey.currentState?.init(isUsedCached: false);
  }

  @override
  Widget build(BuildContext context) {
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
          title: LanguageController.instance.getLan('trending_movies'),
          url: apiMovieTrendingUrl,
          onClicked: _goMovieDetailScreen,
        ),
      ),
      SliverToBoxAdapter(child: SizedBox(height: 10)),
      SliverToBoxAdapter(
        child: TrendingMovieComponent(
          key: trendingTvShowKey,
          title: LanguageController.instance.getLan('trending_tv_show'),
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
          title: LanguageController.instance.getLan('movies'),
          type: MovieTypes.movie,
        ),
      ),
      SliverToBoxAdapter(child: SizedBox(height: 15)),
      SliverToBoxAdapter(
        child: GridMovieComponent(
          key: tvShowKey,
          url: apiTvShowUrl,
          title: LanguageController.instance.getLan('tv_shows'),
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
      snap: true,
      floating: true,
      pinned: false,
      title: GestureDetector(
        onTap: _goSearchScreen,
        child: Card(
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: LanguageController.instance.didLanguageChanged(
                  'search',
                  builder: (langValue) => Text('$langValue...'),
                ),
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
