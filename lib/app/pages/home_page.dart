import 'dart:io';

import 'package:cm_app/app/pages/home/movie_list_page.dart';
import 'package:cm_app/app/pages/home/series_list_page.dart';
import 'package:cm_app/app/providers/movie_provider.dart';
import 'package:cm_app/app/providers/series_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../widgets/index.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
  }

  bool allRefersh = false;

  Future<void> init() async {
    final movieProvider = context.read<MovieProvider>();
    final seriesProvider = context.read<SeriesProvider>();
    if (allRefersh) {
      await movieProvider.initList();
      await seriesProvider.initList();
      allRefersh = false;
    }
    if (movieProvider.getList.isEmpty) {
      await movieProvider.initList();
    }
    if (seriesProvider.getList.isEmpty) {
      await seriesProvider.initList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        title: Text(appTitle),
        actions: [
          Platform.isLinux
              ? IconButton(
                  onPressed: () {
                    allRefersh = true;
                    init();
                  },
                  icon: Icon(Icons.refresh),
                )
              : SizedBox.shrink(),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await init();
        },
        child: SingleChildScrollView(
          child: Column(
            spacing: 10,
            children: [
              MovieListPage(),
              SeriesListPage(),
            ],
          ),
        ),
      ),
    );
  }
}
