import 'package:cm_app/app/constants.dart';
import 'package:cm_app/app/core/models/movie.dart';
import 'package:cm_app/app/route_helper.dart';
import 'package:cm_app/app/services/movie_services.dart';
import 'package:cm_app/app/ui/components/movie_grid_item.dart';
import 'package:cm_app/app/ui/drawer_menu/home_drawer.dart';
import 'package:cm_app/app/ui/home/recent_movie_component.dart';
import 'package:cm_app/app/ui/home/trending_movie_component.dart';
import 'package:cm_app/app/ui/screens/search_screen.dart';
import 'package:cm_app/app/ui/screens/see_all_screen.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    init();
  }

  static List<Movie> movieList = [];
  static List<Movie> tvList = [];
  bool isLoading = false;

  Future<void> init({bool isUsedCache = true}) async {
    try {
      if (isUsedCache && movieList.isNotEmpty) return;
      setState(() {
        isLoading = true;
      });
      movieList = await MovieServices.getMovies(apiMovieUrl);
      tvList = await MovieServices.getMovies(apiTvShowUrl);
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      showTMessageDialogError(context, 'Error ရှိနေပါတယ်။\n${e.toString()}');
    }
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
    if (isLoading) {
      return [
        _getAppbar(),
        SliverFillRemaining(child: Center(child: TLoader.random())),
      ];
    }
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
          title: 'Trending Movies',
          url: apiMovieTrendingUrl,
          onClicked: _goMovieDetailScreen,
        ),
      ),
      SliverToBoxAdapter(child: SizedBox(height: 10)),
      SliverToBoxAdapter(
        child: TrendingMovieComponent(
          title: 'Trending TV Shows',
          url: apiTvShowTrendingUrl,
          onClicked: _goMovieDetailScreen,
        ),
      ),
      SliverToBoxAdapter(child: SizedBox(height: 10)),
      // movie grid
      ..._getMovieGrid(
        list: movieList,
        title: 'Movies',
        type: MovieTypes.movie,
        onSeeAllPage: _goSeeAllScreen,
      ),
      SliverToBoxAdapter(child: SizedBox(height: 15)),
      ..._getMovieGrid(
        list: tvList,
        title: 'TV Shows',
        type: MovieTypes.tvShow,
        onSeeAllPage: _goSeeAllScreen,
      ),
    ];
  }

  Widget _getAppbar() {
    return SliverAppBar(
      title: Text('CM Movie'),
      pinned: false,
      snap: true,
      floating: true,
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

  List<Widget> _getMovieGrid({
    required List<Movie> list,
    required String title,
    required MovieTypes type,
    void Function(MovieTypes type)? onSeeAllPage,
  }) {
    if (list.isEmpty) return [];
    return [
      // movie grid
      SliverToBoxAdapter(
        child: Container(
          margin: EdgeInsets.only(bottom: 6),
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              GestureDetector(
                onTap: () => onSeeAllPage?.call(type),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Text(
                    'More >',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      SliverGrid.builder(
        itemCount: list.length,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 140,
          mainAxisExtent: 170,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
        ),
        itemBuilder: (context, index) =>
            MovieGridItem(movie: list[index], onClicked: _goMovieDetailScreen),
      ),
      SliverToBoxAdapter(
        child: Container(
          margin: EdgeInsets.only(top: 10),
          child: TextButton(
            style: TextButton.styleFrom(backgroundColor: Colors.blue),
            onPressed: () => onSeeAllPage?.call(type),
            child: Text('See More', style: TextStyle(color: Colors.white)),
          ),
        ),
      ),
    ];
  }

  void _goMovieDetailScreen(Movie movie) {
    goMovieDetailScreen(context, movie: movie);
  }

  void _goSeeAllScreen(MovieTypes type) {
    goRoute(context, builder: (context) => SeeAllScreen(type: type));
  }

  void _goSearchScreen() {
    goRoute(context, builder: (context) => SearchScreen());
  }
}
