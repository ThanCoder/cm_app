import 'dart:convert';

import 'package:cm_app/app/core/models/movie.dart';
import 'package:cm_app/app/core/models/season.dart';
import 'package:cm_app/app/core/models/series_detail.dart';
import 'package:cm_app/app/route_helper.dart';
import 'package:cm_app/app/services/cache_services.dart';
import 'package:cm_app/app/services/client_services.dart';
import 'package:cm_app/app/ui/components/season_view.dart';
import 'package:cm_app/app/ui/ep_download_link_screen.dart';
import 'package:cm_app/more_libs/setting_v2.8.3/setting.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_pkg/than_pkg.dart';

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
      length: 2,
      child: Scaffold(
        body: RefreshIndicator.noSpinner(
          onRefresh: () async {
            init(isUsedCached: false);
          },
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [_getAppbar(), _getHeader()];
            },
            body: _getTabView(),
          ),
        ),
      ),
    );
  }

  Widget _getAppbar() {
    final size = MediaQuery.of(context).size;
    return SliverAppBar(
      expandedHeight: size.height * 0.6,
      flexibleSpace: TImage(
        source: Setting.getForwardProxyUrl(widget.movie.poster),
      ),
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Container(
          padding: EdgeInsets.only(left: 5, bottom: 2, top: 2),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
      ),
      actions: [
        // bookmark
        // MovieBookmarkButton(movie: widget.movie),
        !TPlatform.isDesktop
            ? SizedBox.shrink()
            : IconButton(
                onPressed: () => init(isUsedCached: false),
                icon: Container(
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Icon(Icons.refresh, color: Colors.white),
                ),
              ),
      ],
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
          Tab(text: 'Detail', icon: Icon(Icons.details)),
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
        _getDetail(),
        SeasonView(detail: detail!, onClicked: _goDownloadLink),
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
            Text('Runtime: ${detail!.runtime}'),
            Text('Year: ${widget.movie.year}'),
            Text('is Adult: ${detail!.isAdult ? 'Yes' : 'No'}'),
            Divider(),
            Text(detail!.overview, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  void _goDownloadLink(Episode ep) {
    goRoute(context, builder: (context) => EpDownloadLinkScreen(episode: ep));
  }
}
