import 'package:cm_app/app/ui/home/home_screen.dart';
import 'package:cm_app/more_libs/setting_v2.8.3/core/index.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemeSwitcher(
      builder: (config) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: config.isDarkTheme ? ThemeData.dark() : ThemeData.light(),
          themeMode: config.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
          home: HomeScreen(),
        );
      },
    );
  }
}
