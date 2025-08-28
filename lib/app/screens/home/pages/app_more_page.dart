import 'package:cm_app/my_libs/setting_v2.2.0/setting.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';

class AppMorePage extends StatelessWidget {
  const AppMorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('More')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //theme
            TListTileWithDesc(
              leading: Icon(Icons.dark_mode_outlined),
              title: 'Dark Theme',
              trailing: ValueListenableBuilder(
                valueListenable: Setting.getAppConfigNotifier,
                builder: (context, config, child) => Checkbox(
                  value: config.isDarkTheme,
                  onChanged: (value) {
                    Setting.getAppConfigNotifier.value = config.copyWith(
                      isDarkTheme: value,
                    );
                    //set config
                    Setting.getAppConfigNotifier.value.save();
                  },
                ),
              ),
            ),
            //version
            Setting.getCurrentVersionWidget,
            //Clean Cache
            Setting.getCacheManagerWidget,

            //version
            const Divider(),
            //setting
            Setting.getSettingListTileWidget,
          ],
        ),
      ),
    );
  }
}
