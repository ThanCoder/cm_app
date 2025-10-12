import 'package:cm_app/app/constants.dart';
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
    // check internet
    bool isInternetConnected = await ThanPkg.platform.isInternetConnected();
    if (!isInternetConnected) {
      throw Exception('Your Are Offline.Please Turn On Internet!');
    }
    TClientResponse res = await _client.get(url);
    if (res.statusCode != 200) {
      // rety ပြန်လုပ်တာ
      res = await _client.get(url.replaceAll(api1HostName, api2HostName));
    }
    return res.data.toString();

    // String result = '';
    // try {

    // } catch (e) {
    //   debugPrint('[ClientServices:getUrlContent]: ${e.toString()}');
    // }
    // return result;
  }
}
