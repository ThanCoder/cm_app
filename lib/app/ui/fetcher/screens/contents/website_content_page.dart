import 'package:cm_app/app/ui/fetcher/screens/contents/movie_content_page.dart';
import 'package:cm_app/app/ui/fetcher/screens/contents/tv_show_content_page.dart';
import 'package:cm_app/app/ui/fetcher/services/fetcher_services.dart';
import 'package:cm_app/app/ui/fetcher/types/website.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_pkg/than_pkg.dart';

enum WebsiteContentPageType { movie, tvShow }

class WebsiteContentPage extends StatefulWidget {
  final WebsitePageResult result;
  final Website website;
  final WebsiteContentPageType type;
  const WebsiteContentPage({
    super.key,
    required this.result,
    required this.website,
    required this.type,
  });

  @override
  State<WebsiteContentPage> createState() => _WebsiteContentPageState();
}

class _WebsiteContentPageState extends State<WebsiteContentPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
  }

  bool isLoading = false;
  String html = '';

  Future<void> init({bool useCache = true, bool cacheCleanUp = false}) async {
    try {
      if (isLoading) return;
      setState(() {
        isLoading = true;
      });
      final cacheName =
          'cache-content-page-${widget.result.url.contains('tvshows') ? 'tvshows' : 'movie'}-';
      // print(cacheName);
      html = await FetcherServices.instace.fetchPageHtml(
        widget.result.url,
        firstKeyName: cacheName,
        useCache: useCache,
        cacheCleanUp: cacheCleanUp,
      );

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
      appBar: AppBar(title: Text(widget.result.title), actions: _actions),
      body: _body,
    );
  }

  List<Widget> get _actions => [
    if (TPlatform.isDesktop)
      IconButton(onPressed: init, icon: Icon(Icons.refresh)),

    IconButton(
      onPressed: () {
        try {
          ThanPkg.platform.launch(widget.result.url);
        } catch (e) {
          showTMessageDialogError(context, e.toString());
        }
      },
      icon: Icon(Icons.open_in_browser),
    ),
  ];
  Widget get _body {
    if (isLoading) {
      return Center(child: TLoaderRandom());
    }
    if (html.isEmpty) {
      return Center(
        child: RefreshButton(
          text: Text('HTML is Empty!'),
          onClicked: () => init(useCache: false),
        ),
      );
    }
    return _resultWidget;
  }

  Widget get _resultWidget {
    if (widget.type == WebsiteContentPageType.tvShow) {
      return TvShowContentPage(
        html: html,
        result: widget.result,
        website: widget.website,
      );
    }

    return MovieContentPage(
      html: html,
      result: widget.result,
      website: widget.website,
    );
  }
}
