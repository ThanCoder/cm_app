import 'dart:io';

import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_pkg/than_pkg.dart';

import 'setting.dart';
import 'core/android_app_services.dart';
import 'app_config.dart';
import 'core/app_notifier.dart';
import 'core/theme_component.dart';

class AppSettingScreen extends StatefulWidget {
  const AppSettingScreen({super.key});

  @override
  State<AppSettingScreen> createState() => _AppSettingScreenState();
}

class _AppSettingScreenState extends State<AppSettingScreen> {
  @override
  void initState() {
    init();
    super.initState();
  }

  bool isChanged = false;
  bool isCustomPathTextControllerTextSelected = false;
  late AppConfig config;
  final customPathTextController = TextEditingController();
  final forwardProxyController = TextEditingController();
  final customServerPathController = TextEditingController();
  final customProxyController = TextEditingController();

  void init() async {
    customPathTextController.text =
        '${Setting.appExternalPath}/.${Setting.instance.appName}';
    config = appConfigNotifier.value;
    forwardProxyController.text = config.forwardProxyUrl;
    if (config.customPath.isNotEmpty) {
      customPathTextController.text = config.customPath;
    }
    customProxyController.text = config.proxyUrl;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !isChanged,
      onPopInvokedWithResult: (didPop, result) {
        _onBackpress();
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Setting')),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // theme
              ThemeComponent(),
              //custom path
              _getCustomPathWidget(),
              // custom
              _getCustomProxyWidget(),
              //proxy server
              _getForwardProxyWidget(),
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

  Widget _getCustomPathWidget() {
    return Column(
      children: [
        TListTileWithDesc(
          title: "Config Custom Path",
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
        config.isUseCustomPath
            ? TListTileWithDescWidget(
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
                  icon: const Icon(Icons.save),
                ),
              )
            : SizedBox.shrink(),
      ],
    );
  }

  Widget _getForwardProxyWidget() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 5,
          children: [
            SwitchListTile.adaptive(
              title: Text('Use Foward Proxy'),
              value: config.isUseForwardProxy,
              onChanged: (value) {
                if (value) {
                  config.isUseProxy = false;
                }
                setState(() {
                  config.isUseForwardProxy = value;
                  isChanged = true;
                });
              },
            ),
            !config.isUseForwardProxy
                ? SizedBox.shrink()
                : TTextField(
                    label: Text('Forward Proxy'),
                    controller: forwardProxyController,
                    maxLines: 1,
                    isSelectedAll: true,
                    onChanged: (value) {
                      config.forwardProxyUrl = value;
                      if (!isChanged) {
                        setState(() {
                          isChanged = true;
                        });
                      }
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget _getCustomProxyWidget() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 5,
          children: [
            SwitchListTile.adaptive(
              title: Text('Use Custom Proxy'),
              value: config.isUseProxy,
              onChanged: (value) {
                if (value) {
                  config.isUseForwardProxy = false;
                }
                setState(() {
                  config.isUseProxy = value;
                  isChanged = true;
                });
              },
            ),
            !config.isUseProxy
                ? SizedBox.shrink()
                : TTextField(
                    label: Text('Custom Proxy'),
                    controller: customProxyController,
                    maxLines: 1,
                    isSelectedAll: true,
                    onChanged: (value) {
                      config.proxyUrl = value;
                      if (!isChanged) {
                        setState(() {
                          isChanged = true;
                        });
                      }
                    },
                  ),
          ],
        ),
      ),
    );
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
      final oldPath = config.customPath;

      //set custom path
      config.customPath = customPathTextController.text;
      //save
      await config.save();

      if (!mounted) return;
      setState(() {
        isChanged = false;
      });
      Setting.instance.onSettingSaved?.call(context, 'Config Saved');
      // custome path ပြောင်လဲလား စစ်ဆေးမယ်
      if (oldPath != customPathTextController.text) {
        // app refresh
        Setting.restartApp(context);
      }
    } catch (e) {
      Setting.showDebugLog(e.toString(), tag: 'AppSettingScreen:_saveConfig');
    }
  }

  void _onBackpress() {
    if (!isChanged) {
      return;
    }
    showDialog(
      context: context,
      builder: (context) => TConfirmDialog(
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
}
