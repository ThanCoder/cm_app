import 'package:cm_app/app/core/models/movie.dart';
import 'package:cm_app/app/route_helper.dart';
import 'package:cm_app/app/services/movie_bookmark_services.dart';
import 'package:cm_app/app/ui/components/movie_grid_item.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_pkg/than_pkg.dart';

class MovieBookmarkScreen extends StatefulWidget {
  const MovieBookmarkScreen({super.key});

  @override
  State<MovieBookmarkScreen> createState() => _MovieBookmarkScreenState();
}

class _MovieBookmarkScreenState extends State<MovieBookmarkScreen>
    with TDatabaseListener {
  @override
  void initState() {
    MovieBookmarkServices.getDatabase.addListener(this);
    super.initState();
    init();
  }

  @override
  void dispose() {
    MovieBookmarkServices.getDatabase.removeListener(this);
    super.dispose();
  }

  @override
  void onDatabaseChanged(TDatabaseListenerTypes type, String? id) async {
    if (id == null) return;

    if (type == TDatabaseListenerTypes.delete) {
      if (!mounted) return;
      init();
    }
    if (type == TDatabaseListenerTypes.update) {
      if (!mounted) return;
      init();
    }
  }

  bool isLoading = false;
  List<Movie> list = [];

  Future<void> init({bool isUsedCache = true}) async {
    try {
      setState(() {
        isLoading = true;
      });
      await Future.delayed(Duration(milliseconds: 200));
      list = await MovieBookmarkServices.getDatabase.getAll(
        query: {'isUsedCache': isUsedCache},
      );

      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      showTMessageDialogError(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Mark'),
        actions: [
          !TPlatform.isDesktop
              ? SizedBox.shrink()
              : IconButton(
                  onPressed: () => init(isUsedCache: false),
                  icon: Icon(Icons.refresh),
                ),
        ],
      ),
      body: _getList(),
    );
  }

  Widget _getList() {
    if (isLoading) {
      return Center(child: TLoader.random());
    }
    return RefreshIndicator.adaptive(
      onRefresh: init,
      child: GridView.builder(
        itemCount: list.length,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 140,
          mainAxisExtent: 170,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
        ),
        itemBuilder: (context, index) => MovieGridItem(
          movie: list[index],
          onClicked: (movie) => goMovieDetailScreen(context, movie: movie),
          onRightClicked: _showItemMenu,
        ),
      ),
    );
  }

  void _showItemMenu(Movie movie) {
    showTMenuBottomSheet(
      context,
      title: Text(movie.title),
      children: [
        ListTile(
          iconColor: Colors.red,
          textColor: Colors.red,
          leading: Icon(Icons.remove),
          title: Text('Movie'),
          onTap: () {
            Navigator.pop(context);
            try {
              MovieBookmarkServices.getDatabase.delete(movie.id);
            } catch (e) {
              showTMessageDialogError(context, e.toString());
            }
          },
        ),
      ],
    );
  }
}
