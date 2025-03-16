import 'package:cm_app/app/components/movie_grid_item.dart';
import 'package:cm_app/app/providers/index.dart';
import 'package:cm_app/app/screens/content_screens/movie_content_screen.dart';
import 'package:cm_app/app/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SeeAllMovieScreen extends StatefulWidget {
  const SeeAllMovieScreen({super.key});

  @override
  State<SeeAllMovieScreen> createState() => _SeeAllMovieScreenState();
}

class _SeeAllMovieScreenState extends State<SeeAllMovieScreen> {
  final ScrollController scrollController = ScrollController();
  @override
  void initState() {
    scrollController.addListener(_onScroll);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void init() {
    setState(() {
      isNextPage = false;
    });
    context.read<MovieProvider>().initList(isListClear: true);
  }

  double lastScroll = 0;
  bool isNextPage = true;
  bool isDataLoading = false;

  void _onScroll() {
    if (!isDataLoading &&
        lastScroll != scrollController.position.maxScrollExtent &&
        scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
      lastScroll = scrollController.position.maxScrollExtent;
      isDataLoading = true;
      _loadData();
    }
  }

  void _loadData() async {
    setState(() {
      isNextPage = true;
    });
    await context.read<MovieProvider>().nextPage();
    isDataLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MovieProvider>();
    final isLoading = provider.isLoading;
    final list = provider.getList;

    return MyScaffold(
      contentPadding: 0,
      body: isLoading && !isNextPage
          ? TLoader()
          : CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverAppBar(
                  title: Text('Movie'),
                  floating: true,
                  snap: true,
                ),

                //list
                SliverGrid.builder(
                  itemCount: list.length,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 160,
                    mainAxisExtent: 180,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                  ),
                  itemBuilder: (context, index) => MovieGridItem(
                    movie: list[index],
                    onClicked: (movie) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MovieContentScreen(movie: movie),
                        ),
                      );
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: isLoading && isNextPage
                      ? Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: TLoader(size: 30))
                      : SizedBox.shrink(),
                ),
              ],
            ),
    );
  }
}
