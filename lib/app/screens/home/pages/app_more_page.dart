import 'package:cm_app/my_libs/clean_cache/cache_component.dart';
import 'package:cm_app/my_libs/general_server_v1.0.0/current_version_component.dart';
import 'package:cm_app/my_libs/setting/app_notifier.dart';
import 'package:cm_app/my_libs/setting/app_setting_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';

class AppMorePage extends StatelessWidget {
  const AppMorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('More'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //theme
            TListTileWithDesc(
              leading: Icon(Icons.dark_mode_outlined),
              title: 'Dark Theme',
              trailing: ValueListenableBuilder(
                valueListenable: appConfigNotifier,
                builder: (context, config, child) => Checkbox(
                  value: config.isDarkTheme,
                  onChanged: (value) {
                    appConfigNotifier.value =
                        config.copyWith(isDarkTheme: value);
                    //set config
                    appConfigNotifier.value.save();
                  },
                ),
              ),
            ),
            //version
            CurrentVersionComponent(),
            //Clean Cache
            CacheComponent(),

            //version
            const Divider(),
            //setting
            AppSettingListTile(),
          ],
        ),
      ),
    );
  }
}
