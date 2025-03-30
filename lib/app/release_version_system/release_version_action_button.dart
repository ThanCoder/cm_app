import 'package:cm_app/app/release_version_system/release_home_screen.dart';
import 'package:flutter/material.dart';

class ReleaseVersionActionButton extends StatelessWidget {
  const ReleaseVersionActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReleaseHomeScreen(),
          ),
        );
      },
      icon: Icon(Icons.notifications),
    );
  }
}
