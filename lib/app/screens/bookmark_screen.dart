import 'package:cm_app/app/components/movie_grid_item.dart';
import 'package:cm_app/app/models/movie_model.dart';
import 'package:cm_app/app/screens/content/movie_content_screen.dart';
import 'package:cm_app/app/services/bookmark_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:t_widgets/t_widgets.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  
  void _showMenu(MovieModel movie) {
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
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Mark'),
      ),
      body: Consumer<BookmarkServices>(
        builder: (context, value, child) {
          return FutureBuilder(
            future: BookmarkServices.instance.getList(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return TLoader();
              }
              if (snapshot.hasData) {
                final list = snapshot.data!;
                return GridView.builder(
                  itemCount: list.length,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 160,
                    mainAxisExtent: 180,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                  ),
                  itemBuilder: (context, index) => MovieGridItem(
                    movie: list[index],
                    onClicked: (movie) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MovieContentScreen(movie: movie),
                        ),
                      );
                    },
                    onMenuClicked: _showMenu,
                  ),
                );
              }
              return SizedBox.shrink();
            },
          );
        },
      ),
    );
  }
}
