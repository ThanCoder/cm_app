import 'package:than_pkg/than_pkg.dart';

class MovieYear {
  final String year;
  final int moviesCount;
  MovieYear({required this.year, required this.moviesCount});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'year': year, 'movies_count': moviesCount};
  }

  factory MovieYear.fromMap(Map<String, dynamic> map) {
    return MovieYear(
      year: map.getString(['year']),
      moviesCount: map.getInt(['movies_count']),
    );
  }
}
