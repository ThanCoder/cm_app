import 'package:cm_app/app/components/movie_grid_item.dart';
import 'package:cm_app/app/screens/movie_content_screen.dart';
import 'package:cm_app/app/services/bookmark_services.dart';
import 'package:cm_app/app/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  @override
  Widget build(BuildContext context) {
    return MyScaffold(
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
