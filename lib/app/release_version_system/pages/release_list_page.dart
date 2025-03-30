import 'dart:io';

import 'package:cm_app/app/release_version_system/release_list_item.dart';
import 'package:cm_app/app/widgets/core/index.dart';
import 'package:flutter/material.dart';
import 'package:t_release/services/t_release_version_services.dart';

class ReleaseListPage extends StatelessWidget {
  const ReleaseListPage({super.key});

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
                onClicked: (release) {},
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
