import 'dart:io';

import 'package:flutter/material.dart';
import 'package:than_pkg/than_pkg.dart';

class TrailerTabPage extends StatelessWidget {
  List<String> trailerList;
  TrailerTabPage({super.key, required this.trailerList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trailer Links'),
      ),
      body: trailerList.isEmpty
          ? Center(child: Text('Link မရှိပါ...'))
          : ListView.separated(
              itemBuilder: (context, index) {
                final url = trailerList[index];
                return ListTile(
                  onTap: () async {
                    if (Platform.isAndroid) {
                      await ThanPkg.android.app.openUrl(url: url);
                    } else {
                      await ThanPkg.linux.app.launch(url);
                    }
                  },
                  title: Text(
                    url,
                    style: TextStyle(color: Colors.blue),
                  ),
                );
              },
              separatorBuilder: (context, index) => Divider(),
              itemCount: trailerList.length,
            ),
    );
  }
}
