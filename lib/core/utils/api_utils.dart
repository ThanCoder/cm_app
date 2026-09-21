import 'package:cm_app/core/types/proxy_type.dart';
import 'package:cm_app/core/utils/app_util.dart';
import 'package:cm_app/keys.dart';

class ApiUtils {
  static ProxyType get currentProxyType {
    final cf = AppUtil.instance.config;
    return ProxyType.fromValue(cf.getString(appProxyTypeKey));
  }

  static String get currentApiUrl {
    final cf = AppUtil.instance.config;
    return cf.getString(appApiUrlKey, hostUrl);
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
}
