import 'package:cm_app/app/route_helper.dart';
import 'package:cm_app/app/ui/movie_bookmark_screen.dart';
import 'package:cm_app/more_libs/setting_v2.8.3/setting.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/widgets/t_image.dart';
import 'package:t_widgets/widgets/t_scrollable_column.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: TScrollableColumn(
        children: [
          DrawerHeader(child: TImage(source: '')),
          ListTile(
            leading: Icon(Icons.bookmark),
            title: Text('BookMark'),
            onTap: () {
              Navigator.pop(context);
              goRoute(context, builder: (context) => MovieBookmarkScreen());
            },
          ),
          Setting.getSettingListTileWidget,
        ],
      ),
    );
  }
}
