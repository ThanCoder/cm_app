import 'dart:io';

import 'package:cm_app/app/core/models/movie.dart';
import 'package:cm_app/app/route_helper.dart';
import 'package:cm_app/app/core/services/movie_services.dart';
import 'package:cm_app/app/ui/components/movie_grid_item.dart';
import 'package:cm_app/app/ui/screens/see_all_screen.dart';
import 'package:cm_app/more_libs/setting/core/path_util.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';

import 'package:than_pkg/than_pkg.dart';

class GridMovieComponent extends StatefulWidget {
  final String url;
  final String title;
  final MovieTypes type;
  const GridMovieComponent({
    super.key,
    required this.url,
    required this.title,
    required this.type,
  });

  @override
  State<GridMovieComponent> createState() => GridMovieComponentState();
}

class GridMovieComponentState extends State<GridMovieComponent> {
  static final Map<String, List<Movie>> _cache = {};
  List<Movie> list = [];
  bool isLoading = false;
  bool isInternetConnected = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init({bool isUsedCached = true}) async {
    try {
      final key = widget.title;
      if (isUsedCached && _cache.containsKey(key) && _cache[key]!.isNotEmpty) {
        list = _cache[key]!;
        setState(() {});
        return;
      }

      setState(() {
        isLoading = true;
      });
      isInternetConnected = await ThanPkg.platform.isInternetConnected();
      if (!isInternetConnected) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      list = await MovieServices.getMovies(widget.url);
      _cache[key] = list;
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      // showTMessageDialogError(context, 'Error ရှိနေပါတယ်။\n${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: TLoader.random());
    }
    if (list.isEmpty && !isInternetConnected) {
      return Column(
        children: [
          Center(
            child: Text(
              'Your Are Offline',
              style: TextStyle(fontSize: 18, color: Colors.red),
            ),
          ),
          IconButton(onPressed: init, icon: Icon(Icons.refresh)),
        ],
      );
    }
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${widget.title} မရှိပါ...'),
            IconButton(onPressed: init, icon: Icon(Icons.refresh)),
          ],
        ),
      );
    }
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 6),
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              GestureDetector(
                onTap: () => goRoute(
                  context,
                  builder: (context) => SeeAllScreen(type: widget.type),
                ),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Text(
                    'More >',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        GridView.builder(
          itemCount: list.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(), // scroll မဖြစ်အောင်
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 140,
            mainAxisExtent: 170,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
          ),
          itemBuilder: (context, index) => MovieGridItem(
            movie: list[index],
            onClicked: (movie) => goMovieDetailScreen(context, movie: movie),
            onRightClicked: _showMenu,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.all(5),
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 5, 65, 114),
                ),
                onPressed: () => goRoute(
                  context,
                  builder: (context) => SeeAllScreen(type: widget.type),
                ),
                child: Text('See More', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showMenu(Movie movie) {
    showTMenuBottomSheet(
      context,
      children: [
        ListTile(
          title: Text('Delete Cache'),
          onTap: () {
            final cachePath = PathUtil.getCachePath(
              name:
                  '${movie.url.getName().replaceAll('/', '-').replaceAll(':', '-')}.png',
            );
            final file = File(cachePath);
            if (file.existsSync()) {
              file.deleteSync();
            }
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
