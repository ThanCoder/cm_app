import 'package:flutter/material.dart';

extension BuildContextExtensions on BuildContext {
  Brightness get appBrightness => Theme.of(this).brightness;
  Brightness get platformBrightness => MediaQuery.of(this).platformBrightness;

  bool get appIsDarkMode => appBrightness == Brightness.dark;

  void close({bool? dialogReturns}) {
    Navigator.pop(this, dialogReturns);
  }

  void goRoute({required Widget Function(BuildContext context) builder}) {
    Navigator.push(this, MaterialPageRoute(builder: builder));
  }
}
