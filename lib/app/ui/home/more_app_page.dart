import 'package:cm_app/more_libs/setting_v2.8.3/core/thancoder_about_widget.dart';
import 'package:cm_app/more_libs/setting_v2.8.3/setting.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';

class MoreAppPage extends StatelessWidget {
  const MoreAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('More')),
      body: TScrollableColumn(
        children: [
          Setting.getThemeSwitcherWidget,
          Setting.getCurrentVersionWidget,
          Setting.getSettingListTileWidget,
          Setting.getCacheManagerWidget,
          Divider(),
          ThancoderAboutWidget(),
        ],
      ),
    );
  }
}
