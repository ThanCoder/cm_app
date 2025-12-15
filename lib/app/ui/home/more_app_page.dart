import 'package:cm_app/more_libs/general_static_server/ui/tutorial/tutorial_buttons.dart';
import 'package:cm_app/more_libs/setting/core/thancoder_about_widget.dart';
import 'package:cm_app/more_libs/setting/setting.dart';
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
          Setting.getThemeModeChooser,
          Setting.getCurrentVersionWidget,
          Setting.getSettingListTileWidget,
          Setting.getCacheManagerWidget,
          Divider(),
          TutorialListTileButton(),
          Divider(),
          ThancoderAboutWidget(),
        ],
      ),
    );
  }
}
