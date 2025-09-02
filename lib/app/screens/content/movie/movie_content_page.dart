import 'package:cm_app/app/components/related_movie_list_view.dart';
import 'package:cm_app/app/models/download_link.dart';
import 'package:cm_app/app/models/movie.dart';
import 'package:cm_app/app/routes_helper.dart';
import 'package:cm_app/app/screens/content/bookmark_button.dart';
import 'package:cm_app/app/screens/content/content_cover_page.dart';
import 'package:cm_app/app/screens/content/html_fetcher_dialog.dart';
import 'package:cm_app/app/screens/content/movie/download_tab_page.dart';
import 'package:cm_app/app/screens/content/movie/trailer_tab_page.dart';
import 'package:cm_app/app/services/dio_services.dart';
import 'package:cm_app/my_libs/setting_v2.2.0/core/path_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:t_html_parser/t_extractor.dart';
import 'package:t_html_parser/t_html_extensions.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_pkg/than_pkg.dart';

class MovieContentPage extends StatefulWidget {
  String htmlContent;
  Movie movie;
  MovieContentPage({super.key, required this.htmlContent, required this.movie});

  @override
  State<MovieContentPage> createState() => _MovieContentPageState();
}

class _MovieContentPageState extends State<MovieContentPage> {
  @override
  void initState() {
    htmlContent = widget.htmlContent;
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
  }

  late String htmlContent;
  String contentHtml = '';
  List<String> contentImagesUrls = [];
  List<String> trailerList = [];
  List<DownloadLink> downloadList = [];
  int pageIndex = 0;

  Future<void> init() async {
    contentImagesUrls.clear();

    final ele = htmlContent.toHtmlElement!;
    ele.cleanEleTag();

    contentHtml = ele.getQuerySelectorHtml(selector: '.entry-content #cap1');
    final contentDOM = contentHtml.toHtmlDocument;
    contentDOM.cleanDomTag();
    contentDOM.querySelectorAll('img').forEach((img) {
      final src = img.attributes['src'] ?? '';
      if (src.isNotEmpty) {
        final url = DioServices.instance.getForwardProxyUrl(src);
        contentImagesUrls.add(url);
      }
      img.attributes['src'] = '';
      img.remove();
    });
    contentDOM.querySelector('.generalmenu')?.remove();
    contentDOM.querySelector('.enlaces_box')?.remove();
    contentHtml = contentDOM.outerHtml;

    // print(meta);
    setState(() {});
    _fetchTrailer();
    _fetchDownloadLink();
  }

  @override
  Widget build(BuildContext context) {
    return TScaffold(
      appBar: AppBar(
        title: Text('Movie'),
        actions: [
          !TPlatform.isDesktop
              ? SizedBox.shrink()
              : IconButton(onPressed: _resetHtml, icon: Icon(Icons.refresh)),
          BookmarkButton(movie: widget.movie),
          IconButton(onPressed: _showMenu, icon: Icon(Icons.more_vert_rounded)),
        ],
      ),
      body: DefaultTabController(
        animationDuration: Duration(milliseconds: 5),
        initialIndex: pageIndex,
        length: _getPages().length,
        child: Scaffold(
          body: _getPages()[pageIndex].$1,
          bottomNavigationBar: TabBar(
            isScrollable: true,
            onTap: (value) {
              setState(() {
                pageIndex = value;
              });
            },
            tabs: _getPages().map((e) => e.$2).toList(),
            // [
            //   Tab(text: 'home'),
            //   Tab(text: 'Cover Images'),
            //   Tab(text: 'Download Link'),
            //   Tab(text: 'Trailer'),
            // ]
          ),
        ),
      ),
    );
  }

  List<(Widget, Tab)> _getPages() {
    final list = [
      (_getHomeWidget(), Tab(text: 'Home')),
      (DownloadTabPage(downloadList: downloadList), Tab(text: 'Download Link')),
    ];
    if (trailerList.isNotEmpty) {
      list.add((
        TrailerTabPage(trailerList: trailerList),
        Tab(text: 'Trailer'),
      ));
    }
    if (contentImagesUrls.isNotEmpty) {
      list.add((
        ContentCoverPage(coverUrls: contentImagesUrls),
        Tab(text: 'Cover Images'),
      ));
    }

    return list;
  }

