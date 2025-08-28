import 'package:cm_app/app/components/movie_grid_item.dart';
import 'package:cm_app/app/models/movie.dart';
import 'package:cm_app/app/routes_helper.dart';
import 'package:cm_app/app/services/bookmark_services.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> with BookmarkDBListener {
  @override
  void initState() {
    BookmarkServices.instance.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    BookmarkServices.instance.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Library'), automaticallyImplyLeading: false),
      body: CustomScrollView(slivers: [_getBookmarkWidge()]),
    );
  }

  Widget _getBookmarkWidge() {
    return FutureBuilder(
      future: BookmarkServices.instance.getList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SliverToBoxAdapter(child: TLoader.random());
        }
        final list = snapshot.data ?? [];
        return SliverGrid.builder(
          itemCount: list.length,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 160,
            mainAxisExtent: 180,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
          ),
          itemBuilder: (context, index) {
            final item = list[index];
            return MovieGridItem(
              movie: item,
              onClicked: (movie) {
                goMovieContent(context, movie: movie);
              },
              onMenuClicked: _showMenu,
            );
          },
        );
      },
    );
  }

  void _showMenu(Movie movie) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: 100,
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.delete_forever),
              title: Text('Remove'),
              onTap: () {
                Navigator.pop(context);
                BookmarkServices.instance.remove(title: movie.title);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void onBookmarkDBChanged() {
    setState(() {});
  }
}
