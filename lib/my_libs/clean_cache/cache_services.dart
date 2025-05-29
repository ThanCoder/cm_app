import 'dart:io';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'cache_extensions.dart';
import 'package:than_pkg/than_pkg.dart';

import '../setting/path_util.dart';

class CacheServices {
  static Future<List<FileSystemEntity>> getList() async {
    final cacheDir = Directory(PathUtil.getCachePath());
    final sourceDir = Directory(PathUtil.getSourcePath());

    return Isolate.run(() async {
      List<FileSystemEntity> list = [];
      try {
        final cacheFiles = cacheDir.listSync();

        for (var sourceFile in sourceDir.listSync()) {
          if (sourceFile.isFile()) {
            list.add(sourceFile);
          }
        }

        list.addAll(cacheFiles);
      } catch (e) {
        debugPrint('getCacheCount: ${e.toString()}');
      }
      return list;
    });
  }

  static Future<int> getCount() async {
    return (await getList()).length;
  }

  static Future<int> getSize() async {
    final list = await getList();
    return list.getSize();
  }

  static Future<void> clean() async {
    try {
      for (var file in await getList()) {
        final type = file.statSync().type;

        if (type == FileSystemEntityType.directory) {
          await Directory(file.path).delete(recursive: true);
        } else {
          //dir
          await File(file.path).delete(recursive: true);
        }
        // print(file.statSync().type);
      }
    } catch (e) {
      debugPrint('cleanCache: ${e.toString()}');
    }
  }
}
