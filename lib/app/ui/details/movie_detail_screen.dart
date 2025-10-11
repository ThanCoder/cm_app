import 'dart:convert';

import 'package:cm_app/app/core/models/movie.dart';
import 'package:cm_app/app/core/models/movie_detail.dart';
import 'package:cm_app/app/core/models/movie_download_link.dart';
import 'package:cm_app/app/services/client_services.dart';
import 'package:cm_app/more_libs/setting_v2.8.3/setting.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/functions/message_func.dart';
import 'package:t_widgets/t_widgets_dev.dart';
import 'package:t_widgets/widgets/t_loader.dart';
import 'package:than_pkg/than_pkg.dart';

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

  Future<void> init() async {
    try {
      setState(() {
        isLoading = true;
      });
      final res = await ClientServices.instance.getUrlContent(
        Setting.getForwardProxyUrl(widget.movie.url),
      );
      final map = jsonDecode(res);
      detail = MovieDetail.fromMap(map['data']);
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
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
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [_getAppbar(), _getHeader()];
          },
          body: _getTabView(),
        ),
      ),
    );
  }

  Widget _getAppbar() {
    final size = MediaQuery.of(context).size;
    return SliverAppBar(
      expandedHeight: size.height * 0.5,
      flexibleSpace: TImage(
        source: Setting.getForwardProxyUrl(widget.movie.poster),
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
          Tab(text: 'Detail', icon: Icon(Icons.details)),
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
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(detail!.overview, style: TextStyle(fontSize: 16)),
          ),
        ),
        _getDownloadWidget(),
      ],
    );
  }

  Widget _getDownloadWidget() {
    return ListView.builder(
      itemCount: detail!.downloadList.length,
      itemBuilder: (context, index) =>
          _getDownloadListItem(detail!.downloadList[index]),
    );
  }

  Widget _getDownloadListItem(MovieDownloadLink link) {
    return GestureDetector(
      onTap: () {
        ThanPkg.platform.launch(link.url);
      },
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 3,
              children: [
                Text(link.serverName),
                Text('Size: ${link.size}'),
                Text('Quality: ${link.quality}'),
              ],
            ),
            IconButton(
              onPressed: () {
                ThanPkg.platform.launch(link.url);
              },
              icon: Icon(Icons.download, color: Colors.teal),
            ),
          ],
        ),
      ),
    );
  }
}
