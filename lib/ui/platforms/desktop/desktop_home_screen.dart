import 'package:cm_app/ui/pages/more_page.dart';
import 'package:cm_app/ui/platforms/desktop/desktop_home_page.dart';
import 'package:flutter/material.dart';

class DesktopHomeScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<DesktopHomeScreen> createState() => _DesktopHomeScreenState();
}

class _DesktopHomeScreenState extends State<DesktopHomeScreen> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: index,
            onDestinationSelected: (value) {
              setState(() {
                index = value;
              });
            },
            destinations: [
              .new(icon: Icon(Icons.home), label: Text('Home')),
              .new(icon: Icon(Icons.grid_view_outlined), label: Text('More')),
            ],
          ),
          VerticalDivider(),
          Expanded(
            child: IndexedStack(
              index: index,
              children: [
                DesktopHomePage(),
                // MobileHomePage(),
                MorePage()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
