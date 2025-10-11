import 'package:cm_app/app/core/database/movie_bookmark_database.dart';

class MovieBookmarkServices {
  static MovieBookmarkDatabase? _cache;

  static MovieBookmarkDatabase get getDatabase {
    _cache ??= MovieBookmarkDatabase();
    return _cache!;
  }

  static Future<bool> isExists(String title) async {
    final list = await getDatabase.getAll();
    final index = list.indexWhere((e) => e.title == title);
    return index != -1;
  }
}
