import 'package:cm_app/app/core/models/movie_cast.dart';
import 'package:cm_app/more_libs/setting_v2.8.3/setting.dart';
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
      slivers: [
        SliverGrid.builder(
          // controller: controller,
          // shrinkWrap: true,
          itemCount: widget.list.length,
          // physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 170,
            mainAxisExtent: 170,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
          ),
          itemBuilder: (context, index) => _getGridItem(widget.list[index]),
        ),
      ],
    );
    // return GridView.builder(
    //   controller: controller,
    //   shrinkWrap: true,
    //   itemCount: widget.list.length,
    //   physics: NeverScrollableScrollPhysics(),
    //   gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
    //     maxCrossAxisExtent: 170,
    //     mainAxisExtent: 170,
    //     mainAxisSpacing: 4,
    //     crossAxisSpacing: 4,
    //   ),
    //   itemBuilder: (context, index) => _getGridItem(widget.list[index]),
    // );
  }

  Widget _getGridItem(MovieCast item) {
    return Column(
      children: [
        Expanded(
          child: CircleAvatar(
            radius: 150 / 2,
            // foregroundImage: AssetImage(
            //   TWidgets.instance.defaultImageAssetsPath!,
            // ),
            backgroundImage: NetworkImage(
              Setting.getForwardProxyUrl(item.profilePath),
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
    );
  }
}
