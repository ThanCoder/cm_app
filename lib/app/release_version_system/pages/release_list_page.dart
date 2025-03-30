import 'dart:io';

import 'package:cm_app/app/components/core/app_components.dart';
import 'package:cm_app/app/dialogs/index.dart';
import 'package:cm_app/app/extensions/string_extension.dart';
import 'package:cm_app/app/release_version_system/release_list_item.dart';
import 'package:cm_app/app/services/core/dio_services.dart';
import 'package:cm_app/app/utils/index.dart';
import 'package:cm_app/app/widgets/core/index.dart';
import 'package:flutter/material.dart';
import 'package:t_release/models/t_release_version_model.dart';
import 'package:t_release/services/t_release_version_services.dart';

class ReleaseListPage extends StatefulWidget {
  const ReleaseListPage({super.key});

  @override
  State<ReleaseListPage> createState() => _ReleaseListPageState();
}

class _ReleaseListPageState extends State<ReleaseListPage> {
  void _download(TReleaseVersionModel release) {
    final title = release.url.getName();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => DownloadDialog(
        title: 'Download App',
        url: DioServices.instance.getForwardProxyUrl(release.url),
        saveFullPath: '${PathUtil.instance.getOutPath()}/$title',
        message: '$title downloading...',
        onError: (msg) {
          showDialogMessage(context, msg);
        },
        onSuccess: (savedPath) {
          showDialogMessage(context,
              'download လုပ်ပြီးပါပြီ။\npath: ${PathUtil.instance.getOutPath()}/${release.url.getName()}');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder(
        future: TReleaseVersionServices.instance.getVersionList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return TLoader();
          }
          if (snapshot.hasData) {
            var list = snapshot.data ?? [];
            list = list
                .where((re) => re.platform == Platform.operatingSystem)
                .toList();
            return ListView.separated(
              itemCount: list.length,
              itemBuilder: (context, index) => ReleaseListItem(
                release: list[index],
                onClicked: _download,
              ),
              separatorBuilder: (context, index) => Divider(),
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}
