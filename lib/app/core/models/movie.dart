import 'package:cm_app/app/services/movie_services.dart';
import 'package:than_pkg/services/t_map.dart';

enum MovieTypes {
  movie,
  tvShow;

  static MovieTypes getName(String name) {
    if (name == 'tv-show') {
      return tvShow;
    }
    return movie;
  }
}

class Movie {
  final String id;
  final String url;
  final String title;
  final String slug;
  final String year;
  final String poster;
  final String rating;
  final List<Categories> categories;
  final MovieTypes type;
  final bool isAdult;
  Movie({
    required this.id,
    required this.url,
    required this.title,
    required this.slug,
    required this.year,
    required this.poster,
    required this.rating,
    required this.categories,
    required this.type,
    required this.isAdult,
  });

  factory Movie.fromMap(Map<String, dynamic> map) {
    final typeStr = map.getString(['type']);
    final movieType = MovieTypes.getName(typeStr);
    final isAdultInt = map.getInt(['is_adult']);
    List<dynamic> cat = map['categories'] ?? [];
    String url = '${MovieServices.apiMovieUrl}/${map.getString(['slug'])}';
    if (movieType == MovieTypes.tvShow) {
      url = '${MovieServices.apiTvShowUrl}/${map.getString(['slug'])}';
    }

    return Movie(
      id: map.getString(['id']),
      title: map.getString(['title']),
      slug: map.getString(['slug']),
      year: map.getString(['year']),
      poster: map.getString(['poster']),
      rating: map.getString(['rating']),
      categories: cat.map((e) => Categories.fromMap(e)).toList(),
      type: movieType,
      isAdult: isAdultInt != 0,
      url: url,
    );
  }

  @override
  String toString() {
    return title;
  }
}

/* 
 "id": 5,
  "tmdb_genre_id": 80,
  "name": "Crime"
*/
class Categories {
  final String id;
  final String name;
  final String tmdbGenreId;
  Categories({required this.id, required this.name, required this.tmdbGenreId});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'tmdb_genre_id': tmdbGenreId,
    };
  }

  factory Categories.fromMap(Map<String, dynamic> map) {
    return Categories(
      id: map.getString(['id']),
      name: map.getString(['name']),
      tmdbGenreId: map.getString(['tmdb_genre_id']),
    );
  }
}
