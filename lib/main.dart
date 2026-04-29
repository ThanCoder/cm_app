import 'package:cf_lite/cf_lite.dart';
import 'package:cm_app/more_libs/setting/core/path_util.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_pkg/than_pkg.dart';
import 'package:cm_app/app/my_app.dart';
import 'package:cm_app/more_libs/desktop_exe/desktop_exe.dart';
import 'package:cm_app/more_libs/setting/setting.dart';

void main() async {
  await ThanPkg.instance.init();

  await Setting.instance.init(
    appName: 'CM Movies',
    releaseUrl: 'https://github.com/ThanCoder/cm_app/releases',
    onSettingSaved: (context, message) {
      showTSnackBar(context, message);
    },
  );

  await TWidgets.instance.init(
    initialThemeServices: true,
    defaultImageAssetsPath: 'assets/logo_2.jpg',
    getCachePath: (url, cacheName) => PathUtil.getCachePath(name: cacheName),
  );

  if (TPlatform.isDesktop) {
    await DesktopExe.exportDesktopIcon(
      name: Setting.instance.appName,
      assetsIconPath: 'assets/logo_2.jpg',
    );

    WindowOptions windowOptions = WindowOptions(
      size: Size(602, 568), // စတင်ဖွင့်တဲ့အချိန် window size

      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      center: false,
      title: Setting.instance.appName,
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      // await windowManager.focus();
    });
  }
  // config
  await CFLite.getInstance().init(
    dbPath: PathUtil.getConfigPath(name: 'config.db.json'),
  );

  runApp(const MyApp());
}
