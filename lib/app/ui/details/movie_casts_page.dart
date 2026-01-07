import 'package:cm_app/app/core/models/movie_cast.dart';
import 'package:cm_app/app/ui/components/cache_image.dart';
import 'package:cm_app/more_libs/setting/setting.dart';
import 'package:flutter/material.dart';

class MovieCastsPage extends StatefulWidget {
  final List<MovieCast> list;
  const MovieCastsPage({super.key, required this.list});

  @override
  State<MovieCastsPage> createState() => _MovieCastsPageState();
}

class _MovieCastsPageState extends State<MovieCastsPage> {
  final controller = ScrollController();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.list.isEmpty) {
      return Center(child: Text('List မရှိပါ!...'));
    }
    return CustomScrollView(
      controller: controller,
      slivers: [
        SliverGrid.builder(
          // shrinkWrap: true,
          itemCount: widget.list.length,
          // physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 150,
            mainAxisExtent: 150,
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
          ),
          itemBuilder: (context, index) => _getGridItem(widget.list[index]),
        ),
      ],
    );
  }

  Widget _getGridItem(MovieCast item) {
    return GestureDetector(
      onTap: () => _showImage(item.profilePath),
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: ClipOval(
                child: CacheImage(
                  url: Setting.getForwardProxyUrl(item.profilePath),
                ),
              ),
            ),
          ),
          Text(
            item.name,
            style: TextStyle(fontSize: 11),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  void _showImage(String url) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        scrollable: true,
        contentPadding: EdgeInsets.all(8),
        actionsPadding: EdgeInsets.all(4),
        content: CacheImage(url: Setting.getForwardProxyUrl(url)),
        actions: [CloseButton()],
      ),
    );
  }
}
