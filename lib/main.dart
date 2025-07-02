import 'package:cm_app/app/providers/movie_provider.dart';
import 'package:cm_app/app/providers/series_provider.dart';
import 'package:cm_app/my_libs/general_server_v1.0.0/index.dart';
import 'package:cm_app/my_libs/setting/app_notifier.dart';
import 'package:cm_app/app/services/bookmark_services.dart';
import 'package:cm_app/my_libs/setting/setting.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_pkg/than_pkg.dart';

import 'app/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThanPkg.instance.init();

  await TWidgets.instance.init(
    defaultImageAssetsPath: 'assets/logo.webp',
    getDarkMode: () => appConfigNotifier.value.isDarkTheme,
    // isDebugPrint: kDebugMode,
    isDebugPrint: false,
  );

  //init config
  await Setting.initAppConfigService();

  await GeneralServices.instance.init(packageName: 'cm_app');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MovieProvider()),
        ChangeNotifierProvider(create: (context) => SeriesProvider()),
        ChangeNotifierProvider(create: (context) => BookmarkServices()),
      ],
      child: const MyApp(),
    ),
  );
}
