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
  });

  factory MovieDetail.fromMap(Map<String, dynamic> map) {
    List<dynamic> dList = map['movie_download_links'] ?? [];
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
    );
  }
}
