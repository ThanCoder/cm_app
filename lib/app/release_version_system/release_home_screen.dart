import 'package:cm_app/app/release_version_system/pages/change_log_page.dart';
import 'package:cm_app/app/release_version_system/pages/readme_page.dart';
import 'package:cm_app/app/release_version_system/pages/release_license_page.dart';
import 'package:cm_app/app/release_version_system/pages/release_list_page.dart';
import 'package:cm_app/app/release_version_system/release_home_header.dart';
import 'package:flutter/material.dart';

class ReleaseHomeScreen extends StatelessWidget {
  const ReleaseHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Release'),
        ),
        body: Column(
          children: [
            ReleaseHomeHeader(),
            Expanded(
              child: TabBarView(
                children: [
                  ReleaseListPage(),
                  ChangeLogPage(),
                  ReadmePage(),
                  ReleaseLicensePage(),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: TabBar(
          tabs: [
            Tab(
              text: 'Release List',
            ),
            Tab(
              text: 'Change Log',
            ),
            Tab(
              text: 'Readme',
            ),
            Tab(
              text: 'License',
            ),
          ],
        ),
      ),
    );
  }
}
