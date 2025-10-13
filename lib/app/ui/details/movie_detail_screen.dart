import 'dart:convert';

import 'package:cm_app/app/core/models/movie.dart';
import 'package:cm_app/app/core/models/movie_detail.dart';
import 'package:cm_app/app/services/cache_services.dart';
import 'package:cm_app/app/services/client_services.dart';
import 'package:cm_app/app/ui/details/movie_casts_page.dart';
import 'package:cm_app/app/ui/details/movie_download_list_page.dart';
import 'package:cm_app/app/ui/details/poster_app_bar.dart';
import 'package:cm_app/more_libs/setting_v2.8.3/setting.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets_dev.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;
  const MovieDetailScreen({super.key, required this.movie});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  MovieDetail? detail;
  bool isLoading = false;

  Future<void> init({bool isUsedCached = true}) async {
    try {
      setState(() {
        isLoading = true;
      });
      if (isUsedCached) {
        final cache = await CacheServices.getMovieCache(widget.movie.title);
        if (cache != null) {
          detail = cache;
          if (!mounted) return;
          setState(() {
            isLoading = false;
          });
          return;
        }
      }

      final res = await ClientServices.instance.getUrlContent(
        Setting.getForwardProxyUrl(widget.movie.url),
      );
      if (!mounted) return;
      isLoading = false;

      final map = jsonDecode(res);
      detail = MovieDetail.fromMap(map['data']);
      //set cache
      CacheServices.setMovieCache(widget.movie.title, detail: detail!);

      setState(() {});
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      showTMessageDialog(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: RefreshIndicator.noSpinner(
          onRefresh: () async {
            init(isUsedCached: false);
          },
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                PosterAppBar(
                  movie: widget.movie,
                  onInit: () => init(isUsedCached: false),
                ),
                _getHeader(),
              ];
            },
            body: _getTabView(),
          ),
        ),
      ),
    );
  }

  Widget _getHeader() {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.movie.title),
          Row(
            children: [
              Icon(Icons.star, color: Colors.yellow),
              Text(widget.movie.rating),
            ],
          ),
        ],
      ),
      bottom: TabBar(
        tabs: [
          Tab(text: 'Detail', icon: Icon(Icons.description)),
          Tab(text: 'သရုပ်ဆောင်များ', icon: Icon(Icons.people)),
          Tab(text: 'Download', icon: Icon(Icons.download)),
        ],
      ),
    );
  }

  Widget _getTabView() {
    if (isLoading) {
      return Center(child: TLoader.random());
    }
    if (detail == null) {
      return Center(child: Text('Movie Detail မရှိပါ!...'));
    }
    return TabBarView(
      children: [
        _getDetail(),
        MovieCastsPage(list: detail!.castList),
        MovieDownloadListPage(list: detail!.downloadList),
      ],
    );
  }

  Widget _getDetail() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 4,
          children: [
            Text('Original Title: `${detail!.originalTitle}`'),
            detail!.runtime.isEmpty
                ? SizedBox.shrink()
                : Text('Runtime: ${detail!.runtime}  Mins'),
            Text('Year: ${widget.movie.year}'),
            Text('is Adult: ${detail!.isAdult ? 'Yes' : 'No'}'),
            // Text('Directors	:${widget.movie.id}'),
            Divider(),
            Text(detail!.overview, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
