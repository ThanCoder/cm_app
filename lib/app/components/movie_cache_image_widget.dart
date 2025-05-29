import 'package:cm_app/app/models/movie_model.dart';
import 'package:cm_app/app/services/dio_services.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';

class MovieCacheImageWidget extends StatefulWidget {
  MovieModel movie;
  MovieCacheImageWidget({super.key, required this.movie});

  @override
  State<MovieCacheImageWidget> createState() => _MovieCacheImageWidgetState();
}

class _MovieCacheImageWidgetState extends State<MovieCacheImageWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
  }

  bool isLoading = true;

  Future<void> init() async {
    try {
      //download cache
      await DioServices.instance.downloadCover(
          url: DioServices.instance.getForwardProxyUrl(widget.movie.coverUrl),
          savePath: widget.movie.coverPath);

      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      debugPrint('init ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return TLoader();
    } else {
      return TImageFile(
        path: widget.movie.coverPath,
        width: double.infinity,
      );
    }
  }
}
