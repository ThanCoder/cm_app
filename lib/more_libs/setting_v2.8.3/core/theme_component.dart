import 'package:flutter/material.dart';

import 'app_notifier.dart';

class ThemeComponent extends StatelessWidget {
  const ThemeComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: appConfigNotifier,
      builder: (context, config, child) {
        return CheckboxListTile.adaptive(
          title: Text('Dark Mode'),
          value: config.isDarkTheme,
          onChanged: (value) {
            appConfigNotifier.value = appConfigNotifier.value.copyWith(
              isDarkTheme: value,
            );
            appConfigNotifier.value.save();
          },
        );
      },
    );
  }
}
