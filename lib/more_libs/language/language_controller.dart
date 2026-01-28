import 'package:cm_app/more_libs/language/language.dart';
import 'package:cm_app/more_libs/language/language_model.dart';
import 'package:flutter/material.dart';

class LanguageController {
  static final LanguageController instance = LanguageController._();
  LanguageController._();
  factory LanguageController() => instance;

  ValueNotifier<Language> currentLanguage = ValueNotifier(
    Language(model: LanguageModel.defaultLang()),
  );

  // Language ပြောင်းတဲ့ Function
  Future<void> changeLanguage(Language language) async {
    currentLanguage.value = language;
  }

  String getLan(String langKey) {
    return currentLanguage.value.get(langKey);
  }

  Widget didLanguageChanged(
    String langKey, {
    required Widget Function(String langValue) builder,
  }) {
    return ValueListenableBuilder(
      valueListenable: currentLanguage,
      builder: (context, value, child) {
        return builder(value.get(langKey));
      },
    );
  }
}
