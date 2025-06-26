import 'package:cm_app/app/screens/home/pages/genres_page.dart';
import 'package:cm_app/app/screens/home/pages/library_page.dart';
import 'package:cm_app/my_libs/setting/app_notifier.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import 'pages/app_more_page.dart';
import 'pages/home_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int page = 0;
  final list = [
    HomePage(),
    GenresPage(),
    LibraryPage(),
    AppMorePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: appConfigNotifier,
        builder: (context, config, child) {
          return Scaffold(
            bottomNavigationBar: CurvedNavigationBar(
              height: 60,
              index: page,
              items: [
                Icon(Icons.home, size: 25),
                Icon(Icons.movie_filter_rounded, size: 25),
                Icon(Icons.library_books_rounded, size: 25),
                Icon(Icons.settings, size: 25),
              ],
              color: config.isDarkTheme
                  ? const Color.fromARGB(218, 0, 0, 0)
                  : const Color.fromARGB(218, 255, 255, 255),
              buttonBackgroundColor: Colors.white,
              backgroundColor: Colors.blueAccent,
              // backgroundColor: Colors.transparent,
              animationCurve: Curves.easeInOut,
              animationDuration: Duration(milliseconds: 600),
              letIndexChange: (index) => true,
              onTap: (value) {
                setState(() {
                  page = value;
                });
              },
            ),
            body: AnimatedSwitcher(
              duration: Duration(
                milliseconds: 800,
              ),
              child: Center(
                child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 800),
                    child: list[page]),
              ),
            ),
          );
        });
  }
}
