import 'package:cm_app/app/components/core/app_components.dart';
import 'package:cm_app/app/models/download_link_model.dart';
import 'package:cm_app/app/models/movie_model.dart';
import 'package:cm_app/app/screens/content/download_tab_page.dart';
import 'package:cm_app/app/screens/content/home_tag_page.dart';
import 'package:cm_app/app/screens/content/tab_class.dart';
import 'package:cm_app/app/screens/content/trailer_tab_page.dart';
import 'package:cm_app/app/services/dio_services.dart';
import 'package:cm_app/app/services/html_query_selector_services.dart';
import 'package:cm_app/my_libs/setting/app_notifier.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as html;
import 'package:t_widgets/t_widgets.dart';

class MovieContentScreen extends StatefulWidget {
  MovieModel movie;
  MovieContentScreen({
    super.key,
    required this.movie,
  });

  @override
  State<MovieContentScreen> createState() => _MovieContentScreenState();
}

class _MovieContentScreenState extends State<MovieContentScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
  }

  bool isLoading = true;
  bool isOverrideContentCache = false;
  String htmlContent = '';
  List<DownloadLinkModel> downloadList = [];
  List<String> contentCoverList = [];
  List<String> descCoverList = [];
  List<String> trailerList = [];
  List<TabClass> tabs = [];

  Future<void> init() async {
    try {
      contentCoverList = [];
      downloadList = [];
      descCoverList = [];
      tabs = [];

      setState(() {
        isLoading = true;
      });

      final res = await DioServices.instance.getCacheHtml(
        url: DioServices.instance.getForwardProxyUrl(widget.movie.url),
        cacheName: widget.movie.title.replaceAll('/', '--'),
        isOverride: isOverrideContentCache,
      );
      final dom = html.Document.html(res);

      final movieContent = dom.querySelector('.entry-content #cap1');
      final seriesContent = dom.querySelector('.contenidotv');
      final movieResult = movieContent == null ? '' : movieContent.outerHtml;
      final seriesResult = seriesContent == null ? '' : seriesContent.outerHtml;
      //set content cover
      contentCoverList = MovieModel.getContentCoverList(res);

      final downLinks =
          dom.querySelectorAll('.enlaces_box .enlaces .elemento a');

      for (var ele in downLinks) {
        downloadList.add(DownloadLinkModel.fromElement(ele));
      }
      //set html content
      htmlContent = movieResult.isEmpty ? seriesResult : movieResult;
      //desc cover list
      html.Document.html(htmlContent).querySelectorAll('img').forEach((img) {
        // final src = img.attributes['src'];
        // img.attributes['src'] = '$appForwardProxyHostUrl?url=$src';
        final src = img.attributes['src'] ?? '';
        if (src.isNotEmpty && !src.endsWith('.gif')) {
          descCoverList
              .add('${appConfigNotifier.value.forwardProxyUrl}?url=$src');
        }
        img.attributes['src'] = '';
        img.remove();
      });

      //trailer list
      var trailerEles = dom.querySelectorAll(".youtube_id");
      if (dom.querySelectorAll(".youtube_id_tv").isNotEmpty) {
        trailerEles = dom.querySelectorAll(".youtube_id_tv");
      }
      for (var trailerEle in trailerEles) {
        final url = getQuerySelectorAttr(trailerEle, 'iframe', 'src')
            .replaceAll('//www', 'https://www');
        trailerList.add(url);
      }
      // change ui
      // home tab
      tabs.add(
        TabClass(
          tabBar: Tab(
            text: 'Home',
          ),
          tabViewWidget: HomeTagPage(
            movie: widget.movie,
            htmlContent: htmlContent,
            onRefresh: init,
            contentCoverList: contentCoverList,
            descCoverList: descCoverList,
          ),
        ),
      );

      if (trailerList.isNotEmpty) {
        tabs.add(TabClass(
            tabBar: Tab(
              text: 'Trailer',
            ),
            tabViewWidget: TrailerTabPage(trailerList: trailerList)));
      }
      if (downloadList.isNotEmpty) {
        tabs.add(
          TabClass(
            tabBar: Tab(
              text: 'Download Link',
            ),
            tabViewWidget: DownloadTabPage(downloadList: downloadList),
          ),
        );
      }
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      showDialogMessage(context, e.toString());
    }
    isOverrideContentCache = false;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Content'),
        ),
        body: TLoader(),
      );
    }
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            isOverrideContentCache = true;
            await init();
          },
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 800),
              child: TabBarView(
                children: tabs.map((e) => e.tabViewWidget).toList(),
              ),
            ),
          ),
        ),
        bottomNavigationBar: TabBar(
          tabs: tabs.map((e) => e.tabBar).toList(),
        ),
      ),
    );
  }
}
