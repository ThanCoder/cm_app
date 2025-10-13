import 'package:cm_app/app/core/interfaces/json_database.dart';
import 'package:cm_app/app/core/models/movie.dart';
import 'package:cm_app/more_libs/setting_v2.8.3/core/path_util.dart';

class MovieRecentDatabase extends JsonDatabase<Movie> {
  MovieRecentDatabase()
    : super(root: PathUtil.getCachePath(name: 'movie.recent.db.json'));

  @override
  Movie fromMap(Map<String, dynamic> map) {
    return Movie.fromMap(map);
  }

  @override
  String getId(Movie value) {
    return value.id;
  }

  @override
  Map<String, dynamic> toMap(Movie value) {
    return value.toMap();
  }
}
