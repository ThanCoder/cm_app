import 'package:than_pkg/services/index.dart';

class MovieCast {
  final String name;
  final String profilePath;
  MovieCast({required this.name, required this.profilePath});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'name': name, 'profile_path': profilePath};
  }

  factory MovieCast.fromMap(Map<String, dynamic> map) {
    return MovieCast(
      name: map.getString(['name']),
      profilePath: map.getString(['profile_path']),
    );
  }
}
