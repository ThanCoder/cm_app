import 'package:cm_app/app/core/database/movie_recent_database.dart';
import 'package:cm_app/app/core/models/movie.dart';

class MovieRecentServices {
  static MovieRecentDatabase? _cache;

  static MovieRecentDatabase get getDatabase {
    _cache ??= MovieRecentDatabase();
    return _cache!;
  }

  static Future<bool> isExists(String title) async {
    final list = await getDatabase.getAll();
    final index = list.indexWhere((e) => e.title == title);
    return index != -1;
  }

  static Future<void> addRecent(Movie movie) async {
    final list = await getDatabase.getAll();
    final index = list.indexWhere((e) => e.id == movie.id);
    if (index != -1) {
      list.removeAt(index);
    }
    list.insert(0, movie);
    await getDatabase.save(list);
  }
}
