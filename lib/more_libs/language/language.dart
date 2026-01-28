import 'package:cm_app/more_libs/language/language_model.dart';

class Language {
  final Map<String, dynamic> langMap;
  final LanguageModel model;
  Language({required this.model, this.langMap = const {}});

  String get(String langKey) => langMap[langKey] ?? langKey;

  Language copyWith({Map<String, dynamic>? langMap, LanguageModel? model}) {
    return Language(
      langMap: langMap ?? this.langMap,
      model: model ?? this.model,
    );
  }
}
