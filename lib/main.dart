import 'dart:io';

import 'package:cm_app/core/utils/app_util.dart';
import 'package:cm_app/keys.dart';
import 'package:cm_app/platform_app.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppUtil.instance.init();

  if (!Platform.isAndroid) {
    // Must add this line.
    await windowManager.ensureInitialized();
    final cf = AppUtil.instance.config;
    WindowOptions windowOptions = WindowOptions(
      size: Size(
        cf.getDouble(appWindowWidthKey, 600),
        cf.getDouble(appWindowHeightKey, 400),
      ),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  runApp(const PlatformApp());
}
