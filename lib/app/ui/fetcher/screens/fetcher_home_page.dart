import 'package:cm_app/app/core/extensions/build_context_extensions.dart';
import 'package:cm_app/app/ui/components/cache_image.dart';
import 'package:cm_app/app/ui/fetcher/screens/contents/website_content_page.dart';
import 'package:cm_app/app/ui/fetcher/screens/movie_pagi_list_screen.dart';
import 'package:cm_app/app/ui/fetcher/services/fetcher_services.dart';
import 'package:cm_app/app/ui/fetcher/types/movie_pagi_response.dart';
import 'package:cm_app/app/ui/fetcher/types/website.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_pkg/extensions/index.dart';

class FetcherHomePage extends StatefulWidget {
  final Website website;
  const FetcherHomePage({super.key, required this.website});

  @override
  State<FetcherHomePage> createState() => _FetcherHomePageState();
}

class _FetcherHomePageState extends State<FetcherHomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
  }

  bool isLoading = false;
  List<MovieItem> movieList = [];
  List<MovieItem> tvShowList = [];

  Future<void> init() async {
    try {
      if (isLoading) return;
      setState(() {
        isLoading = true;
      });
      final (movies, tvshows) = await FetcherServices.instace.fetchPage(
        widget.website.url,
        website: widget.website,
      );
      movieList = movies;
      tvShowList = tvshows;
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      showTMessageDialogError(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fetcher ${widget.website.title}'),
        actions: _actions,
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: init,
        child: CustomScrollView(
          slivers: [
            if (isLoading)
              SliverFillRemaining(child: Center(child: TLoaderRandom())),
            //  movies
            _header(
              widget.website.moviePage,
              onPressed: () => context.goRoute(
                builder: (context) => MoviePagiListScreen(
                  title: 'Movies',
                  url: widget.website.moviePage.moreUrl,
                  website: widget.website,
                  type: WebsiteContentPageType.movie,
                ),
              ),
            ),
            _gridList(movieList, WebsiteContentPageType.movie),
            // tv show
            _header(
              widget.website.tvShowPage,
              onPressed: () => context.goRoute(
                builder: (context) => MoviePagiListScreen(
                  title: 'TV Shows',
                  url: widget.website.tvShowPage.moreUrl,
                  website: widget.website,
                  type: WebsiteContentPageType.tvShow,
                ),
              ),
            ),
            _gridList(tvShowList, WebsiteContentPageType.tvShow),
          ],
        ),
      ),
    );
  }

  List<Widget> get _actions => [
    if (TPlatform.isDesktop)
      IconButton(onPressed: init, icon: Icon(Icons.refresh)),
  ];

  Widget _header(WebsitePage page, {void Function()? onPressed}) {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Row(
              spacing: 3,
              children: [
                SizedBox(width: 5),
                Text(
                  page.title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                TextButton(onPressed: onPressed, child: Text('See All')),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _gridList(List<MovieItem> list, WebsiteContentPageType type) =>
      SliverGrid.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 140,
          mainAxisExtent: 170,
          mainAxisSpacing: 2,
          crossAxisSpacing: 2,
        ),
        itemCount: list.length,
        itemBuilder: (context, index) => _gridItem(list[index], type),
      );

  Widget _gridItem(MovieItem item, WebsiteContentPageType type) {
    return InkWell(
      mouseCursor: SystemMouseCursors.click,
      onTap: () => _goPage(item, type),
      onSecondaryTap: () {
        showTMessageDialog(context, item.toString());
      },
      child: Stack(
        children: [
          Positioned.fill(child: CacheImage(url: item.coverUrl)),
          Container(color: Colors.black.withValues(alpha: 0.2)),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: Colors.black.withValues(alpha: 0.6),
              child: Text(
                item.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _goPage(MovieItem item, WebsiteContentPageType type) {
    context.goRoute(
      builder: (context) =>
          WebsiteContentPage(item: item, website: widget.website, type: type),
    );
  }
}
