import 'package:cm_app/app/core/models/movie_cast.dart';
import 'package:cm_app/app/core/models/movie_download_link.dart';
import 'package:than_pkg/services/index.dart';

class MovieDetail {
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
  final List<MovieDownloadLink> downloadList;
  final List<MovieCast> castList;
  MovieDetail({
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
    required this.downloadList,
    required this.castList,
  });

  factory MovieDetail.fromMap(Map<String, dynamic> map) {
    List<dynamic> dList = map['movie_download_links'] ?? [];
    List<dynamic> castList = map['casts'] ?? [];
    return MovieDetail(
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
      downloadList: dList.map((map) => MovieDownloadLink.fromMap(map)).toList(),
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
      'movie_download_links': downloadList.map((e) => e.toMap()).toList(),
      'casts': castList.map((e) => e.toMap()).toList(),
    };
  }
}
