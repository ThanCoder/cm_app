import 'dart:io';

import 'package:cm_app/app/components/bookmark_button.dart';
import 'package:cm_app/app/components/imdb_icon.dart';
import 'package:cm_app/app/components/related_movie_list_view.dart';
import 'package:cm_app/app/models/movie_model.dart';
import 'package:cm_app/app/screens/content/movie_content_screen.dart';
import 'package:cm_app/app/services/dio_services.dart';
import 'package:cm_app/app/services/html_dom_services.dart';
import 'package:cm_app/my_libs/setting/app_services.dart';
import 'package:cm_app/my_libs/setting/path_util.dart';
import 'package:cm_app/my_libs/setting/t_messenger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as html;
import 'package:t_widgets/widgets/t_cache_image.dart';
import 'package:than_pkg/than_pkg.dart';

class HomeTagPage extends StatefulWidget {
  MovieModel movie;
  String htmlContent;
  List<String> contentCoverList = [];
  List<String> descCoverList = [];
  void Function() onRefresh;
  HomeTagPage({
    super.key,
    required this.movie,
    required this.htmlContent,
    required this.onRefresh,
    required this.contentCoverList,
    required this.descCoverList,
  });

  @override
  State<HomeTagPage> createState() => _HomeTagPageState();
}

class _HomeTagPageState extends State<HomeTagPage> {
  void _saveImage() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: Text('Save Image'),
              onTap: () async {
                Navigator.pop(ctx);
                try {
                  final file = File(widget.movie.coverPath);
                  if (!await file.exists()) return;
                  final savedPath =
                      '${PathUtil.getOutPath()}/${widget.movie.title.trim()}.png';
                  await file.copy(savedPath);
                  if (!ctx.mounted) return;
                  TMessenger.instance.showMessage(ctx, 'Saved: $savedPath');
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

  String? _getContentText() {
    try {
      final dom = html.Document.html(widget.htmlContent);
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
                AppServices.copyText(text);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _getContent() {
    final dom = html.Document.html(widget.htmlContent);

    if (dom.querySelector('.generalmenu') != null) {
      dom.querySelector('.generalmenu')!.remove();
    }
    dom.querySelectorAll('img').forEach((img) {
      // img.attributes['width'] = '100%';
      // img.attributes.remove('height');
      img.remove();
    });
    var htmlString = HtmlDomServices.cleanScriptTag(dom.outerHtml);
    htmlString = HtmlDomServices.cleanStyleTag(htmlString);
    // File('res.html').writeAsStringSync(htmlString);

    // print(htmlString);

    return GestureDetector(
      onSecondaryTap: _copyContentText,
      onLongPress: _copyContentText,
      child: Html(
        style: {'div': Style(fontSize: FontSize(15))},
        data: htmlString,
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
          child: TCacheImage(
            fit: BoxFit.fill,
            url: DioServices.instance.getForwardProxyUrl(url),
          ),
        ),
      ),
    );
  }

  void _showMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: 150),
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.source),
                title: Text('Copy Source Url'),
                onTap: () {
                  Navigator.pop(context);
                  AppServices.copyText(widget.movie.url);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          snap: true,
          title: Text(widget.movie.title),
          actions: [
            Platform.isLinux
                ? IconButton(
                    onPressed: () {
                      // isOverrideContentCache = true;
                      // init();
                      widget.onRefresh();
                    },
                    icon: Icon(Icons.refresh),
                  )
                : SizedBox.shrink(),
            IconButton(
              onPressed: _showMenu,
              icon: Icon(Icons.more_vert),
            ),
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
                        onTap: () => _showImageDialog(widget.movie.coverUrl),
                        onLongPress: _saveImage,
                        onSecondaryTap: _saveImage,
                        child: TCacheImage(
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
                              AppServices.copyText(widget.movie.title);
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
                widget.contentCoverList.length,
                (index) => GestureDetector(
                  onTap: () => _showImageDialog(widget.contentCoverList[index]),
                  child: Container(
                    margin: EdgeInsets.only(right: 8),
                    child: SizedBox(
                      width: 130,
                      height: 140,
                      child: TCacheImage(
                        url: widget.contentCoverList[index],
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
          itemCount: widget.descCoverList.length,
          itemBuilder: (context, index) => TCacheImage(
            url: widget.descCoverList[index],
            fit: BoxFit.fitWidth,
          ),
        ),
        //desc
        SliverToBoxAdapter(
          child: _getContent(),
        ),
        //download list

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
    );
  }
}
