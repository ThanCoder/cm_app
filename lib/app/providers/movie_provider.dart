import 'package:cm_app/app/models/movie.dart';
import 'package:cm_app/app/services/cm_services.dart';
import 'package:cm_app/app/types/movie_types.dart';
import 'package:cm_app/my_libs/setting_v2.2.0/setting.dart';
import 'package:flutter/material.dart';

class MovieProvider with ChangeNotifier {
  final List<Movie> _list = [];
  final List<Movie> homeList = [];
  bool _isLoading = false;
  String? _nextUrl;

  List<Movie> get getList => _list;
  bool get isLoading => _isLoading;
  final String _name = 'movies';
  String? get getNextUrl => _nextUrl;

  Future<void> nextPage() async {
    if (getNextUrl == null && getNextUrl!.isEmpty) return;
    try {
      _isLoading = true;
      notifyListeners();

      final res = await CMServices.getMovieList(
        url: '${Setting.getAppConfig.hostUrl}/$_name',
      );
      if (res.error != null) {
        debugPrint(res.error);
        _isLoading = false;
        notifyListeners();
        return;
      }

      _nextUrl = res.nextUrl;
      _list.addAll(res.list);
      _isLoading = false;
      notifyListeners();

      // await Future.delayed(Duration(seconds: 4));
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('nextPage: ${e.toString()}');
    }
  }

  Future<void> initList({
    required MovieTypes type,
    bool isListClear = false,
  }) async {
    try {
      _isLoading = true;
      if (isListClear) {
        _list.clear();
      }
      notifyListeners();

      final res = await CMServices.getMovieList(
        url: '${Setting.getAppConfig.hostUrl}/$_name',
      );
      if (res.error != null) {
        debugPrint(res.error);
        _isLoading = false;
        notifyListeners();
        return;
      }
      // is success
      _nextUrl = res.nextUrl;
      _list.addAll(res.list);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
