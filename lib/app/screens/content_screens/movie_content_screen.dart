import 'dart:io';
import 'package:cm_app/app/components/bookmark_button.dart';
import 'package:cm_app/app/components/imdb_icon.dart';
import 'package:cm_app/app/components/related_movie_list_view.dart';
import 'package:cm_app/app/constants.dart';
import 'package:cm_app/app/models/download_link_model.dart';
import 'package:cm_app/app/models/movie_model.dart';
import 'package:cm_app/app/services/c_m_services.dart';
import 'package:cm_app/app/services/core/app_services.dart';
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
    final dom = html.Document.html(htmlContent);
    dom.querySelectorAll('img').forEach((img) {
      final src = img.attributes['src'];
      img.attributes['src'] = '$appForwardProxyHostUrl?url=$src';
    });
    if (dom.querySelector('.generalmenu') != null) {
      dom.querySelector('.generalmenu')!.remove();
    }
    // File('content.html').writeAsStringSync(dom.outerHtml);
    return Html(
      data: dom.outerHtml,
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

  void _showImageDialog(String url) {
    final width = MediaQuery.of(context).size.width;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.all(0),
        content: SizedBox(
          width: width,
          child: CacheImageWidget(
            url: url,
          ),
        ),
      ),
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
            //header
            SliverToBoxAdapter(
              child: Column(
                spacing: 10,
                children: [
                  Card(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 5,
                      children: [
                        SizedBox(
                          width: 160,
                          height: 180,
                          child: GestureDetector(
                            onTap: () =>
                                _showImageDialog(widget.movie.coverUrl),
                            child: MyImageFile(
                              path: widget.movie.coverPath,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 5,
                            children: [
                              GestureDetector(
                                onLongPress: () {
                                  copyText(widget.movie.title);
                                },
                                child: Text(
                                  widget.movie.title,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                              ConstrainedBox(
                                  constraints: BoxConstraints(maxWidth: 55),
                                  child: ImdbIcon(title: widget.movie.imdb)),
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
                    (index) => GestureDetector(
                      onTap: () => _showImageDialog(contentCoverList[index]),
                      child: Container(
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
                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: ListTile(
                    onTap: () {
                      if (Platform.isLinux) {
                        launchUrlString(link.url);
                      }
                      if (Platform.isAndroid) {
                        ThanPkg.android.app.openUrl(url: link.url);
                      }
                    },
                    leading: SizedBox(
                      width: 30,
                      height: 30,
                      child: MyImageUrl(
                        url: '$appForwardProxyHostUrl?url=${link.iconUrl}',
                        width: double.infinity,
                      ),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Server: ${link.title.trim()}'),
                        Text('Size: ${link.size}'),
                        Text('Quality: ${link.quality}'),
                        // Text(link.url),
                      ],
                    ),
                  ),
                );
              },
            ),
            //related movie
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(8.0),
                child: RelatedMovieListView(
                  url: widget.movie.url,
                  onClicked: (movie) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieContentScreen(movie: movie),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
