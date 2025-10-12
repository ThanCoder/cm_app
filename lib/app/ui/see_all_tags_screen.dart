import 'package:cm_app/app/core/models/movie.dart';
import 'package:cm_app/app/route_helper.dart';
import 'package:cm_app/app/services/movie_services.dart';
import 'package:cm_app/app/ui/components/movie_grid_item.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';

class SeeAllTagsScreen extends StatefulWidget {
  final Widget title;
  final String url;
  const SeeAllTagsScreen({super.key, required this.title, required this.url});

  @override
  State<SeeAllTagsScreen> createState() => _SeeAllTagsScreenState();
}

class _SeeAllTagsScreenState extends State<SeeAllTagsScreen> {
  final scrollController = ScrollController();

  @override
  void initState() {
    hostUrl = widget.url;
    scrollController.addListener(_onScroll);
    super.initState();
    init();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  bool isLoading = false;
  bool nextPageFetching = false;
  bool isNextPageFetchingError = false;
  List<Movie> list = [];
  late String hostUrl;
  int page = 1;

  Future<void> init() async {
    try {
      setState(() {
        isLoading = true;
      });
      list = await MovieServices.getMovies(widget.url);

      if (!mounted) return;
      isLoading = false;
      setState(() {});
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      showTMessageDialog(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator.noSpinner(
        onRefresh: init,
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            _getAppbar(),
            _getListWidget(),
            _getNextPageFetchingLoader(),
          ],
        ),
      ),
    );
  }

  Widget _getNextPageFetchingLoader() {
    return SliverToBoxAdapter(
      child: nextPageFetching
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: TLoader(size: 30),
            )
          : null,
    );
  }

  Widget _getAppbar() {
    return SliverAppBar(
      title: widget.title,
      floating: true,
      // pinned: true,
      snap: true,
    );
  }

  Widget _getListWidget() {
    if (isLoading) {
      return SliverFillRemaining(child: Center(child: TLoader.random()));
    }
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

  // scroll
  void _onScroll() {
    if (list.isEmpty) return;
    if (isNextPageFetchingError) return;
    if (nextPageFetching) return;
    final pos = scrollController.position;
    // print('pos: ${pos.pixels} - max:${pos.maxScrollExtent}');
    if (pos.pixels == pos.maxScrollExtent) {
      fetchNextUrl();
    }
  }

  Future<void> fetchNextUrl() async {
    try {
      setState(() {
        nextPageFetching = true;
      });
      page++;
      final url = '$hostUrl?page=$page';
      final res = await MovieServices.getMovies(url);
      list.addAll(res);
      nextPageFetching = false;
      setState(() {});

      await Future.delayed(Duration(seconds: 3));
      if (!mounted) return;
      isNextPageFetchingError = false;
    } catch (e) {
      if (!mounted) return;
      setState(() {
        nextPageFetching = false;
        isNextPageFetchingError = true;
      });
      showTMessageDialog(context, e.toString());
    }
  }
}
