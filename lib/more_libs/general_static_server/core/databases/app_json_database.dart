import 'package:cm_app/more_libs/general_static_server/services/server_path_services.dart';

import '../index.dart';

class AppJsonDatabase extends JsonDatabase<App> {
  AppJsonDatabase()
    : super(root: ServerPathServices.getLocal.getRoot(name: 'app.db.json'));

  @override
  String getId(App value) {
    return value.id;
  }

  @override
  App from(Map<String, dynamic> map) {
    return App.fromMap(map);
  }

  @override
  Map<String, dynamic> to(App value) {
    return value.toMap();
  }
}
