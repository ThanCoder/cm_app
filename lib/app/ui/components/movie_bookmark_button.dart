import 'package:cm_app/app/core/models/movie.dart';
import 'package:cm_app/app/services/movie_bookmark_services.dart';
import 'package:flutter/material.dart';

class MovieBookmarkButton extends StatefulWidget {
  final Movie movie;
  const MovieBookmarkButton({super.key, required this.movie});

  @override
  State<MovieBookmarkButton> createState() => _MovieBookmarkButtonState();
}

class _MovieBookmarkButtonState extends State<MovieBookmarkButton> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: MovieBookmarkServices.isExists(widget.movie.title),
      builder: (context, snapshot) {
        final isExists = snapshot.data ?? false;

        return IconButton(
          onPressed: () async {
            if (isExists) {
              await MovieBookmarkServices.getDatabase.delete(widget.movie.id);
            } else {
              await MovieBookmarkServices.getDatabase.add(widget.movie);
            }
            setState(() {});
          },
          icon: Icon(
            color: isExists ? Colors.red : Colors.teal,
            isExists ? Icons.bookmark_remove : Icons.bookmark_add,
          ),
        );
      },
    );
  }
}
