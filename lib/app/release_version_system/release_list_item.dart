import 'package:cm_app/app/extensions/datetime_extenstion.dart';
import 'package:flutter/material.dart';
import 'package:t_release/models/t_release_version_model.dart';

class ReleaseListItem extends StatelessWidget {
  TReleaseVersionModel release;
  void Function(TReleaseVersionModel release) onClicked;
  ReleaseListItem({
    super.key,
    required this.release,
    required this.onClicked,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Version: ${release.version}'),
        Text('Platform: ${release.platform}'),
        Text(DateTime.fromMillisecondsSinceEpoch(release.date).toTimeAgo()),
        release.description.isNotEmpty
            ? Text(release.description)
            : SizedBox.shrink(),
        release.url.isNotEmpty
            ? Text('Url: ${release.url}')
            : SizedBox.shrink(),
        release.url.isNotEmpty
            ? IconButton(
                onPressed: () => onClicked(release),
                icon: Icon(Icons.download),
              )
            : SizedBox.shrink(),
      ],
    );
  }
}
