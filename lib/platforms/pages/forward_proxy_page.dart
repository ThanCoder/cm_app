// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cm_app/core/types/proxy_type.dart';
import 'package:cm_app/platforms/components/forms/input_text.dart';
import 'package:flutter/material.dart';
import 'package:t_client/t_client.dart';
import 'package:t_widgets/t_widgets.dart';

import 'package:cm_app/core/utils/app_util.dart';
import 'package:cm_app/keys.dart';
import 'package:cm_app/platforms/components/dialog/error_alert_dialog.dart';

class ForwardProxyItem({
  required final String title,
  required final String url,
}) {
  Map<String, dynamic> toMap() {
    return <String, dynamic>{'title': title, 'url': url};
  }

  factory ForwardProxyItem.fromMap(Map<String, dynamic> map) {
    return ForwardProxyItem(
      title: map['title'] as String,
      url: map['url'] as String,
    );
  }
}

class ForwardProxyPageListTile extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final col = Theme.of(context).colorScheme;

    return ListTile(
      tileColor: col.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: .circular(15)),
      title: Text('Forward Proxy'),
      leading: Icon(Icons.api_outlined),
      trailing: Icon(
        Icons.arrow_forward_ios_outlined,
        color: col.onSurfaceVariant,
      ),
      onTap: () {
        context.pushMaterialPageRoute(builder: (mainCtx) => ForwardProxyPage());
      },
    );
  }
}

class ForwardProxyPage extends StatefulWidget {
  const new({super.key});

  @override
  State<ForwardProxyPage> createState() => _ForwardProxyPageState();
}

class _ForwardProxyPageState extends State<ForwardProxyPage> {
  final cf = AppUtil.instance.config;

  ColorScheme get col => Theme.of(context).colorScheme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Proxy')),
      body: _body,
    );
  }

  Widget get _body {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: .symmetric(vertical: 10, horizontal: 5),
            decoration: BoxDecoration(
              color: col.surfaceContainer,
              borderRadius: .circular(15),
            ),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  'Proxy Type',
                  style: TextStyle(fontSize: 20, fontWeight: .w700),
                ),
                SizedBox(height: 10),
                StreamBuilder(
                  stream: cf.stream.put.where((e) => e.key == appProxyTypeKey),
                  builder: (context, asyncSnapshot) {
                    final val = ProxyType.fromValue(
                      cf.getString(appProxyTypeKey),
                    );
                    return RadioGroup<ProxyType>(
                      groupValue: val,
                      onChanged: (value) {
                        cf.putAndWriteAll(appProxyTypeKey, value?.name);
                      },
                      child: Column(
                        children: ProxyType.values
                            .map(
                              (e) => Material(
                                child: RadioListTile.adaptive(
                                  tileColor: col.surfaceContainer,
                                  value: e,
                                  title: Text(e.lable),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          _result,
        ],
      ),
    );
  }

  Widget get _result {
    return StreamBuilder(
      stream: cf.stream.put.where((e) => e.key == appProxyTypeKey),
      builder: (context, snapshot) {
        final val = ProxyType.fromValue(cf.getString(appProxyTypeKey));
        if (val == .forwardProxy) {
          return _ForwardProxyChooserPage();
        }
        if (val == .proxy) {
          return _ProxyEditUrlPage();
        }
        return SizedBox.shrink();
      },
    );
  }
}

class _ForwardProxyChooserPage extends StatefulWidget {
  const new();

  @override
  State<_ForwardProxyChooserPage> createState() =>
      _ForwardProxyChooserPageState();
}

class _ForwardProxyChooserPageState extends State<_ForwardProxyChooserPage> {
  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  void dispose() {
    client.close();
    super.dispose();
  }

  final client = TClient();

  final cf = AppUtil.instance.config;
  bool isLoading = false;
  List<ForwardProxyItem> items = [];

  Future<void> init() async {
    setState(() {
      isLoading = true;
    });
    final res = await client.get(
      '$forwardProxyApiUrl?v=${DateTime.now().millisecond}',
    );
    if (!mounted) return;
    if (res.isErr) {
      setState(() {
        isLoading = false;
      });
      showErrorDialog(context, res.unwrapError());
      return;
    }
    setState(() {
      isLoading = false;
    });
    try {
      List<dynamic> list = jsonDecode(res.unwrap().body);
      items = list.map((e) => ForwardProxyItem.fromMap(e)).toList();
      setState(() {});
    } catch (e) {
      showErrorDialog(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: TLoaderRandom());
    }
    return StreamBuilder(
      stream: cf.stream.put.where((e) => e.key == appForwardProxyUrlKey),
      builder: (context, asyncSnapshot) {
        final url = cf.getString(appForwardProxyUrlKey);
        return RadioGroup<String>(
          groupValue: url,
          onChanged: (value) {
            cf.putAndWriteAll(appForwardProxyUrlKey, value);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  'Forward Proxy Api',
                  style: TextStyle(fontSize: 20, fontWeight: .w700),
                ),
                SizedBox(height: 10),
                ...items.map(
                  (e) => RadioListTile.adaptive(
                    value: e.url,
                    title: Text(e.title),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ProxyEditUrlPage extends StatefulWidget {
  const new();

  @override
  State<_ProxyEditUrlPage> createState() => _ProxyEditUrlPageState();
}

class _ProxyEditUrlPageState extends State<_ProxyEditUrlPage> {
  @override
  void initState() {
    controller.text = url;
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  final cf = AppUtil.instance.config;
  final controller = TextEditingController();
  // http://10.187.230.241:8080
  String get url => cf.getString(appProxyUrlKey);

  @override
  Widget build(BuildContext context) {
    final col = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          InputText(
            controller: controller,
            maxLines: 1,
            label: Text('Custom Proxy Url'),
            hint: Text(
              'http[s]://[host]:[port]',
              style: TextStyle(
                color: col.onSurfaceVariant.withValues(alpha: .45),
              ),
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: .end,
            children: [
              FilledButton(
                onPressed: () {
                  cf.putAndWriteAll(appProxyUrlKey, controller.text);
                  context.pop();
                },
                child: Text('Save Url'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
