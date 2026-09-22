import 'dart:convert';

import 'package:cm_app/core/result_t.dart';
import 'package:cm_app/core/types/proxy_type.dart';
import 'package:cm_app/core/utils/app_util.dart';
import 'package:cm_app/keys.dart';
import 'package:t_client/t_client.dart';

class ApiUtils {
  static ProxyType get currentProxyType {
    final cf = AppUtil.instance.config;
    return ProxyType.fromValue(cf.getString(appProxyTypeKey));
  }

  static String currentApiUrl({bool useYsflix = false}) {
    // final cf = AppUtil.instance.config;
    // return cf.getString(appApiUrlKey, hostUrl);
    String host = api1HostName;
    if (useYsflix) {
      host = api2HostName;
    }
    return 'https://www.$host.com';
  }

  static String getAutoForwardProxyUrl(String url) {
    final cf = AppUtil.instance.config;
    final type = ProxyType.fromValue(cf.getString(appProxyTypeKey));
    if (type == .forwardProxy) {
      final forwardProxy = cf.getString(appForwardProxyUrlKey);
      if (forwardProxy.isNotEmpty) {
        return '$forwardProxy?url=$url';
      }
    }
    return url;
  }

  static Future<Result<dynamic, String>> getApiContent(String url) async {
    final client = TClient();
    if (ApiUtils.currentProxyType == .proxy) {
      final cf = AppUtil.instance.config;
      final proxy = cf.getString(appProxyUrlKey);
      client.setProxy((uri) => 'PROXY $proxy');
    }
    final res = await client.get(url);
    if (res.isErr) {
      return Err(res.unwrapError());
    }
    try {
      return Ok(jsonDecode(res.unwrap().body));
    } catch (e) {
      client.close();
      return Err(e.toString());
    }
  }
}
