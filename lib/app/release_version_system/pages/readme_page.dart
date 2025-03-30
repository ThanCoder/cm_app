import 'package:cm_app/app/widgets/core/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:t_release/services/t_release_services.dart';

class ReadmePage extends StatelessWidget {
  const ReadmePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: TReleaseServices.instance.getReadme(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return TLoader();
        }
        if (snapshot.hasData) {
          return Markdown(data: snapshot.data ?? '');
        }
        return SizedBox.shrink();
      },
    );
  }
}
