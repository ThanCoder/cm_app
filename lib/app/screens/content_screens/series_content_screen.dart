import 'package:cm_app/app/models/movie_model.dart';
import 'package:cm_app/app/widgets/index.dart';
import 'package:flutter/material.dart';

class SeriesContentScreen extends StatelessWidget {
  MovieModel movie;
  SeriesContentScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
        appBar: AppBar(
          title: Text(movie.title),
        ),
        body: Column(
          children: [Text(movie.title)],
        ));
  }
}
