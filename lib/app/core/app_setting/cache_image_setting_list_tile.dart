import 'package:flutter/material.dart';
import 'package:than_pkg/t_database/t_recent_db.dart';

class CacheImageSettingListTile extends StatefulWidget {
  final VoidCallback? onChanged;
  const CacheImageSettingListTile({super.key, this.onChanged});

  @override
  State<CacheImageSettingListTile> createState() =>
      _CacheImageSettingListTileState();

  static bool get isUseCacheImage =>
      TRecentDB.getInstance.getBool('use_cache_image', def: true);
}

class _CacheImageSettingListTileState extends State<CacheImageSettingListTile> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: SwitchListTile.adaptive(
        value: CacheImageSettingListTile.isUseCacheImage,
        onChanged: (value) async {
          await TRecentDB.getInstance.put('use_cache_image', value);
          setState(() {});
          widget.onChanged?.call();
        },
        title: Text('Use Cache Image'),
      ),
    );
  }
}
