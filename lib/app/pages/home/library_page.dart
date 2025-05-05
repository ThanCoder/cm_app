import 'package:cm_app/app/components/movie_see_all_list_view.dart';
import 'package:cm_app/app/screens/bookmark_screen.dart';
import 'package:cm_app/app/screens/movie_content_screen.dart';
import 'package:cm_app/app/services/bookmark_services.dart';
import 'package:cm_app/app/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  @override
  Widget build(BuildContext context) {
    return MyScaffold(
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
                        onSeeAllClicked: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookmarkScreen(),
                            ),
                          );
                        },
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
