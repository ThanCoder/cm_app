import 'package:cm_app/more_libs/language/language_assest_source.dart';
import 'package:cm_app/more_libs/language/language_model.dart';

class LanguageRepo {
  static final LanguageRepo instance = LanguageRepo._();
  LanguageRepo._();

  final assetSource = LanguageAssestSource();

  Future<List<LanguageModel>> getAllLanguages() async {
    List<LanguageModel> allLangs = [];
    allLangs.addAll(await assetSource.getSupportedLanguages());
    return allLangs;
  }
}
