import 'package:cm_app/app/core/models/movie.dart';
import 'package:cm_app/app/route_helper.dart';
import 'package:cm_app/app/services/movie_services.dart';
import 'package:cm_app/app/ui/components/movie_grid_item.dart';
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

  List<Movie> movieList = [];
  List<Movie> tvList = [];
  bool isLoading = false;

  Future<void> init() async {
    try {
      setState(() {
        isLoading = true;
      });
      movieList = await MovieServices.getMovies(MovieServices.apiMovieUrl);
      tvList = await MovieServices.getMovies(MovieServices.apiTvShowUrl);
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
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: RefreshIndicator.adaptive(
          onRefresh: init,
          child: CustomScrollView(slivers: _getViews()),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: init),
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
      // movie grid
      ..._getMovieGrid(
        list: movieList,
        title: 'Movies',
        type: MovieTypes.movie,
      ),
      SliverToBoxAdapter(child: SizedBox(height: 15)),
      ..._getMovieGrid(
        list: tvList,
        title: 'TV Shows',
        type: MovieTypes.tvShow,
      ),
    ];
  }

  Widget _getAppbar() {
    return SliverAppBar(title: Text('CM Movie'));
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
                child: Text(
                  'More >',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
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
          maxCrossAxisExtent: 180,
          mainAxisExtent: 220,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
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
}
