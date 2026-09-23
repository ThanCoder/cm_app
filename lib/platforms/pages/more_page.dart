import 'package:cm_app/core/utils/app_util.dart';
import 'package:cm_app/platforms/components/dialog/app_about_dialog.dart';
import 'package:cm_app/platforms/pages/cache_manager.dart';
import 'package:cm_app/platforms/pages/forward_proxy_page.dart';
import 'package:cm_app/platforms/pages/version_manager.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';

import 'dev_pages/dev_route_tile.dart';

class MorePage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("More Apps")),
      body: TScrollableColumn(
        padding: .symmetric(vertical: 10, horizontal: 15),
        children: [
          TMaterialThemeProviderChooser(),
          VersionManager(githubUrl: 'https://github.com/ThanCoder/cm_app'),
          CacheManagerListTile(
            cacheDirPath: AppUtil.instance.getPlatformCachePath(),
          ),
          ForwardProxyPageListTile(),
          DevRouteTile(),
          AppAboutDialogListTile(),
        ],
      ),
    );
  }
}
