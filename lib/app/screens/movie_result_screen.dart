import 'package:cm_app/app/components/movie_grid_item.dart';
import 'package:cm_app/app/models/movie_model.dart';
import 'package:cm_app/app/screens/movie_content_screen.dart';
import 'package:cm_app/app/services/c_m_services.dart';
import 'package:cm_app/app/widgets/core/index.dart';
import 'package:flutter/material.dart';

class MovieResultScreen extends StatefulWidget {
  String title;
  String url;

  MovieResultScreen({super.key, required this.title, required this.url});

  @override
  State<MovieResultScreen> createState() => _MovieResultScreenState();
}

class _MovieResultScreenState extends State<MovieResultScreen> {
  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => init(widget.url));
  }

  final ScrollController scrollController = ScrollController();
  double lastScroll = 0;
  bool isLoading = true;
  bool isDataLoading = false;
  bool isNextPage = false;
  List<MovieModel> list = [];
  String? nextUrl;

  void init(String url) async {
    setState(() {
      isLoading = true;
    });

    await CMServices.instance.getMovieList(
      url: url,
      onResult: (_list, _nextUrl) {
        if (!mounted) return;
        list.addAll(_list);

        setState(() {
          isLoading = false;
          isNextPage = false;
          nextUrl = _nextUrl;
        });
      },
    );
    isDataLoading = false;
  }

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

  void _loadData() {
    if (nextUrl == null || nextUrl!.isEmpty) return;
    isNextPage = true;
    init(nextUrl!);
  }

  @override
  Widget build(BuildContext context) {
    print(list.length);
    return MyScaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: !isNextPage && isLoading
          ? TLoader()
          : CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverGrid.builder(
                  itemCount: list.length,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 160,
                    mainAxisExtent: 180,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                  ),
                  itemBuilder: (context, index) => MovieGridItem(
                    movie: list[index],
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
                //loader
                SliverToBoxAdapter(
                  child: isNextPage && isLoading
                      ? Container(
                          margin: EdgeInsetsDirectional.symmetric(vertical: 8),
                          child: TLoader(size: 30),
                        )
                      : SizedBox.shrink(),
                ),
              ],
            ),
    );
  }
}
