import 'dart:convert';
import 'dart:io';

import 'package:cm_app/core/utils/app_util.dart';
import 'package:crypto/crypto.dart';

class CacheUtils {
  static String getHashId(String content) {
    return sha1.convert(utf8.encode(content)).toString();
  }

  static Future<void> setContent(String id, String content) async {
    final path = AppUtil.instance.getPlatformCachePath(id);
    await File(path).writeAsString(content);
  }

  static Future<String?> getContent(String id) async {
    final f = File(AppUtil.instance.getPlatformCachePath(id));
    if (f.existsSync()) {
      return await f.readAsString();
    }
    return null;
  }
}
