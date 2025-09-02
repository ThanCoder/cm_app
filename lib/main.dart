import 'package:cm_app/my_libs/desktop_exe/desktop_exe.dart';
import 'package:cm_app/my_libs/setting_v2.2.0/setting.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_pkg/than_pkg.dart';

import 'app/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThanPkg.instance.init();

  final dio = Dio();

  await TWidgets.instance.init(
    defaultImageAssetsPath: 'assets/logo.png',
    getDarkMode: () => Setting.getAppConfig.isDarkTheme,
    // isDebugPrint: kDebugMode,
    isDebugPrint: false,
    onDownloadImage: (url, savePath) async {
      await dio.download(url, savePath);
    },
  );

  //init config
  await Setting.instance.initSetting(
    appName: 'cm_app',
    appVersionLabel: 'CM App Pre',
    onSettingSaved: (context, message) {
      showTSnackBar(context, message);
    },
  );

  // gen desktop icon
  await DesktopExe.instance.exportNotExists(
    name: 'CM App',
    assetsIconPath: 'assets/logo.png',
  );

  runApp(const MyApp());
}
