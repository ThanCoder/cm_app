import 'dart:io';
import 'package:cm_app/app/components/bookmark_button.dart';
import 'package:cm_app/app/components/imdb_icon.dart';
import 'package:cm_app/app/models/download_link_model.dart';
import 'package:cm_app/app/models/movie_model.dart';
import 'package:cm_app/app/services/c_m_services.dart';
import 'package:cm_app/app/widgets/cache_image_widget.dart';
import 'package:cm_app/app/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as html;
import 'package:than_pkg/than_pkg.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MovieContentScreen extends StatefulWidget {
  MovieModel movie;
  MovieContentScreen({super.key, required this.movie});

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

  Future<void> init() async {
    try {
      setState(() {
        isLoading = true;
        contentCoverList = [];
        downloadList = [];
      });
      final res = await CMServices.instance.getCacheHtml(
        url: widget.movie.url,
        cacheName: widget.movie.title,
        isOverride: isOverrideContentCache,
      );
      final dom = html.Document.html(res);
      final movieContent = dom.querySelector('.entry-content');
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

      if (!mounted) return;
      setState(() {
        isLoading = false;
        htmlContent = movieResult.isEmpty ? seriesResult : movieResult;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      debugPrint(e.toString());
    }
    isOverrideContentCache = false;
  }

  Widget _getContent() {
    return Html(
      data: htmlContent,
      shrinkWrap: true,
      onLinkTap: (url, attributes, element) {
        if (url == null) return;
        if (Platform.isLinux) {
          launchUrlString(url);
        }
        if (Platform.isAndroid) {
          ThanPkg.platform.openUrl(url: url);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      contentPadding: 0,
      body: RefreshIndicator(
        onRefresh: () async {
          isOverrideContentCache = true;
          await init();
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              snap: true,
              title: Text(widget.movie.title),
              actions: [
                Platform.isLinux
                    ? IconButton(
                        onPressed: () {
                          isOverrideContentCache = true;
                          init();
                        },
                        icon: Icon(Icons.refresh),
                      )
                    : SizedBox.shrink(),
              ],
            ),
            SliverToBoxAdapter(
              child: Column(
                spacing: 10,
                children: [
                  //header
                  Card(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 5,
                      children: [
                        SizedBox(
                          width: 160,
                          height: 180,
                          child: MyImageFile(
                            path: widget.movie.coverPath,
                            fit: BoxFit.fill,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 5,
                            children: [
                              Text(
                                widget.movie.title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              ImdbIcon(title: widget.movie.imdb),
                              //book mark
                              BookmarkButton(movie: widget.movie),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 10)),
            //content cover list
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    contentCoverList.length,
                    (index) => Container(
                      margin: EdgeInsets.only(right: 8),
                      child: SizedBox(
                        width: 130,
                        height: 140,
                        child: CacheImageWidget(
                          url: contentCoverList[index],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            //content
            SliverToBoxAdapter(
              child: isLoading ? TLoader() : _getContent(),
            ),
            //download list
            SliverList.separated(
              separatorBuilder: (context, index) => const Divider(),
              itemCount: downloadList.length,
              itemBuilder: (context, index) {
                final link = downloadList[index];
                return GestureDetector(
                  onTap: () {
                    if (Platform.isLinux) {
                      launchUrlString(link.url);
                    }
                    if (Platform.isAndroid) {
                      ThanPkg.android.app.openUrl(url: link.url);
                    }
                  },
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Column(
                      spacing: 5,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 30,
                          height: 30,
                          child: MyImageUrl(url: link.iconUrl),
                        ),
                        Text(link.title),
                        Text(link.size),
                        Text(link.quality),
                        Text(link.url),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
