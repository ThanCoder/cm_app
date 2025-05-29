import 'dart:io';

import 'package:flutter/material.dart';

extension CacheExtensions on List<FileSystemEntity> {
  int getSize() {
    int res = 0;
    try {
      for (var file in this) {
        if (file.statSync().type == FileSystemEntityType.directory) {
          //is dir
          res += _getSize(Directory(file.path));
        }
        res += file.statSync().size;
      }
    } catch (e) {
      debugPrint('CacheExtensions::getCacheSize: ${e.toString()}');
    }
    return res;
  }

  static int _getSize(Directory dir) {
    var len = 0;
    for (var ent in dir.listSync(recursive: true)) {
      if (ent is File) {
        len += ent.lengthSync();
      }
    }
    return len;
  }
}
