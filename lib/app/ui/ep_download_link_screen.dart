import 'package:cm_app/app/core/models/movie_download_link.dart';
import 'package:cm_app/app/core/models/season.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_pkg/than_pkg.dart';

class EpDownloadLinkScreen extends StatefulWidget {
  final Episode episode;
  const EpDownloadLinkScreen({super.key, required this.episode});

  @override
  State<EpDownloadLinkScreen> createState() => _EpDownloadLinkScreenState();
}

class _EpDownloadLinkScreenState extends State<EpDownloadLinkScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ep: ${widget.episode.episodeNumber}')),
      body: _getDownloadWidget(widget.episode.tvshowDownloadLinks),
    );
  }

  Widget _getDownloadWidget(List<MovieDownloadLink> list) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) => _getDownloadListItem(list[index]),
    );
  }

  Widget _getDownloadListItem(MovieDownloadLink link) {
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
