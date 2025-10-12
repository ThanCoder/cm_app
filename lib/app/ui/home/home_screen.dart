import 'package:cm_app/app/ui/home/home_page.dart';
import 'package:cm_app/app/ui/home/library_page.dart';
import 'package:cm_app/app/ui/home/more_app_page.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: TabBarView(children: [HomePage(), LibraryPage(), MoreAppPage()]),
        bottomNavigationBar: TabBar(
          tabs: [
            Tab(text: 'Home', icon: Icon(Icons.home)),
            Tab(text: 'Library', icon: Icon(Icons.library_books)),
            Tab(text: 'More', icon: Icon(Icons.grid_view_rounded)),
          ],
        ),
      ),
    );
  }
}
