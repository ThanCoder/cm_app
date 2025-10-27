import 'dart:convert';

import 'package:cm_app/app/core/models/movie.dart';
import 'package:cm_app/app/core/models/season.dart';
import 'package:cm_app/app/core/models/series_detail.dart';
import 'package:cm_app/app/route_helper.dart';
import 'package:cm_app/app/services/cache_services.dart';
import 'package:cm_app/app/services/client_services.dart';
import 'package:cm_app/app/ui/details/season_view.dart';
import 'package:cm_app/app/ui/details/detail_app_bar.dart';
import 'package:cm_app/app/ui/details/movie_casts_page.dart';
import 'package:cm_app/app/ui/details/overview_viewer.dart';
import 'package:cm_app/app/ui/details/poster_app_bar.dart';
import 'package:cm_app/app/ui/screens/ep_download_link_screen.dart';
import 'package:cm_app/more_libs/setting_v2.8.3/setting.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';

class SeriesDetailScreen extends StatefulWidget {
  final Movie movie;
  const SeriesDetailScreen({super.key, required this.movie});

  @override
  State<SeriesDetailScreen> createState() => _SeriesDetailScreenState();
}

class _SeriesDetailScreenState extends State<SeriesDetailScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  SeriesDetail? detail;
  bool isLoading = false;

  Future<void> init({bool isUsedCached = true}) async {
    try {
      setState(() {
        isLoading = true;
      });
      if (isUsedCached) {
        final cache = await CacheServices.getSeriesCache(widget.movie.title);
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
      detail = SeriesDetail.fromMap(map['data']);
      //set cache
      CacheServices.setSeriesCache(widget.movie.title, detail: detail!);

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
        body: RefreshIndicator.adaptive(
          onRefresh: () async {
            init(isUsedCached: false);
          },
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                DetailAppBar<SeriesDetail>(
                  movie: widget.movie,
                  onInit: () => init(isUsedCached: false),
                  detail: detail,
                ),
                PosterAppBar(movie: widget.movie),
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
          Tab(text: 'Episode', icon: Icon(Icons.play_circle)),
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
        OverviewViewer<SeriesDetail>(movie: widget.movie, detail: detail),
        MovieCastsPage(list: detail!.castList),
        SeasonView(detail: detail!, onClicked: _goDownloadLink),
      ],
    );
  }

  void _goDownloadLink(Episode ep) {
    goRoute(context, builder: (context) => EpDownloadLinkScreen(episode: ep));
  }
}
