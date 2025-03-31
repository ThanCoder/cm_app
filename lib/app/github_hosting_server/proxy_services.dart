import 'dart:convert';

import '../services/core/index.dart';
import 'hosting_constants.dart';

class ProxyServices {
  static Future<List<String>> getForwardProxyList() async {
    final res =
        await DioServices.instance.getDio.get(hostingForwardProxyListUrl);
    final data = res.data;
    if (data.isEmpty) return [];
    return List<String>.from(jsonDecode(data));
  }

  static Future<List<String>> getBrowserProxyList() async {
    final res =
        await DioServices.instance.getDio.get(hostingBrowserProxyListUrl);
    final data = res.data;
    if (data.isEmpty) return [];
    return List<String>.from(jsonDecode(data));
  }
}
