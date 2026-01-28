import 'package:cm_app/more_libs/language/app_language_page.dart';
import 'package:cm_app/more_libs/language/language_controller.dart';
import 'package:flutter/material.dart';

class LanguageListTile extends StatelessWidget {
  const LanguageListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.language_outlined),
        title: LanguageController.instance.didLanguageChanged(
          'language',
          builder: (langValue) => Text(langValue),
        ),
        subtitle: ValueListenableBuilder(
          valueListenable: LanguageController.instance.currentLanguage,
          builder: (context, value, child) {
            return Text(value.model.name);
          },
        ),
        trailing: Icon(Icons.arrow_forward_ios_rounded),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AppLanguagePage()),
          );
        },
      ),
    );
  }
}
