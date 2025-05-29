import 'package:cm_app/app/components/movie_see_all_list_view.dart';
import 'package:cm_app/app/models/movie_model.dart';
import 'package:cm_app/app/screens/bookmark_screen.dart';
import 'package:cm_app/app/screens/content/movie_content_screen.dart';
import 'package:cm_app/app/services/bookmark_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:t_widgets/t_widgets.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  
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
        title: Text('Library'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          spacing: 10,
          children: [
            //book mark
            Consumer<BookmarkServices>(
              builder: (context, value, child) {
                return FutureBuilder(
                  future: BookmarkServices.instance.getList(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return TLoader();
                    }
                    if (snapshot.hasData) {
                      return MovieSeeAllListView(
                        width: 150,
                        height: 170,
                        title: 'BookMark',
                        list: snapshot.data!,
                        onClicked: (movie) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MovieContentScreen(movie: movie),
                            ),
                          );
                        },
                        onSeeAllClicked: (title, list) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookmarkScreen(),
                            ),
                          );
                        },
                        onMenuClicked: _showMenu,
                      );
                    }
                    return SizedBox.shrink();
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
