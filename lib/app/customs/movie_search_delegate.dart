import 'package:cm_app/app/components/movie_cache_image_widget.dart';
import 'package:cm_app/app/models/movie_model.dart';
import 'package:cm_app/app/notifiers/app_notifier.dart';
import 'package:cm_app/app/services/index.dart';
import 'package:cm_app/app/widgets/index.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as html;

class MovieSearchDelegate extends SearchDelegate {
  void Function(MovieModel movie) onClicked;
  MovieSearchDelegate({required this.onClicked});
  List<MovieModel> list = [];
  @override
  List<Widget>? buildActions(BuildContext context) {
    return null;
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return _getResult();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(child: Text('တစ်ခုခုရေးပါ...'));
  }

  Widget _getResult() {
    if (query.isEmpty) {
      return Center(child: Text('တစ်ခုခုရေးပါ...'));
    }

    final hostUrl = appConfigNotifier.value.hostUrl;
    final url = CMServices.instance.getForwardProxyUrl('$hostUrl/?s=$query');
    return FutureBuilder(
      future: CMServices.instance.getCacheHtml(
        url: url,
        cacheName: query,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return TLoader();
        }
        if (snapshot.hasError) {
          return Center(child: Text('error ရှိနေပါတယ်...'));
        }
        if (snapshot.hasData) {
          list.clear();
          final dom = html.Document.html(snapshot.data!);
          final eles = dom.querySelectorAll('.item_1 .item');
          for (var ele in eles) {
            list.add(MovieModel.fromElement(ele));
          }
        }

        if (list.isEmpty) {
          return Center(child: Text('Movie မရှိပါ....'));
        }
        //movie ရှိနေရင်
        return Center(
          child: ListView.separated(
              separatorBuilder: (context, index) => Divider(),
              itemCount: list.length,
              itemBuilder: (context, index) {
                final movie = list[index];
                return GestureDetector(
                  onTap: () => onClicked(movie),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Row(
                      spacing: 5,
                      children: [
                        SizedBox(
                          width: 110,
                          height: 130,
                          child: MovieCacheImageWidget(movie: movie),
                        ),
                        Expanded(
                          child: Column(
                            spacing: 5,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(movie.title),
                              Row(
                                spacing: 2,
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 20,
                                  ),
                                  Text(movie.imdb),
                                ],
                              ),
                              ExpandableText(
                                movie.desc,
                                expandText: 'Read More',
                                collapseOnTextTap: true,
                                collapseText: 'Read Less',
                                maxLines: 3,
                                linkColor: Colors.blue,
                                style: TextStyle(
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
        );
      },
    );
  }
}
