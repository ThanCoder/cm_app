import 'dart:io';

import 'package:cm_app/my_libs/setting_v2.2.0/core/path_util.dart';
import 'package:cm_app/my_libs/setting_v2.2.0/setting.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';

class DioServices {
  static final DioServices instance = DioServices._();
  DioServices._();
  factory DioServices() => instance;

  final _dio = Dio(
    BaseOptions(
      sendTimeout: Duration(seconds: 8),
      connectTimeout: Duration(seconds: 8),
      receiveTimeout: Duration(seconds: 8),
    ),
  );

  Future<String> getHtml(String url) async {
    final res = await getDio().get(getForwardProxyUrl(url));
    return res.data.toString();
  }

  String getForwardProxyUrl(String url) {
    return Setting.getForwardProxyUrl(url);
  }

  Future<String> getCacheHtml({
    required String url,
    required String cacheName,
    bool isOverride = false,
  }) async {
    if (url.isEmpty) return '';
    final savePath = '${PathUtil.getCachePath()}/$cacheName.html';
    final cacheFile = File(savePath);
    if (!isOverride && await cacheFile.exists()) {
      return await cacheFile.readAsString();
    }
    //မရှိရင်
    final html = await getHtml(url);
    await cacheFile.writeAsString(html);
    return html;
  }

  Future<int?> getContentSize(String url) async {
    try {
      var response = await getDio().head(url);
      return int.tryParse(response.headers.value('content-length') ?? '0');
    } catch (e) {
      return null;
    }
  }

  static void removeCache(String cacheName) {
    final file = File('${PathUtil.getCachePath()}/$cacheName.html');
    if (file.existsSync()) {
      file.deleteSync();
    }
  }

  Dio getDio() {
    if (Setting.getAppConfig.isUseProxy) {
      _dio.httpClientAdapter = IOHttpClientAdapter(
        createHttpClient: () {
          final client = HttpClient();
          // Config the client.
          client.findProxy = (uri) {
            // Forward all request to proxy "localhost:8888".
            // Be aware, the proxy should went through you running device,
            // not the host platform.
            return 'PROXY ${Setting.getAppConfig.proxyUrl}';
          };
          // You can also create a new HttpClient for Dio instead of returning,
          // but a client must being returned here.
          return client;
        },
      );
    }
    return _dio;
  }
}
