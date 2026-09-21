import 'package:cm_app/core/models/movie.dart';
import 'package:dart_core_extensions/dart_core_extensions.dart';

final class TvShowItem {
  const TvShowItem({
    required this.id,
    required this.title,
    required this.slug,
    required this.year,
    required this.poster,
    required this.rating,
    required this.resolution,
    required this.isAdult,
    required this.categories,
    required this.seasons,
    required this.type,
    required this.homietv,
    required this.ysflix,
  });

  final int id;
  final String title;
  final String slug;
  final String year;
  final String poster;
  final String rating;
  final String? resolution;
  final bool isAdult;
  final List<MediaCategory> categories;
  final int seasons;
  final MediaType type;
  final int homietv;
  final int ysflix;

  factory TvShowItem.fromJson(Map<String, dynamic> json) {
    return TvShowItem(
      id: json['id'],
      title: json['title'],
      slug: json['slug'],
      year: json['year'],
      poster: json['poster'],
      rating: json['rating'],
      resolution: json['resolution'],
      isAdult: json.getInt(['isAdult']) == 1,
      categories: (json['categories'] as List? ?? const [])
          .map(
            (e) => MediaCategory.fromMap(Map<String, dynamic>.from(e as Map)),
          )
          .toList(),
      seasons: json['seasons'],
      type: MediaType.fromValue(json['type']),
      homietv: json['homietv'],
      ysflix: json['ysflix'],
    );
  }
}
