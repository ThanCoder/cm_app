import 'dart:io';

import 'package:cm_app/app/screens/content/bookmark_button.dart';
import 'package:cm_app/app/models/movie.dart';
import 'package:cm_app/app/screens/content/content_cover_page.dart';
import 'package:cm_app/app/screens/content/html_fetcher_dialog.dart';
import 'package:cm_app/app/services/dio_services.dart';
import 'package:cm_app/my_libs/setting_v2.2.0/core/path_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:t_html_parser/t_html_parser.dart' hide Text;
import 'package:t_widgets/t_widgets.dart';
import 'package:than_pkg/than_pkg.dart';

class SeriesContentPage extends StatefulWidget {
  String htmlContent;
  Movie movie;
  SeriesContentPage({
    super.key,
    required this.htmlContent,
    required this.movie,
  });

  @override
  State<SeriesContentPage> createState() => _SeriesContentPageState();
}

class _SeriesContentPageState extends State<SeriesContentPage> {
  @override
  void initState() {
    htmlContent = widget.htmlContent;
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
  }

  late String htmlContent;
  String contentHtml = '';
  List<String> ovalList = [];
  List<String> contentImagesUrls = [];

  Future<void> init() async {
    final ele = htmlContent.toHtmlElement!;
    // content text
    contentHtml = ele.getQuerySelectorHtml(selector: '.contenidotv');
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
    contentHtml = contentDOM.outerHtml;
    // cover
    // final coverUrl = ele.getQuerySelectorAttr(selector: '.cover', attr: 'src');
    // final coverUrl = ele.getQuerySelectorAttr(selector: '.cover', attr: 'src');
    // print(coverUrl);
    // oval cover
    // final ovalEles = ele.querySelectorAll('.owl-item');
    // print(ovalEles);
    // for (var ovalItem in ovalEles) {
    //   final url = ovalItem.getQuerySelectorAttr(selector: 'img', attr: 'src');
    //   print(url);
    // }

    setState(() {});
  }

  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return TScaffold(
      appBar: AppBar(
        title: Text('Series'),
        actions: [
          !TPlatform.isDesktop
              ? SizedBox.shrink()
              : IconButton(onPressed: _resetHtml, icon: Icon(Icons.refresh)),
          BookmarkButton(movie: widget.movie),
          IconButton(onPressed: _showMenu, icon: Icon(Icons.more_vert_rounded)),
        ],
      ),
      body: DefaultTabController(
        initialIndex: pageIndex,
        length: 2,
        child: Scaffold(
          body: _getPageWidget(),
          bottomNavigationBar: TabBar(
            onTap: (value) {
              setState(() {
                pageIndex = value;
              });
            },
            tabs: [
              Tab(icon: Icon(Icons.home)),
              Tab(icon: Icon(Icons.image)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getPageWidget() {
    if (pageIndex == 1) {
      return ContentCoverPage(coverUrls: contentImagesUrls);
    }
    return _getHomeWidget();
  }

  Widget _getHomeWidget() {
    return RefreshIndicator.adaptive(
      onRefresh: _resetHtml,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _getHeader()),
          SliverToBoxAdapter(child: _getContentHtmlWidget()),
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
      onLinkTap: (url, attributes, element) => _showContentLinkMenu(url ?? ''),
    );
  }

  Future<void> _resetHtml() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => HtmlFetcherDialog(
        movie: widget.movie,
        isUseCacheHtml: false,
        onSeriesFetched: (htmlContent) {
          this.htmlContent = htmlContent;
          init();
        },
      ),
    );
  }

  void _showContentLinkMenu(String url) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: 150),
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.open_in_browser),
                title: Text('Open Brower'),
                onTap: () async {
                  Navigator.pop(context);
                  if (url.isEmpty) return;
                  if (Platform.isLinux) {
                    await ThanPkg.linux.app.launch(url);
                  }
                  if (Platform.isAndroid) {
                    await ThanPkg.platform.openUrl(url: url);
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.copy_all),
                title: Text('Copy Url'),
                onTap: () {
                  Navigator.pop(context);
                  ThanPkg.appUtil.copyText(url);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

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
