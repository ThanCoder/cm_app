import 'dart:io';

import 'package:cfb_store/cfb_store.dart';
import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

class AppUtils {
  static final AppUtils instance = AppUtils._();
  AppUtils._();
  factory AppUtils() => instance;

  late String packageName;
  late String version;
  late Directory configDir;
  final config = CFBStore.instance;

  Future<void> init() async {
    final info = await PackageInfo.fromPlatform();
    packageName = info.packageName;
    version = info.version;
    configDir = await getApplicationSupportDirectory();
    await config.open(getConfigPath('app.config.cfb'));
  }

  String getConfigPath([String? name]) {
    if (!configDir.existsSync()) {
      configDir.createSync(recursive: true);
    }

    if (name != null) {
      return configDir.join(name);
    }

    return configDir.path;
  }

  
}
