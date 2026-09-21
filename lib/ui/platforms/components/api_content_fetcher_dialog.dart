import 'package:cm_app/core/utils/api_utils.dart';
import 'package:cm_app/core/utils/app_util.dart';
import 'package:cm_app/keys.dart';
import 'package:flutter/material.dart';
import 'package:t_client/t_client.dart';
import 'package:t_widgets/t_widgets.dart';

class ApiContentFetcherDialog extends StatefulWidget {
  const new({super.key, required this.url});
  final String url;

  @override
  State<ApiContentFetcherDialog> createState() =>
      _ApiContentFetcherDialogState();
}

class _ApiContentFetcherDialogState extends State<ApiContentFetcherDialog> {
  @override
  void initState() {
    fetch();
    super.initState();
  }

  @override
  void dispose() {
    client.close();
    super.dispose();
  }

  String? error;
  bool isLoading = false;
  final client = TClient();

  Future<void> fetch() async {
    try {
      if (ApiUtils.currentProxyType == .proxy) {
        final cf = AppUtil.instance.config;
        client.setProxy((uri) => 'PROXY: ${cf.getString(appProxyTypeKey)}');
      }
      setState(() {
        isLoading = true;
        error = null;
      });
      final res = await client.get(widget.url);
      if (!mounted) return;

      if (res.isErr) {
        error = res.unwrapError();
        setState(() {
          isLoading = false;
        });
        return;
      }
      final body = res.unwrap().body;
      context.pop<String>(body);

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      error = e.toString();
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      scrollable: true,
      content: _body,
      actions: [
        FilledButton(
          onPressed: () {
            context.pop();
          },
          child: Text('Close'),
        ),
      ],
    );
  }

  Widget get _body {
    if (isLoading) {
      return Center(
        child: Column(
          spacing: 8,
          children: [
            CircularProgressIndicator.adaptive(),
            Text(
              'Api Fetching....',
              style: TextStyle(fontSize: 20, fontWeight: .w700),
            ),
          ],
        ),
      );
    }
    if (error != null) {
      return Center(child: Text('Error: $error'));
    }
    return Text('surcess');
  }
}
