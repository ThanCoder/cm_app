import 'package:cm_app/app/screens/home/pages/genres_page.dart';
import 'package:cm_app/app/screens/home/pages/library_page.dart';
import 'package:cm_app/my_libs/setting_v2.2.0/setting.dart';
import 'package:flutter/material.dart';

import 'pages/app_more_page.dart';
import 'pages/home_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;
  final pages = [HomePage(), GenresPage(), LibraryPage(), AppMorePage()];
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Setting.getAppConfigNotifier,
      builder: (context, config, child) {
        return Scaffold(
          body: AnimatedSwitcher(
            duration: Duration(milliseconds: 800),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 800),
                child: pages[index],
              ),
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: index,
            selectedItemColor: Colors.teal,
            unselectedItemColor: Setting.getAppConfig.isDarkTheme
                ? Colors.white
                : Colors.black,
            onTap: (value) {
              setState(() {
                index = value;
              });
            },
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                icon: Icon(Icons.sort_sharp),
                label: 'Genres',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.library_books),
                label: 'Library',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.grid_view_rounded),
                label: 'More',
              ),
            ],
          ),
        );
      },
    );
  }
}
