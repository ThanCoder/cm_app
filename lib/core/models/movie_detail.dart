final class MovieDetail {
  const MovieDetail({
    required this.id,
    required this.title,
    required this.slug,
    required this.year,
    required this.poster,
    required this.overview,
    required this.originalTitle,
    required this.tmdbId,
    required this.imdbId,
    required this.releaseDate,
    required this.runtime,
    required this.rating,
    required this.voteCount,
    required this.backdropPath,
    required this.directors,
    required this.tagline,
    required this.casts,
    required this.categories,
    required this.tags,
    required this.resolution,
    required this.views,
    required this.isAdult,
    required this.type,
    required this.homieTv,
    required this.ysflix,
    required this.isBookmark,
    required this.bookmarkId,
    required this.shareableLink,
    required this.movieDownloadLinks,
  });

  factory MovieDetail.fromMap(Map<String, dynamic> map) {
    return MovieDetail(
      id: map['id'] as int,
      title: map['title'] as String? ?? '',
      slug: map['slug'] as String? ?? '',
      year: map['year'] as String? ?? '',
      poster: map['poster'] as String? ?? '',
      overview: map['overview'] as String? ?? '',
      originalTitle: map['original_title'] as String? ?? '',
      tmdbId: map['tmdb_id'] as String? ?? '',
      imdbId: map['imdb_id'] as String? ?? '',
      releaseDate: map['release_date'] as String? ?? '',
      runtime: map['runtime'] as String? ?? '',
      rating: map['rating'] as String? ?? '',
      voteCount: map['vote_count'] as String? ?? '',
      backdropPath: map['backdrop_path'] as String? ?? '',
      directors: (map['directors'] as List? ?? const [])
          .map((e) => e.toString())
          .toList(),
      tagline: map['tagline'] as String? ?? '',
      casts: (map['casts'] as List? ?? const [])
          .map((e) => MovieCast.fromMap(Map<String, dynamic>.from(e as Map)))
          .toList(),
      categories: (map['categories'] as List? ?? const [])
          .map(
            (e) => MovieCategory.fromMap(Map<String, dynamic>.from(e as Map)),
          )
          .toList(),
      tags: (map['tags'] as List? ?? const [])
          .map((e) => e.toString())
          .toList(),
      resolution: map['resolution'] as String?,
      views: map['views'] as int? ?? 0,
      isAdult: map['is_adult'] as String? ?? '0',
      type: map['type'] as String? ?? '',
      homieTv: map['homietv'] as int? ?? 0,
      ysflix: map['ysflix'] as int? ?? 0,
      isBookmark: map['is_bookmark'] as String?,
      bookmarkId: map['bookmark_id'] as int? ?? 0,
      shareableLink: map['shareable_link'] as String?,
      movieDownloadLinks: (map['movie_download_links'] as List? ?? const [])
          .map(
            (e) =>
                MovieDownloadLink.fromMap(Map<String, dynamic>.from(e as Map)),
          )
          .toList(),
    );
  }

  final int id;
  final String title;
  final String slug;
  final String year;
  final String poster;
  final String overview;
  final String originalTitle;
  final String tmdbId;
  final String imdbId;
  final String releaseDate;
  final String runtime;
  final String rating;
  final String voteCount;
  final String backdropPath;
  final List<String> directors;
  final String tagline;
  final List<MovieCast> casts;
  final List<MovieCategory> categories;
  final List<String> tags;
  final String? resolution;
  final int views;
  final String isAdult;
  final String type;
  final int homieTv;
  final int ysflix;
  final String? isBookmark;
  final int bookmarkId;
  final String? shareableLink;
  final List<MovieDownloadLink> movieDownloadLinks;

  List<String> get genres {
    return categories.map((e) => e.name).toList();
  }

  String get durationText {
    final minutes = int.tryParse(runtime);

    if (minutes == null) {
      return runtime;
    }

    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;

    if (hours == 0) {
      return '${remainingMinutes}m';
    }

    if (remainingMinutes == 0) {
      return '${hours}h';
    }

    return '${hours}h ${remainingMinutes}m';
  }

  double get ratingValue {
    return double.tryParse(rating) ?? 0;
  }

  bool get bookmarked {
    return isBookmark != null;
  }
}

final class MovieCast {
  const MovieCast({required this.name, required this.profilePath});

  factory MovieCast.fromMap(Map<String, dynamic> map) {
    return MovieCast(
      name: map['name'] as String? ?? '',
      profilePath: map['profile_path'] as String?,
    );
  }

  final String name;
  final String? profilePath;
}

final class MovieCategory {
  const MovieCategory({
    required this.id,
    required this.tmdbGenreId,
    required this.name,
  });

  factory MovieCategory.fromMap(Map<String, dynamic> map) {
    return MovieCategory(
      id: map['id'] as int,
      tmdbGenreId: map['tmdb_genre_id']?.toString() ?? '',
      name: map['name'] as String? ?? '',
    );
  }

  final int id;
  final String tmdbGenreId;
  final String name;
}

final class MovieDownloadLink {
  const MovieDownloadLink({
    required this.id,
    required this.movieId,
    required this.serverNameId,
    required this.serverName,
    required this.url,
    required this.size,
    required this.qualityId,
    required this.quality,
    required this.resolutionId,
    required this.resolution,
    required this.viewable,
    required this.streamId,
  });

  factory MovieDownloadLink.fromMap(Map<String, dynamic> map) {
    return MovieDownloadLink(
      id: map['id'] as int,
      movieId: map['movie_id']?.toString() ?? '',
      serverNameId: map['server_name_id']?.toString() ?? '',
      serverName: (map['server_name'] as String? ?? '').trim(),
      url: map['url'] as String? ?? '',
      size: map['size'] as String? ?? '',
      qualityId: map['quality_id']?.toString() ?? '',
      quality: map['quality'] as String? ?? '',
      resolutionId: map['resolution_id']?.toString() ?? '',
      resolution: map['resolution'] as String? ?? '',
      viewable: map['viewable'] as String? ?? '',
      streamId: map['stream_id']?.toString(),
    );
  }

  final int id;
  final String movieId;
  final String serverNameId;
  final String serverName;
  final String url;
  final String size;
  final String qualityId;
  final String quality;
  final String resolutionId;
  final String resolution;
  final String viewable;
  final String? streamId;
}
