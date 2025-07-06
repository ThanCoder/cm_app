import 'dart:async';

import 'package:cm_app/app/components/core/app_components.dart';
import 'package:cm_app/app/models/movie_genres_model.dart';
import 'package:cm_app/app/models/movie_model.dart';
import 'package:cm_app/app/models/movie_year_model.dart';
import 'package:cm_app/app/services/dio_services.dart';
import 'package:cm_app/my_libs/setting/app_notifier.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as html;
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
  List<MovieModel> resultList = [];
  List<MovieYearModel> yearList = [];
  List<MovieGenresModel> genresList = [];

  Future<void> _searchText(String query) async {
    if (isLoading) return;
    try {
      setState(() {
        isLoading = true;
      });
      final hostUrl = appConfigNotifier.value.hostUrl;
      final url = DioServices.instance.getForwardProxyUrl('$hostUrl/?s=$query');
      // final htmlText = await DioServices.instance.getCacheHtml(
      //   url: url,
      //   cacheName: query,
      // );
      final htmlText = await DioServices.instance.getDio.get(url);
      final dom = html.Document.html(htmlText.data ?? '');
      final eles = dom.querySelectorAll('.item_1 .item');
      resultList.clear();
      for (var ele in eles) {
        resultList.add(MovieModel.fromElement(ele));
      }
      setState(() {
        isShowResult = true;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      showDialogMessage(context, e.toString());
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
              : SearchHome(
                  yearList: yearList,
                  genresList: genresList,
                ),
    );
  }
}
