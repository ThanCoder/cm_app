import 'dart:convert';

import 'package:cm_app/more_libs/language/language_model.dart';
import 'package:cm_app/more_libs/language/language_source_strategy.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class LanguageAssestSource extends LanguageSourceStrategy {
  @override
  Future<List<LanguageModel>> getSupportedLanguages() async {
    return [
      LanguageModel.defaultLang(),
      LanguageModel(
        code: 'my',
        name: 'Myanmar',
        type: LanguageSourceType.assets,
        isDownload: true,
      ),
    ];
  }

  @override
  Future<Map<String, dynamic>> load(langCode) async {
    try {
      final source = await rootBundle.loadString(
        'assets/lang/$langCode.json',
        cache: false,
      );
      final map = jsonDecode(source);
      return map;
    } catch (e) {
      debugPrint('[LanguageAssestSource:load]: $e');
      return {};
    }
  }
}
