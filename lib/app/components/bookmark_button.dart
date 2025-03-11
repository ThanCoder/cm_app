import 'package:cm_app/app/models/movie_model.dart';
import 'package:cm_app/app/services/bookmark_services.dart';
import 'package:cm_app/app/widgets/index.dart';
import 'package:flutter/material.dart';

class BookmarkButton extends StatefulWidget {
  MovieModel movie;
  BookmarkButton({super.key, required this.movie});

  @override
  State<BookmarkButton> createState() => _BookmarkButtonState();
}

class _BookmarkButtonState extends State<BookmarkButton> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: BookmarkServices.instance.exists(title: widget.movie.title),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            width: 30,
            height: 30,
            child: TLoader(size: 30),
          );
        }
        if (snapshot.hasData) {
          final isExists = snapshot.data!;
          return IconButton(
            onPressed: () async {
              await BookmarkServices.instance.toggle(movie: widget.movie);
              if (!mounted) return;
              setState(() {});
            },
            icon: Icon(
              color: isExists ? Colors.red : Colors.teal,
              isExists ? Icons.bookmark_remove : Icons.bookmark_add,
            ),
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}
