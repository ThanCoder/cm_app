import 'package:cm_app/app/route_helper.dart';
import 'package:cm_app/app/ui/home/library_page.dart';
import 'package:cm_app/app/ui/screens/movie_bookmark_screen.dart';
import 'package:cm_app/more_libs/setting/setting.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TScrollableColumn(
              children: [
                DrawerHeader(child: TImage(source: '')),
                ListTile(
                  leading: Icon(Icons.bookmark),
                  title: Text('BookMark'),
                  onTap: () {
                    Navigator.pop(context);
                    goRoute(
                      context,
                      builder: (context) => MovieBookmarkScreen(),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.library_books),
                  title: Text('Library'),
                  onTap: () {
                    Navigator.pop(context);
                    goRoute(context, builder: (context) => LibraryPage());
                  },
                ),
              ],
            ),
          ),
          Setting.getSettingListTileWidget,
        ],
      ),
    );
  }
}
