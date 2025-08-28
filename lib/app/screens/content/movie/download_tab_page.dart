import 'package:cm_app/app/models/download_link.dart';
import 'package:cm_app/my_libs/setting_v2.2.0/core/path_util.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_pkg/than_pkg.dart';

class DownloadTabPage extends StatefulWidget {
  List<DownloadLink> downloadList;
  DownloadTabPage({super.key, required this.downloadList});

  @override
  State<DownloadTabPage> createState() => _DownloadTabPageState();
}

class _DownloadTabPageState extends State<DownloadTabPage> {
  @override
  Widget build(BuildContext context) {
    if (widget.downloadList.isEmpty) {
      return Center(child: Text('Download Link မရှိပါ...'));
    }
    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(),
      itemCount: widget.downloadList.length,
      itemBuilder: (context, index) {
        final link = widget.downloadList[index];
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: ListTile(
            onTap: () => _showItemMenu(link),
            leading: SizedBox(
              width: 30,
              height: 30,
              child: TCacheImage(
                cachePath: PathUtil.getCachePath(),
                url: link.iconUrl,
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
    );
  }

  void _showItemMenu(DownloadLink link) {
    showTMenuBottomSheet(
      context,
      title: Text(link.title.toCaptalize()),
      children: [
        ListTile(
          leading: Icon(Icons.open_in_browser),
          title: Text('Open Url'),
          onTap: () {
            Navigator.pop(context);
            ThanPkg.platform.launch(link.url);
          },
        ),
        ListTile(
          leading: Icon(Icons.copy_all),
          title: Text('Copy Url'),
          onTap: () {
            Navigator.pop(context);
            ThanPkg.appUtil.copyText(link.url);
          },
        ),
      ],
    );
  }
}
