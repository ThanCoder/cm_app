class Movie {
  final int id;
  final String title;
  final String year;
  final String rating;
  final String poster;
  final String? resolution;
  final List<String> genres;

  const Movie({
    required this.id,
    required this.title,
    required this.year,
    required this.rating,
    required this.poster,
    required this.genres,
    this.resolution,
  });
}