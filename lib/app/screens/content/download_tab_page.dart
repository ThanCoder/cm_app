import 'dart:io';

import 'package:cm_app/app/models/download_link_model.dart';
import 'package:cm_app/app/services/dio_services.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/widgets/t_image_url.dart';
import 'package:than_pkg/than_pkg.dart';

class DownloadTabPage extends StatelessWidget {
  List<DownloadLinkModel> downloadList;
  DownloadTabPage({
    super.key,
    required this.downloadList,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Download Links'),
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) => const Divider(),
        itemCount: downloadList.length,
        itemBuilder: (context, index) {
          final link = downloadList[index];
          return MouseRegion(
            cursor: SystemMouseCursors.click,
            child: ListTile(
              onTap: () {
                if (Platform.isLinux) {
                  ThanPkg.linux.app.launch(link.url);
                }
                if (Platform.isAndroid) {
                  ThanPkg.android.app.openUrl(url: link.url);
                }
              },
              leading: SizedBox(
                width: 30,
                height: 30,
                child: TImageUrl(
                  url: DioServices.instance.getForwardProxyUrl(link.iconUrl),
                  width: double.infinity,
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Server: ${link.title.trim()}'),
                  Text('Size: ${link.size}'),
                  Text('Quality: ${link.quality}'),
                  // Text(link.url),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
