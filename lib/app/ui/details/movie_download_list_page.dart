import 'package:cm_app/app/core/models/movie_download_link.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_pkg/than_pkg.dart';

class MovieDownloadListPage extends StatefulWidget {
  final List<MovieDownloadLink> list;
  const MovieDownloadListPage({super.key, required this.list});

  @override
  State<MovieDownloadListPage> createState() => _MovieDownloadListPageState();
}

class _MovieDownloadListPageState extends State<MovieDownloadListPage> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      // primary: false, // controller reuse မဖြစ်စေဖို့
      itemCount: widget.list.length,
      itemBuilder: (context, index) => _getlistItem(widget.list[index]),
    );
  }

  Widget _getlistItem(MovieDownloadLink link) {
    return GestureDetector(
      onTap: () => _openUrl(link.url),
      child: Card(
        color: link.url.isEmpty ? Colors.red : null,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 3,
                children: [
                  Text('T: ${link.serverName}'),
                  Text('Size: ${link.size}'),
                  Text('Quality: ${link.quality}'),
                  Text('Resolution: ${link.resolution}'),
                ],
              ),
              IconButton(
                onPressed: () => _openUrl(link.url),
                icon: Icon(Icons.download, color: Colors.teal),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openUrl(String url) {
    if (url.isEmpty) {
      showTMessageDialogError(context, 'url မရှိပါ');
      return;
    }
    ThanPkg.platform.launch(url);
  }
}
