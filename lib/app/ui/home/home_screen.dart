import 'dart:math';

import 'package:cm_app/app/ui/home/home_page.dart';
import 'package:cm_app/app/ui/home/library_page.dart';
import 'package:cm_app/app/ui/home/more_app_page.dart';
import 'package:cm_app/app/ui/screens/movie_bookmark_screen.dart';
import 'package:cm_app/more_libs/language/language_controller.dart';
import 'package:cm_app/more_libs/setting/setting.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: index,
        children: [
          HomePage(),
          LibraryPage(),
          MovieBookmarkScreen(),
          MoreAppPage(key: ValueKey(Random.secure().nextInt(100))),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Setting.getAppConfig.isDarkTheme
            ? Colors.white
            : Colors.black,
        onTap: (value) {
          index = value;
          setState(() {});
        },
        items: [
          BottomNavigationBarItem(label: 'Home', icon: Icon(Icons.home)),
          BottomNavigationBarItem(
            label: 'Library',
            icon: Icon(Icons.library_books),
          ),
          BottomNavigationBarItem(
            label: 'BookMark',
            icon: Icon(Icons.bookmark_added),
          ),
          BottomNavigationBarItem(
            label: LanguageController.instance.getLan('more'),
            icon: Icon(Icons.grid_view_rounded),
          ),
        ],
      ),
    );
  }
}
