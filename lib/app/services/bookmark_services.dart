import 'dart:convert';
import 'dart:io';

import 'package:cm_app/app/constants.dart';
import 'package:cm_app/app/models/movie_model.dart';
import 'package:cm_app/app/utils/path_util.dart';
import 'package:flutter/widgets.dart';

class BookmarkServices {
  static final BookmarkServices instance = BookmarkServices._();
  BookmarkServices._();
  factory BookmarkServices() => instance;

  Future<void> toggle({required MovieModel movie}) async {
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
      final data = jsonEncode(list.map((bm) => bm.toMap()).toList());
      final dbFile = File(getDBPath);
      await dbFile.writeAsString(data);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> add({required MovieModel movie}) async {
    try {
      final list = await getList();
      list.insert(0, movie);
      //save
      final data = jsonEncode(list.map((bm) => bm.toMap()).toList());
      final dbFile = File(getDBPath);
      await dbFile.writeAsString(data);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<List<MovieModel>> getList() async {
    List<MovieModel> list = [];
    try {
      final dbFile = File(getDBPath);
      if (!await dbFile.exists()) return [];
      List<dynamic> res = await jsonDecode(await dbFile.readAsString());
      list = res.map((map) => MovieModel.fromMap(map)).toList();
    } catch (e) {
      debugPrint(e.toString());
    }
    return list;
  }

  String get getDBPath =>
      '${PathUtil.instance.getDatabasePath()}/$appBookmarkDatabaseName';
}
