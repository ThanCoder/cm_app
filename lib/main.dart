import 'dart:io';

import 'package:cm_app/core/utils/app_utils.dart';
import 'package:cm_app/ui/platform_app.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppUtils.instance.init();
  if (!Platform.isAndroid) {
    // Must add this line.
    await windowManager.ensureInitialized();

    //   WindowOptions windowOptions = WindowOptions(
    //     size: Size(800, 600),
    //     center: true,
    //     backgroundColor: Colors.transparent,
    //     skipTaskbar: false,
    //     titleBarStyle: TitleBarStyle.normal,
    //   );
    //   windowManager.waitUntilReadyToShow(windowOptions, () async {
    //     await windowManager.show();
    //     await windowManager.focus();
    //   });
  }

  runApp(const PlatformApp());
}
