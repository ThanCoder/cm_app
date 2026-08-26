import 'package:cm_app/ui/pages/more_page.dart';
import 'package:cm_app/ui/platforms/mobile/mobile_home_page.dart';
import 'package:flutter/material.dart';

class MobileHomeScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<MobileHomeScreen> createState() => _MobileHomeScreenState();
}

class _MobileHomeScreenState extends State<MobileHomeScreen> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: index, children: [MobileHomePage(), MorePage()]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (value) {
          setState(() {
            index = value;
          });
        },
        items: [
          .new(icon: Icon(Icons.home), label: 'Home'),
          .new(icon: Icon(Icons.grid_view_outlined), label: 'More'),
        ],
      ),
    );
  }
}
