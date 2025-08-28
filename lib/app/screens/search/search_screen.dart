import 'dart:async';

import 'package:cm_app/app/models/movie.dart';
import 'package:cm_app/app/models/movie_genres_model.dart';
import 'package:cm_app/app/models/movie_year_model.dart';
import 'package:cm_app/app/services/dio_services.dart';
import 'package:cm_app/my_libs/setting_v2.2.0/setting.dart';
import 'package:flutter/material.dart';
import 'package:t_html_parser/t_html_extensions.dart';
import 'package:t_widgets/t_widgets.dart';

import 'search_field.dart';
import 'search_home.dart';
import 'search_result_list.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isShowResult = false;
  bool isLoading = false;
  List<Movie> resultList = [];
  List<MovieYearModel> yearList = [];
  List<MovieGenresModel> genresList = [];

  Future<void> _searchText(String query) async {
    if (isLoading) return;
    try {
      setState(() {
        isLoading = true;
      });
      final hostUrl = Setting.getAppConfig.hostUrl;
      final url = DioServices.instance.getForwardProxyUrl('$hostUrl/?s=$query');
      // final htmlText = await DioServices.instance.getCacheHtml(
      //   url: url,
      //   cacheName: query,
      // );
      final htmlText = await DioServices.instance.getHtml(url);
      final dom = htmlText.toHtmlDocument;
      final eles = dom.querySelectorAll('.item_1 .item');
      resultList.clear();
      for (var ele in eles) {
        resultList.add(Movie.fromElement(ele));
      }
      setState(() {
        isShowResult = true;
        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SearchField(
          onSubmitted: _searchText,
          onCleared: () {
            setState(() {
              isShowResult = false;
            });
          },
        ),
      ),
      body: isLoading
          ? TLoader()
          : isShowResult
          ? SearchResultList(list: resultList)
          : SearchHome(yearList: yearList, genresList: genresList),
    );
  }
}
