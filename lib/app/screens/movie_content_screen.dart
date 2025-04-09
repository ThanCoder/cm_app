import 'dart:io';
import 'package:cm_app/app/components/bookmark_button.dart';
import 'package:cm_app/app/components/imdb_icon.dart';
import 'package:cm_app/app/components/index.dart';
import 'package:cm_app/app/components/related_movie_list_view.dart';
import 'package:cm_app/app/constants.dart';
import 'package:cm_app/app/models/download_link_model.dart';
import 'package:cm_app/app/models/movie_model.dart';
import 'package:cm_app/app/services/core/app_services.dart';
import 'package:cm_app/app/services/core/dio_services.dart';
import 'package:cm_app/app/services/html_query_selector_services.dart';
import 'package:cm_app/app/utils/index.dart';
import 'package:cm_app/app/widgets/cache_image_widget.dart';
import 'package:cm_app/app/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as html;
import 'package:than_pkg/than_pkg.dart';

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
  List<String> descCoverList = [];
  List<String> trailerList = [];

  Future<void> init() async {
    try {
      setState(() {
        isLoading = true;
        contentCoverList = [];
        downloadList = [];
        descCoverList = [];
      });
      final res = await DioServices.instance.getCacheHtml(
        url: DioServices.instance.getForwardProxyUrl(widget.movie.url),
        cacheName: widget.movie.title.replaceAll('/', '--'),
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
      //set html content
      htmlContent = movieResult.isEmpty ? seriesResult : movieResult;
      //desc cover list
      html.Document.html(htmlContent).querySelectorAll('img').forEach((img) {
        // final src = img.attributes['src'];
        // img.attributes['src'] = '$appForwardProxyHostUrl?url=$src';
        final src = img.attributes['src'] ?? '';
        if (src.isNotEmpty) {
          descCoverList.add('$appForwardProxyHostUrl?url=$src');
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

      if (!mounted) return;
      setState(() {
        isLoading = false;
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

  String? _getContentText() {
    try {
      final dom = html.Document.html(htmlContent);
      final desc = dom.querySelector('#cap1');
      final desc2 = dom.querySelector('.contenidotv');
      if (desc != null) {
        return desc.text;
      }
      if (desc2 != null) {
        return desc2.text;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  void _copyContentText() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: Text('Copy Text'),
              onTap: () {
                Navigator.pop(context);
                final text = _getContentText();
                if (text == null) return;
                copyText(text);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _saveImage() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: Text('Save Image'),
              onTap: () async {
                Navigator.pop(context);
                try {
                  final file = File(widget.movie.coverPath);
                  if (!await file.exists()) return;
                  final savedPath =
                      '${PathUtil.instance.getOutPath()}/${widget.movie.title.trim()}.png';
                  await file.copy(savedPath);
                  if (!mounted) return;
                  showMessage(context, 'Saved: $savedPath');
                } catch (e) {
                  debugPrint(e.toString());
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _getContent() {
    final dom = html.Document.html(htmlContent);

    if (dom.querySelector('.generalmenu') != null) {
      dom.querySelector('.generalmenu')!.remove();
    }
    dom.querySelectorAll('img').forEach((img) {
      img.remove();
    });
    return GestureDetector(
      onSecondaryTap: _copyContentText,
      onLongPress: _copyContentText,
      child: Html(
        data: dom.outerHtml,
        shrinkWrap: true,
        onLinkTap: (url, attributes, element) async {
          if (url == null) return;
          if (Platform.isLinux) {
            await ThanPkg.linux.app.launch(url);
          }
          if (Platform.isAndroid) {
            await ThanPkg.platform.openUrl(url: url);
          }
        },
      ),
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
            fit: BoxFit.fill,
            url: DioServices.instance.getForwardProxyUrl(url),
          ),
        ),
      ),
    );
  }

  Widget _getTrailerWidget() {
    if (trailerList.isEmpty) return SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trailer Link များ',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Column(
            children: List.generate(
              trailerList.length,
              (index) {
                final url = trailerList[index];
                return ListTile(
                  onTap: () async {
                    if (Platform.isAndroid) {
                      await ThanPkg.android.app.openUrl(url: url);
                    } else {
                      await ThanPkg.linux.app.launch(url);
                    }
                  },
                  title: Text(
                    url,
                    style: TextStyle(color: Colors.blue),
                  ),
                );
              },
            ),
          ),
        ],
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
                            onLongPress: _saveImage,
                            onSecondaryTap: _saveImage,
                            child: CacheImageWidget(
                              url: DioServices.instance
                                  .getForwardProxyUrl(widget.movie.coverUrl),
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
            //desc cover list
            SliverList.builder(
              itemCount: descCoverList.length,
              itemBuilder: (context, index) => CacheImageWidget(
                url: descCoverList[index],
                fit: BoxFit.fitWidth,
              ),
            ),
            //desc
            SliverToBoxAdapter(
              child: isLoading ? TLoader() : _getContent(),
            ),
            //youtuble link
            SliverToBoxAdapter(
              child: _getTrailerWidget(),
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
                        ThanPkg.linux.app.launch(link.url);
                      }
                      if (Platform.isAndroid) {
                        ThanPkg.android.app.openUrl(url: link.url);
                      }
                    },
                    leading: SizedBox(
                      width: 30,
                      height: 30,
                      child: MyImageUrl(
                        url: DioServices.instance
                            .getForwardProxyUrl(link.iconUrl),
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
