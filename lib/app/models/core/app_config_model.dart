// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cm_app/app/constants.dart';

class AppConfigModel {
  bool isUseCustomPath;
  String customPath;
  bool isDarkTheme;
  //proxy
  String proxyAddress;
  String proxyPort;
  bool isUseProxyServer;
  String hostUrl;
  String forwardProxy;

  AppConfigModel({
    this.isUseCustomPath = false,
    this.customPath = '',
    this.isDarkTheme = false,
    this.isUseProxyServer = false,
    this.proxyAddress = '',
    this.proxyPort = '8080',
    this.hostUrl = appHostUrl,
    this.forwardProxy = appForwardProxyHostUrl,
  });

  factory AppConfigModel.fromJson(Map<String, dynamic> map) {
    return AppConfigModel(
      isUseCustomPath: map['is_use_custom_path'] ?? '',
      customPath: map['custom_path'] ?? '',
      isDarkTheme: map['is_dark_theme'] ?? false,
      //proxy
      proxyAddress: map['proxy_address'] ?? '',
      proxyPort: map['proxy_port'] ?? '8080',
      isUseProxyServer: map['is_use_proxy_server'] ?? false,
      hostUrl: map['host_url'] ?? appHostUrl,
      forwardProxy: map['forward_proxy'] ?? appForwardProxyHostUrl,
    );
  }
  Map<String, dynamic> toJson() => {
        'is_use_custom_path': isUseCustomPath,
        'custom_path': customPath,
        'is_dark_theme': isDarkTheme,
        'proxy_address': proxyAddress,
        'proxy_port': proxyPort,
        'is_use_proxy_server': isUseProxyServer,
        'host_url': hostUrl,
        'forward_proxy': forwardProxy,
      };
}
