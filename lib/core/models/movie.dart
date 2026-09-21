enum MediaType {
  movie,
  tvShow;

  static MediaType fromValue(String value) {
    return switch (value) {
      'movie' => MediaType.movie,
      'tv-show' => MediaType.tvShow,
      _ => throw FormatException('Unknown media type: $value'),
    };
  }
}

final class MediaCategory {
  const MediaCategory({
    required this.id,
    required this.tmdbGenreId,
    required this.name,
  });

  factory MediaCategory.fromMap(Map<String, dynamic> map) {
    return MediaCategory(
      id: map['id'] as int,
      tmdbGenreId: map['tmdb_genre_id']?.toString() ?? '',
      name: map['name'] as String? ?? '',
    );
  }

  final int id;
  final String tmdbGenreId;
  final String name;
}

final class MediaItem {
  const MediaItem({
    required this.id,
    required this.title,
    required this.slug,
    required this.year,
    required this.poster,
    required this.rating,
    required this.resolution,
    required this.isAdult,
    required this.categories,
    required this.type,
    required this.homietv,
    required this.ysflix,
  });

  factory MediaItem.fromMap(Map<String, dynamic> map) {
    return MediaItem(
      id: map['id'] as int,
      title: map['title'] as String? ?? '',
      slug: map['slug'] as String? ?? '',
      year: map['year'] as String? ?? '',
      poster: map['poster'] as String? ?? '',
      rating: map['rating'] as String? ?? '',
      resolution: map['resolution'] as String?,
      isAdult: map['is_adult'] as String? ?? '0',
      categories: (map['categories'] as List? ?? const [])
          .map(
            (e) => MediaCategory.fromMap(Map<String, dynamic>.from(e as Map)),
          )
          .toList(),
      type: MediaType.fromValue(map['type'] as String? ?? ''),
      homietv: map['homietv'] as int? ?? 0,
      ysflix: map['ysflix'] as int? ?? 0,
    );
  }

  final int id;
  final String title;
  final String slug;
  final String year;
  final String poster;
  final String rating;
  final String? resolution;
  final String isAdult;
  final List<MediaCategory> categories;
  final MediaType type;
  final int homietv;
  final int ysflix;
}
