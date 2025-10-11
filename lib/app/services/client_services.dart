import 'package:cm_app/app/services/movie_services.dart';
import 'package:flutter/material.dart';
import 'package:t_client/t_client.dart';
import 'package:than_pkg/than_pkg.dart';

class ClientServices {
  // singleton
  static final ClientServices instance = ClientServices._();
  ClientServices._();
  factory ClientServices() => instance;

  final _client = TClient();

  TClient get getClient => _client;

  Future<String> getUrlContent(String url) async {
    String result = '';
    try {
      // check internet
      bool isInternetConnected = await ThanPkg.platform.isInternetConnected();
      if (!isInternetConnected) {
        throw Exception('Your Are Offline.Please Turn On Internet!');
      }
      TClientResponse res = await _client.get(url);
      if (res.statusCode != 200) {
        // rety ပြန်လုပ်တာ
        res = await _client.get(
          url.replaceAll(
            MovieServices.api1HostName,
            MovieServices.api2HostName,
          ),
        );
      }
      result = res.data.toString();
    } catch (e) {
      debugPrint('[ClientServices:getUrlContent]: ${e.toString()}');
    }
    return result;
  }
}
