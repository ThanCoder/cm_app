import 'package:cm_app/app/components/movie_grid_item.dart';
import 'package:cm_app/app/models/movie_model.dart';
import 'package:cm_app/app/screens/content_screens/movie_content_screen.dart';
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
  bool isNextPage = false;
  List<MovieModel> list = [];
  String? nextUrl;

  void init(String url) async {
    setState(() {
      isLoading = true;
    });

    CMServices.instance.getMovieList(
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
  }

  void _onScroll() {
    if (lastScroll != scrollController.position.maxScrollExtent &&
        scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
      lastScroll = scrollController.position.maxScrollExtent;
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
                    maxCrossAxisExtent: 180,
                    mainAxisExtent: 200,
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
