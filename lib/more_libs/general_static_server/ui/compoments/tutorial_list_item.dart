import 'package:flutter/material.dart';
import 'package:cm_app/more_libs/general_static_server/core/models/tutorial.dart';

class TutorialListItem extends StatelessWidget {
  final Tutorial item;
  final void Function(Tutorial item)? onClicked;
  const TutorialListItem({super.key, required this.item, this.onClicked});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.title),
      subtitle: item.desc.isEmpty ? null : Text(item.desc),
      onTap: () => onClicked?.call(item),
    );
  }
}
