import 'package:cm_app/more_libs/language/language_model.dart';

abstract class LanguageSourceStrategy {
  Future<List<LanguageModel>> getSupportedLanguages();
  Future<Map<String, dynamic>> load(String langCode);
}
