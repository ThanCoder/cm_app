import 'package:than_pkg/services/index.dart';

class TagAndGenres {
  final int id;
  final String name;
  final int moviesCount;
  TagAndGenres({
    required this.id,
    required this.name,
    required this.moviesCount,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'movies_count': moviesCount,
    };
  }

  factory TagAndGenres.fromMap(Map<String, dynamic> map) {
    int count = map.getInt(['movies_count']);
    if (map['movies_count'] == null) {
      count = map.getInt(['tv_shows_count']);
    }

    return TagAndGenres(
      id: map.getInt(['id']),
      name: map.getString(['name']),
      moviesCount: count,
    );
  }

  @override
  String toString() {
    return name;
  }
}
