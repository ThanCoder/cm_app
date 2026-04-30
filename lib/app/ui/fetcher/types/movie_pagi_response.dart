class MoviePagiResponse {
  final List<MovieItem> movies;
  final List<Pagination> pagiList;

  const MoviePagiResponse({required this.movies, required this.pagiList});
}

class MovieItem {
  final String title;
  final String url;
  final String coverUrl;

  const MovieItem({
    required this.title,
    required this.url,
    required this.coverUrl,
  });
  @override
  String toString() {
    return 'Title: $title - Url: $url - CoverUrl: $coverUrl\n';
  }
}

class Pagination {
  final String title;
  final String url;

  const Pagination({required this.title, required this.url});
}
