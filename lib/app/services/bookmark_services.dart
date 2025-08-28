import 'dart:convert';
import 'dart:io';

import 'package:cm_app/app/constants.dart';
import 'package:cm_app/app/models/movie.dart';
import 'package:cm_app/my_libs/setting_v2.2.0/core/path_util.dart';
import 'package:flutter/widgets.dart';

mixin BookmarkDBListener {
  void onBookmarkDBChanged();
}

class BookmarkServices {
  static final BookmarkServices instance = BookmarkServices._();
  BookmarkServices._();
  factory BookmarkServices() => instance;

  Future<void> toggle({required Movie movie}) async {
    try {
      if (await exists(title: movie.title)) {
        await remove(title: movie.title);
      } else {
        await add(movie: movie);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<bool> exists({required String title}) async {
    bool res = false;
    try {
      var list = await getList();
      // await Future.delayed(Duration(seconds: 4));

      if (list.isEmpty) return false;

      res = list.any((bm) => bm.title == title);
    } catch (e) {
      debugPrint(e.toString());
    }
    return res;
  }

  Future<void> remove({required String title}) async {
    try {
      var list = await getList();
      list = list.where((bm) => bm.title != title).toList();
      //save
      await save(list);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> add({required Movie movie}) async {
    try {
      final list = await getList();
      list.insert(0, movie);
      //save
      //save
      await save(list);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> save(List<Movie> list) async {
    final dbFile = File(getDBPath);
    final jsonList = list.map((bm) => bm.toMap()).toList();
    await dbFile.writeAsString(JsonEncoder.withIndent(' ').convert(jsonList));
    notifyListeners();
  }

  Future<List<Movie>> getList() async {
    List<Movie> list = [];
    try {
      final dbFile = File(getDBPath);
      if (!await dbFile.exists()) return [];
      List<dynamic> res = await jsonDecode(await dbFile.readAsString());
      list = res.map((map) => Movie.fromMap(map)).toList();
    } catch (e) {
      debugPrint(e.toString());
    }
    return list;
  }

  String get getDBPath =>
      '${PathUtil.getDatabasePath()}/$appBookmarkDatabaseName';

  // listener
  static final List<BookmarkDBListener> _listener = [];

  void addListener(BookmarkDBListener eve) {
    _listener.add(eve);
  }

  void removeListener(BookmarkDBListener eve) {
    _listener.remove(eve);
  }

  void notifyListeners() {
    for (var eve in _listener) {
      eve.onBookmarkDBChanged();
    }
  }
}
