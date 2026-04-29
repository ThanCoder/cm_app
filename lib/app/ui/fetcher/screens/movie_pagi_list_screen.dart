import 'package:cm_app/app/core/extensions/build_context_extensions.dart';
import 'package:cm_app/app/ui/components/cache_image.dart';
import 'package:cm_app/app/ui/fetcher/screens/contents/website_content_page.dart';
import 'package:cm_app/app/ui/fetcher/services/fetcher_services.dart';
import 'package:cm_app/app/ui/fetcher/types/movie_pagi_response.dart';
import 'package:cm_app/app/ui/fetcher/types/website.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_pkg/extensions/t_platform.dart';

class MoviePagiListScreen extends StatefulWidget {
  final String url;
  final String? title;
  final Website website;
  final WebsiteContentPageType type;
  const MoviePagiListScreen({
    super.key,
    this.title,
    required this.url,
    required this.website,
    required this.type,
  });

  @override
  State<MoviePagiListScreen> createState() => _MoviePagiListScreenState();
}

class _MoviePagiListScreenState extends State<MoviePagiListScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
    super.initState();
  }

  MoviePagiResponse? response;
  bool isLoading = false;
  String error = '';
  String? currentUrl;

  Future<void> init({bool useCache = true}) async {
    try {
      if (isLoading) return;
      setState(() {
        error = '';
        isLoading = true;
      });
      response = await FetcherServices.instace.fetchPagiPageList(
        currentUrl ?? widget.url,
        useCache: useCache,
        type: widget.type,
        website: widget.website,
      );

      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      error = e.toString();
      debugPrint('[MoviePagiListScreen:init]: $e');
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? widget.website.title),
        actions: [
          if (TPlatform.isDesktop)
            IconButton(
              onPressed: () => init(useCache: false),
              icon: Icon(Icons.refresh),
            ),
        ],
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: () async => init(useCache: false),
        child: CustomScrollView(
          slivers: [
            if (isLoading)
              SliverFillRemaining(child: TLoaderRandom())
            else if (error.isNotEmpty || response == null)
              SliverFillRemaining(child: Text(error))
            else
              ..._resultWidget,
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => init(useCache: false),
      // ),
    );
  }

  List<Widget> get _resultWidget {
    return [
      if (response!.movies.isEmpty)
        SliverFillRemaining(
          child: RefreshButton(
            text: Text('List Empty'),
            onClicked: () => init(useCache: false),
          ),
        ),
      SliverGrid.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 140,
          mainAxisExtent: 170,
          mainAxisSpacing: 2,
          crossAxisSpacing: 2,
        ),
        itemCount: response!.movies.length,
        itemBuilder: (context, index) => _gridItem(response!.movies[index]),
      ),
      // pagi
      _pagiWidget,
    ];
  }

  Widget _gridItem(MovieItem item) {
    return InkWell(
      mouseCursor: SystemMouseCursors.click,
      onTap: () => _goPage(item),
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

  Widget get _pagiWidget {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Wrap(
              spacing: 4,
              runSpacing: 4,
              children: response!.pagiList.map((e) => _pagiItem(e)).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _pagiItem(Pagination pagi) {
    return TextButton(
      style: TextButton.styleFrom(backgroundColor: Colors.blue),
      onPressed: () {
        currentUrl = pagi.url;
        init(useCache: false);
      },
      child: Text(pagi.title),
    );
  }

  void _goPage(MovieItem item) {
    context.goRoute(
      builder: (context) => WebsiteContentPage(
        item: item,
        website: widget.website,
        type: widget.type,
      ),
    );
  }
}