  Widget _getHomeWidget() {
    return RefreshIndicator.adaptive(
      onRefresh: _resetHtml,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _getHeader()),
          SliverToBoxAdapter(child: _getContentHtmlWidget()),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: RelatedMovieListView(
                url: widget.movie.url,
                onClicked: (movie) {
                  goMovieContent(context, movie: movie);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getHeader() {
    return Center(
      child: Wrap(
        spacing: 5,
        runSpacing: 5,
        children: [
          TCacheImage(
            width: 140,
            height: 160,
            url: widget.movie.coverUrl,
            cachePath: PathUtil.getCachePath(),
          ),
          Column(
            spacing: 5,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onLongPress: () {
                  ThanPkg.appUtil.copyText(widget.movie.title);
                },
                child: Text(
                  widget.movie.title,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                'IMDB: ${widget.movie.imdb}',
                style: TextStyle(color: Colors.amber),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _getContentHtmlWidget() {
    return Html(
      style: {'div': Style(fontSize: FontSize(15))},
      data: contentHtml,
      shrinkWrap: true,
      // onLinkTap: (url, attributes, element) => _showContentLinkMenu(url ?? ''),
    );
  }

  Future<void> _resetHtml() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => HtmlFetcherDialog(
        movie: widget.movie,
        isUseCacheHtml: false,
        onMovieFetched: (htmlContent) {
          this.htmlContent = htmlContent;
          init();
        },
      ),
    );
  }

  void _fetchTrailer() {
    trailerList.clear();
    final dom = htmlContent.toHtmlDocument;
    var trailerEles = dom.querySelectorAll(".youtube_id");
    if (dom.querySelectorAll(".youtube_id_tv").isNotEmpty) {
      trailerEles = dom.querySelectorAll(".youtube_id_tv");
    }

    for (var trailerEle in trailerEles) {
      final url = trailerEle
          .getQuerySelectorAttr(selector: 'iframe', attr: 'src')
          .replaceAll('//www', 'https://www');
      trailerList.add(url);
    }
    setState(() {});
  }

  void _fetchDownloadLink() {
    downloadList.clear();
    final dom = htmlContent.toHtmlDocument;
    final downLinks = dom.querySelectorAll('.enlaces_box .enlaces .elemento a');

    for (var ele in downLinks) {
      final link = DownloadLink.fromElement(ele.outerHtml);
      downloadList.add(link);
    }
    setState(() {});
  }

  // void _showContentLinkMenu(String url) {
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (context) => SingleChildScrollView(
  //       child: ConstrainedBox(
  //         constraints: BoxConstraints(minHeight: 150),
  //         child: Column(
  //           children: [
  //             ListTile(
  //               leading: Icon(Icons.open_in_browser),
  //               title: Text('Open Brower'),
  //               onTap: () async {
  //                 Navigator.pop(context);
  //                 if (url.isEmpty) return;
  //                 await ThanPkg.platform.launch(url);
  //               },
  //             ),
  //             ListTile(
  //               leading: Icon(Icons.copy_all),
  //               title: Text('Copy Url'),
  //               onTap: () {
  //                 Navigator.pop(context);
  //                 ThanPkg.appUtil.copyText(url);
  //               },
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  void _showMenu() {
    showTMenuBottomSheet(
      context,
      title: Text(widget.movie.title),
      children: [
        ListTile(
          leading: Icon(Icons.copy),
          title: Text('Copy Url'),
          onTap: () {
            Navigator.pop(context);
            ThanPkg.appUtil.copyText(widget.movie.url);
          },
        ),
        ListTile(
          leading: Icon(Icons.copy),
          title: Text('Copy Movie Title'),
          onTap: () {
            Navigator.pop(context);
            ThanPkg.appUtil.copyText(widget.movie.title);
          },
        ),
        ListTile(
          leading: Icon(Icons.copy),
          title: Text('Copy Cover Url'),
          onTap: () {
            Navigator.pop(context);
            ThanPkg.appUtil.copyText(widget.movie.coverUrl);
          },
        ),
        ListTile(
          leading: Icon(Icons.copy),
          title: Text('Copy Content Text'),
          onTap: () {
            Navigator.pop(context);
            final text = TExtractor.cleanHtmlTag(contentHtml);
            ThanPkg.appUtil.copyText(text);
          },
        ),
      ],
    );
  }
}
