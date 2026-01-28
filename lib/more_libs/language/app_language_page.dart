import 'package:cm_app/more_libs/language/language.dart';
import 'package:cm_app/more_libs/language/language_controller.dart';
import 'package:cm_app/more_libs/language/language_model.dart';
import 'package:cm_app/more_libs/language/language_repo.dart';
import 'package:flutter/material.dart';

class AppLanguagePage extends StatefulWidget {
  const AppLanguagePage({super.key});

  @override
  State<AppLanguagePage> createState() => _AppLanguagePageState();
}

class _AppLanguagePageState extends State<AppLanguagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('App Language')),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LanguageController.instance.didLanguageChanged(
                      'language',
                      builder: (langValue) => Text(langValue),
                    ),
                    _languageList(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _languageList() {
    return FutureBuilder(
      future: LanguageRepo.instance.getAllLanguages(),
      builder: (context, snapshot) {
        final list = snapshot.data ?? [];
        return DropdownButton<LanguageModel>(
          value: _current(list),
          items: list.map((e) => _listItem(e)).toList(),
          onChanged: (value) async {
            final lang = await value!.load();
            LanguageController.instance.changeLanguage(
              Language(model: value, langMap: lang),
            );
            setState(() {});
          },
        );
      },
    );
  }

  LanguageModel? _current(List<LanguageModel> list) {
    if (list.isEmpty) return null;
    return list.firstWhere(
      (e) =>
          e.code ==
          LanguageController.instance.currentLanguage.value.model.code,
    );
  }

  DropdownMenuItem<LanguageModel> _listItem(LanguageModel model) {
    return DropdownMenuItem<LanguageModel>(
      value: model,
      child: Text(model.name),
    );
  }
}
