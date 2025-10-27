import 'package:cm_app/more_libs/general_static_server/core/index.dart';
import 'package:cm_app/more_libs/general_static_server/core/models/tutorial.dart';
import 'package:cm_app/more_libs/general_static_server/services/server_path_services.dart';

class TutorialLocalDatabase extends JsonDatabase<Tutorial> {
  TutorialLocalDatabase({super.isUseCacheList})
    : super(
        root: ServerPathServices.getLocal.getRoot(name: 'tutorial.db.json'),
      );

  @override
  Tutorial from(Map<String, dynamic> map) {
    return Tutorial.fromMap(map);
  }

  @override
  String getId(Tutorial value) {
    return value.id;
  }

  @override
  Map<String, dynamic> to(Tutorial value) {
    return value.toMap();
  }
}
