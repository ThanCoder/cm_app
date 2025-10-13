import 'package:cm_app/app/core/models/movie_cast.dart';
import 'package:cm_app/app/core/models/season.dart';
import 'package:than_pkg/services/index.dart';

class SeriesDetail {
  final String id;
  final String title;
  final String slug;
  final String year;
  final String poster;
  final String overview;
  final String originalTitle;
  final String rating;
  final String runtime;
  final bool isAdult;
  final List<Season> seasons;
  final List<MovieCast> castList;
  SeriesDetail({
    required this.id,
    required this.title,
    required this.slug,
    required this.year,
    required this.poster,
    required this.overview,
    required this.originalTitle,
    required this.rating,
    required this.runtime,
    required this.isAdult,
    required this.seasons,
    required this.castList,
  });

  factory SeriesDetail.fromMap(Map<String, dynamic> map) {
    List<dynamic> dList = map['seasons'] ?? [];
    List<dynamic> castList = map['casts'] ?? [];
    return SeriesDetail(
      id: map.getString(['id']),
      title: map.getString(['title']),
      slug: map.getString(['slug']),
      year: map.getString(['year']),
      poster: map.getString(['poster']),
      overview: map.getString(['overview']),
      originalTitle: map.getString(['original_title']),
      rating: map.getString(['rating']),
      runtime: map.getString(['runtime']),
      isAdult: map.getInt(['is_adult']) != 0,
      seasons: dList.map((map) => Season.fromMap(map)).toList(),
      castList: castList.map((map) => MovieCast.fromMap(map)).toList(),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'slug': slug,
      'year': year,
      'poster': poster,
      'overview': overview,
      'original_title': originalTitle,
      'rating': rating,
      'runtime': runtime,
      'isAdult': isAdult,
      'seasons': seasons.map((e) => e.toMap()).toList(),
      'casts': castList.map((e) => e.toMap()).toList(),
    };
  }
}
