import 'dart:io';

import 'package:cm_app/app/models/movie_genres_model.dart';
import 'package:cm_app/app/screens/genres_movie_screen.dart';
import 'package:cm_app/app/services/index.dart';
import 'package:cm_app/app/widgets/index.dart';
import 'package:flutter/material.dart';

class GenresPage extends StatefulWidget {
  const GenresPage({super.key});

  @override
  State<GenresPage> createState() => _GenresPageState();
}

class _GenresPageState extends State<GenresPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
  }

  final TextEditingController titleController = TextEditingController();
  bool isLoading = true;
  List<MovieGenresModel> list = [];
  List<MovieGenresModel> allList = [];

  void init({bool isClearCache = false}) async {
    setState(() {
      isLoading = true;
    });
    allList = await CMServices.instance.getGenresList(isOverride: isClearCache);

    if (!mounted) return;
    setState(() {
      isLoading = false;
      list = allList;
    });
  }

  void _filterTitle(String? title) {
    if (title == null) return;
    final res = allList
        .where((gen) => gen.title.toLowerCase().contains(title.toLowerCase()))
        .toList();
    setState(() {
      list = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      contentPadding: 0,
      appBar: AppBar(
        title: Text('Genres'),
        automaticallyImplyLeading: false,
        actions: [
          Platform.isLinux
              ? IconButton(
                  onPressed: () {
                    init(isClearCache: true);
                  },
                  icon: Icon(Icons.refresh),
                )
              : SizedBox.shrink(),
        ],
      ),
      body: isLoading
          ? TLoader()
          : RefreshIndicator(
              onRefresh: () async {
                init(isClearCache: true);
              },
              child: CustomScrollView(
                slivers: [
                  //list filter
                  SliverAppBar(
                    floating: false,
                    pinned: true,
                    flexibleSpace: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TTextField(
                        label: Text('Filter Genres....'),
                        controller: titleController,
                        onChanged: _filterTitle,
                      ),
                    ),
                  ),
                  //show list empty
                  SliverToBoxAdapter(
                    child: list.isEmpty
                        ? Center(child: Text('list is empty'))
                        : SizedBox.shrink(),
                  ),
                  //list
                  SliverList.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final genres = list[index];
                      return ListTile(
                        title: Text(genres.title),
                        trailing: Text(genres.count),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GenresMovieScreen(
                                genres: genres,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
