import 'package:cm_app/app/my_app.dart';
import 'package:cm_app/more_libs/desktop_exe_1.0.2/desktop_exe.dart';
import 'package:cm_app/more_libs/general_static_server/constants.dart';
import 'package:cm_app/more_libs/general_static_server/general_server.dart';
import 'package:cm_app/more_libs/setting_v2.8.3/core/index.dart';
import 'package:cm_app/more_libs/setting_v2.8.3/setting.dart';
import 'package:flutter/material.dart';
import 'package:t_client/t_client.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:t_widgets/theme/t_theme_services.dart';
import 'package:than_pkg/than_pkg.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThanPkg.instance.init();
  TThemeServices.instance.init();

  final client = TClient();

  await TWidgets.instance.init(
    defaultImageAssetsPath: 'assets/logo.png',
    getDarkMode: () => Setting.getAppConfig.isDarkTheme,
    // isDebugPrint: kDebugMode,
    isDebugPrint: false,
    getCachePath: (url) =>
        '${PathUtil.getCachePath()}/${url.getName().replaceAll('/', '-').replaceAll(':', '-')}.png',
    onDownloadImage: (url, savePath) async {
      await client.download(url, savePath: savePath);
    },
  );

  //init config
  await Setting.instance.initSetting(appName: 'cm_app');

  // gen desktop icon
  await DesktopExe.instance.exportNotExists(
    name: 'CM App',
    assetsIconPath: 'assets/logo.png',
  );
  GeneralServer.instance.init(
    getApiServerUrl: () => apiServerUrl,
    getLocalServerPath: () => localServerPath,
    getContentFromUrl: (url) async {
      final res = await client.get(url);
      return res.data.toString();
    },
    packageName: 'cm_app',
  );

  if (TPlatform.isDesktop) {
    WindowOptions windowOptions = const WindowOptions(
      size: Size(602, 568), // စတင်ဖွင့်တဲ့အချိန် window size

      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      center: false,
      title: "CM App",
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  runApp(const MyApp());
}
