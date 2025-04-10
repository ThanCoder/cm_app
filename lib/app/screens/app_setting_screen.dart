import 'dart:io';

import 'package:cm_app/app/general_server/proxy_hosting_server/forward_proxy_t_text_field.dart';
import 'package:flutter/material.dart';

import '../extensions/index.dart';
import '../components/index.dart';
import '../constants.dart';
import '../dialogs/core/index.dart';
import '../models/index.dart';
import '../notifiers/app_notifier.dart';
import '../services/core/index.dart';
import '../widgets/index.dart';

class AppSettingScreen extends StatefulWidget {
  const AppSettingScreen({super.key});

  @override
  State<AppSettingScreen> createState() => _AppSettingScreenState();
}

class _AppSettingScreenState extends State<AppSettingScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  bool isChanged = false;
  bool isCustomPathTextControllerTextSelected = false;
  late AppConfigModel config;
  TextEditingController customPathTextController = TextEditingController();
  TextEditingController appHostUrlController = TextEditingController();
  TextEditingController forwardProxyController = TextEditingController();

  void init() async {
    customPathTextController.text = '${getAppExternalRootPath()}/.$appName';
    config = appConfigNotifier.value;
    appHostUrlController.text = config.hostUrl;
    forwardProxyController.text = config.forwardProxy;
  }

  void _saveConfig() async {
    try {
      if (Platform.isAndroid && config.isUseCustomPath) {
        if (!await checkStoragePermission()) {
          if (mounted) {
            showConfirmStoragePermissionDialog(context);
          }
          return;
        }
      }
      //set custom path
      config.customPath = customPathTextController.text;
      config.hostUrl = appHostUrlController.text;
      config.forwardProxy = forwardProxyController.text;
      //save
      setConfigFile(config);
      appConfigNotifier.value = config;
      if (config.isUseCustomPath) {
        //change
        appRootPathNotifier.value = config.customPath;
      }
      //init config
      await initAppConfigService();
      //init

      if (!mounted) return;
      showMessage(context, 'Config ကိုသိမ်းဆည်းပြီးပါပြီ');
      setState(() {
        isChanged = false;
      });
      Navigator.pop(context);
    } catch (e) {
      debugPrint('saveConfig: ${e.toString()}');
    }
  }

  void _onBackpress() {
    if (!isChanged) {
      return;
    }

    showDialog(
      context: context,
      builder: (context) => ConfirmDialog(
        contentText: 'setting ကိုသိမ်းဆည်းထားချင်ပါသလား?',
        cancelText: 'မသိမ်းဘူး',
        submitText: 'သိမ်းမယ်',
        onCancel: () {
          isChanged = false;
          Navigator.pop(context);
        },
        onSubmit: () {
          _saveConfig();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !isChanged,
      onPopInvokedWithResult: (didPop, result) {
        _onBackpress();
      },
      child: MyScaffold(
        appBar: AppBar(
          title: const Text('Setting'),
        ),
        body: SingleChildScrollView(
          child: Column(
            spacing: 5,
            children: [
              //custom path
              ListTileWithDesc(
                title: "custom path",
                desc: "သင်ကြိုက်နှစ်သက်တဲ့ path ကို ထည့်ပေးပါ",
                trailing: Checkbox(
                  value: config.isUseCustomPath,
                  onChanged: (value) {
                    setState(() {
                      config.isUseCustomPath = value!;
                      isChanged = true;
                    });
                  },
                ),
              ),
              if (config.isUseCustomPath)
                ListTileWithDescWidget(
                  widget1: TextField(
                    controller: customPathTextController,
                    onTap: () {
                      if (!isCustomPathTextControllerTextSelected) {
                        customPathTextController.selectAll();
                        isCustomPathTextControllerTextSelected = true;
                      }
                    },
                    onTapOutside: (event) {
                      isCustomPathTextControllerTextSelected = false;
                    },
                  ),
                  widget2: IconButton(
                    onPressed: () {
                      _saveConfig();
                    },
                    icon: const Icon(
                      Icons.save,
                    ),
                  ),
                )
              else
                SizedBox.shrink(),

              //host url
              Card(
                child: TTextField(
                  controller: appHostUrlController,
                  label: Text('App Host Url'),
                  onChanged: (value) {
                    setState(() {
                      isChanged = true;
                    });
                  },
                ),
              ),
              ForwardProxyTTextField(
                controller: forwardProxyController,
                onChanged: (value) {
                  setState(() {
                    isChanged = true;
                  });
                },
              ),
            ],
          ),
        ),
        floatingActionButton: isChanged
            ? FloatingActionButton(
                onPressed: () {
                  _saveConfig();
                },
                child: const Icon(Icons.save),
              )
            : null,
      ),
    );
  }
}
