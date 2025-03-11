import 'package:cm_app/app/constants.dart';
import 'package:cm_app/app/models/movie_model.dart';
import 'package:cm_app/app/notifiers/app_notifier.dart';
import 'package:cm_app/app/services/c_m_services.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart';

class MovieProvider with ChangeNotifier {
  final List<MovieModel> _list = [];
  final List<MovieModel> homeList = [];
  bool _isLoading = false;
  String? _nextUrl;

  List<MovieModel> get getList => _list;
  bool get isLoading => _isLoading;
  final String _name = 'movies';
  String? get getNextUrl => _nextUrl;

  Future<void> nextPage() async {
    if (getNextUrl == null && getNextUrl!.isEmpty) return;
    try {
      _isLoading = true;
      notifyListeners();

      CMServices.instance.getMovieList(
        url: getNextUrl!,
        onResult: (list, nextUrl) {
          _nextUrl = nextUrl;
          _list.addAll(list);
          _isLoading = false;
          notifyListeners();
        },
        onError: (err) {
          _isLoading = false;
          notifyListeners();
          debugPrint(err);
        },
      );
      // await Future.delayed(Duration(seconds: 4));
      // _isLoading = false;
      // notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('nextPage: ${e.toString()}');
    }
  }

  Future<void> initList({bool isListClear = false}) async {
    try {
      _isLoading = true;
      if (isListClear) {
        _list.clear();
      }
      notifyListeners();

      CMServices.instance.getMovieList(
        url: '$appHostUrl/$_name',
        onResult: (list, nextUrl) {
          _nextUrl = nextUrl;
          _list.addAll(list);
          _isLoading = false;
          notifyListeners();
        },
        onError: (err) {
          _isLoading = false;
          notifyListeners();
          debugPrint(err);
        },
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> initHomeList({bool isListClear = false}) async {
    try {
      if (isListClear) {
        homeList.clear();
      }
      //list ကို မရှင်းဘူးဆိုရင် တားဆီးထားမယ်
      if (!isListClear && homeList.isNotEmpty) return;
      _isLoading = true;
      notifyListeners();

      final res = await CMServices.instance
          .getForwardProxyHtml(appConfigNotifier.value.hostUrl);

      final dom = Document.html(res);
      final eles = dom.querySelectorAll('.item_1 .item');

      for (var ele in eles) {
        final movie = MovieModel.fromElement(ele);
        homeList.add(movie);
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint(e.toString());
    }
  }
}
