enum MediaType { movie, tvShow }

final class MediaCategory {
  const MediaCategory({
    required this.id,
    required this.tmdbGenreId,
    required this.name,
  });

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
