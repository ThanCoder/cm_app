import 'dart:async';

import 'package:cm_app/core/utils/app_util.dart';
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
  final config = AppUtil.instance.config;
  BoxConstraints? constraints;
  Timer? _saveTimer;

  void saveSize() {
    if (constraints == null) return;
    _saveTimer?.cancel();
    _saveTimer = Timer(Duration(seconds: 3), () {
      config
          .put(appWindowWidthKey, constraints?.maxWidth)
          .put(appWindowHeightKey, constraints?.maxHeight)
          .writeAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: config.stream.put.where((e) => e.key == appThemeKey),
      builder: (context, asyncSnapshot) {
        return TMaterialThemeProvider(
          getTheme: () => .fromName(config.getString(appThemeKey)),
          onChanged: (type) {
            config.putAndWriteAll(appThemeKey, type.name);
          },
          child: _body,
        );
      },
    );
  }

  Widget get _body {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth <= 500;
        AppUtil.instance.isMobileNotifier.value = isMobile;
        this.constraints = constraints;
        saveSize();

        if (isMobile) {
          return MobileHomeScreen();
        }
        return DesktopHomeScreen();
      },
    );
  }
}
