import 'dart:io';

import 'package:cm_app/core/utils/app_utils.dart';
import 'package:cm_app/keys.dart';
import 'package:cm_app/ui/platforms/desktop/desktop_home_screen.dart';
import 'package:cm_app/ui/platforms/mobile/mobile_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';

class PlatformApp extends StatefulWidget {
  const new({super.key});

  @override
  State<PlatformApp> createState() => _PlatformAppState();
}

class _PlatformAppState extends State<PlatformApp> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AppUtils.instance.config.stream.put.where(
        (e) => e.key == appThemKey,
      ),
      builder: (context, asyncSnapshot) {
        return TMaterialThemeProvider(
          getTheme: () =>
              .fromName(AppUtils.instance.config.getString(appThemKey)),
          onChanged: (type) {
            AppUtils.instance.config.putAndWriteAll(appThemKey, type.name);
          },
          child: Platform.isAndroid ? MobileHomeScreen() : DesktopHomeScreen(),
        );
      },
    );
  }
}
