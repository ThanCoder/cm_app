import 'package:cm_app/more_libs/general_static_server/general_server.dart';

class ServerPathServices {
  final String root;
  ServerPathServices({required this.root});

  static void init() {
    _cache['local'] = ServerPathServices(
      root: GeneralServer.instance.getLocalServerPath(),
    );
    _cache['api'] = ServerPathServices(
      root: GeneralServer.instance.getApiServerUrl(),
    );
  }

  static final Map<String, ServerPathServices> _cache = {};

  static ServerPathServices get getLocal {
    if (_cache['local'] == null) {
      throw Exception('[Usage]: `ServerPathServices.init()`');
    }

    return _cache['local']!;
  }

  static ServerPathServices get getApi {
    if (_cache['api'] == null) {
      throw Exception('[Usage]: `ServerPathServices.init()`');
    }

    return _cache['api']!;
  }

  String getRoot({String? name}) {
    final name0 = name != null && name.isNotEmpty ? '/$name' : '';
    return '$root$name0';
  }

  String getDBFiles({String? name}) {
    final name0 = name != null && name.isNotEmpty ? '/$name' : '';
    return '$root/db_files$name0';
  }

  String getFiles({String? name}) {
    final name0 = name != null && name.isNotEmpty ? '/$name' : '';
    return '$root/files$name0';
  }

  String tutorialFiles({String? name}) {
    final name0 = name != null && name.isNotEmpty ? '/$name' : '';
    return '$root/tutorial_files$name0';
  }
}
