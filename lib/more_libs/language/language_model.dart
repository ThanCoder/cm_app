import 'package:cm_app/more_libs/language/language_repo.dart';

class LanguageModel {
  final String code;
  final String name;
  final LanguageSourceType type;
  final bool isDownload;
  LanguageModel({
    required this.code,
    required this.name,
    required this.type,
    required this.isDownload,
  });
  factory LanguageModel.defaultLang() {
    return LanguageModel(
      code: 'en',
      name: 'English',
      type: LanguageSourceType.assets,
      isDownload: true,
    );
  }

  LanguageModel copyWith({
    String? code,
    String? name,
    LanguageSourceType? type,
    bool? isDownload,
  }) {
    return LanguageModel(
      code: code ?? this.code,
      name: name ?? this.name,
      type: type ?? this.type,
      isDownload: isDownload ?? this.isDownload,
    );
  }

  Future<Map<String, dynamic>> load() async {
    if (type == LanguageSourceType.assets) {
      return await LanguageRepo.instance.assetSource.load(code);
    }
    return {};
  }

  @override
  String toString() {
    return name;
  }
}

enum LanguageSourceType { assets, local, api }
