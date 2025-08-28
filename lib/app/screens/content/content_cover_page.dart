import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';

class ContentCoverPage extends StatelessWidget {
  List<String> coverUrls;
  ContentCoverPage({super.key, required this.coverUrls});

  @override
  Widget build(BuildContext context) {
    if (coverUrls.isEmpty) {
      return Center(child: Text('Cover မရှိပါ...'));
    }
    return ListView.builder(
      itemCount: coverUrls.length,
      itemBuilder: (context, index) => TImage(source: coverUrls[index]),
    );
  }
}
