import 'package:flutter/material.dart';
import 'package:t_client/t_client.dart';

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
      final res = await _client.get(url);
      result = res.data.toString();
    } catch (e) {
      debugPrint('[ClientServices:getUrlContent]: ${e.toString()}');
    }
    return result;
  }
}
