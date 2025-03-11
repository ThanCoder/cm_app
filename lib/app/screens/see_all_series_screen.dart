import 'package:cm_app/app/components/movie_grid_item.dart';
import 'package:cm_app/app/providers/index.dart';
import 'package:cm_app/app/screens/content_screens/movie_content_screen.dart';
import 'package:cm_app/app/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SeeAllSeriesScreen extends StatefulWidget {
  const SeeAllSeriesScreen({super.key});

  @override
  State<SeeAllSeriesScreen> createState() => _SeeAllSeriesScreenState();
}

class _SeeAllSeriesScreenState extends State<SeeAllSeriesScreen> {
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

  double lastScroll = 0;
  bool isNextPage = true;

  void _onScroll() {
    if (lastScroll != scrollController.position.maxScrollExtent &&
        scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
      lastScroll = scrollController.position.maxScrollExtent;
      _loadData();
    }
  }

  void _loadData() {
    setState(() {
      isNextPage = true;
    });
    context.read<SeriesProvider>().nextPage();
  }

  void init() {
    setState(() {
      isNextPage = false;
    });
    context.read<SeriesProvider>().initList(isListClear: true);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SeriesProvider>();
    final isLoading = provider.isLoading;
    final list = provider.getList;

    return MyScaffold(
      contentPadding: 0,
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverAppBar(
            title: Text('Series'),
            floating: true,
            snap: true,
          ),
          //is loading
          SliverToBoxAdapter(
            child: isLoading && !isNextPage ? TLoader() : SizedBox.shrink(),
          ),

          //list
          SliverGrid.builder(
            itemCount: list.length,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 180,
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
                    builder: (context) => MovieContentScreen(movie: movie),
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
