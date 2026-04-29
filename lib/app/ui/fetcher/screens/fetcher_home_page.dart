import 'package:cm_app/app/core/extensions/build_context_extensions.dart';
import 'package:cm_app/app/ui/fetcher/screens/website_content_page.dart';
import 'package:cm_app/app/ui/fetcher/services/fetcher_services.dart';
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
  List<WebsitePageResult> movieList = [];
  List<WebsitePageResult> tvShowList = [];

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
            _header(widget.website.moviePage),
            _gridList(movieList),
            // tv show
            _header(widget.website.tvShowPage),
            _gridList(tvShowList),
          ],
        ),
      ),
    );
  }

  List<Widget> get _actions => [
    if (TPlatform.isDesktop)
      IconButton(onPressed: init, icon: Icon(Icons.refresh)),
  ];
  Widget _header(WebsitePage page) {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  page.title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(onPressed: () {}, child: Text('See All')),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _gridList(List<WebsitePageResult> list) => SliverGrid.builder(
    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
      maxCrossAxisExtent: 200,
      mainAxisExtent: 220,
      mainAxisSpacing: 2,
      crossAxisSpacing: 2,
    ),
    itemCount: movieList.length,
    itemBuilder: (context, index) => _gridItem(list[index]),
  );

  Widget _gridItem(WebsitePageResult result) {
    return InkWell(
      mouseCursor: SystemMouseCursors.click,
      onTap: () => _goPage(result),
      child: Stack(
        children: [
          Positioned.fill(child: TCacheImage(url: result.coverUrl)),
          Container(color: Colors.black.withValues(alpha: 0.2)),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: Colors.black.withValues(alpha: 0.4),
              child: Text(
                result.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _goPage(WebsitePageResult result) {
    context.goRoute(
      builder: (context) =>
          WebsiteContentPage(result: result, website: widget.website),
    );
  }
}
