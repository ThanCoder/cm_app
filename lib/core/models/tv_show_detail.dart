final class TvShowDetail {
  const TvShowDetail({
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
    required this.status,
    required this.type,
    required this.casts,
    required this.categories,
    required this.tags,
    required this.resolution,
    required this.views,
    required this.isAdult,
    required this.homieTv,
    required this.ysflix,
    required this.isBookmark,
    required this.bookmarkId,
    required this.shareableLink,
    required this.zipDownloadLinks,
    required this.seasons,
  });

  factory TvShowDetail.fromMap(Map<String, dynamic> map) {
    return TvShowDetail(
      id: map['id'] as int,
      title: map['title'] as String? ?? '',
      slug: map['slug'] as String? ?? '',
      year: map['year'] as String? ?? '',
      poster: map['poster'] as String? ?? '',
      overview: map['overview'] as String? ?? '',
      originalTitle: map['original_title'] as String? ?? '',
      tmdbId: map['tmdb_id']?.toString() ?? '',
      imdbId: map['imdb_id'] as String?,
      releaseDate: map['release_date'] as String? ?? '',
      runtime: map['runtime'] as String?,
      rating: map['rating'] as String? ?? '',
      voteCount: map['vote_count'] as String? ?? '',
      backdropPath: map['backdrop_path'] as String? ?? '',
      directors: (map['directors'] as List? ?? const [])
          .map((e) => e.toString())
          .toList(),
      tagline: map['tagline'] as String?,
      status: map['tvshow_status'] as String? ?? '',
      type: map['tvshow_type'] as String? ?? '',
      casts: (map['casts'] as List? ?? const [])
          .map((e) => TvShowCast.fromMap(Map<String, dynamic>.from(e as Map)))
          .toList(),
      categories: (map['categories'] as List? ?? const [])
          .map(
            (e) => TvShowCategory.fromMap(Map<String, dynamic>.from(e as Map)),
          )
          .toList(),
      tags: (map['tags'] as List? ?? const [])
          .map((e) => TvShowTag.fromMap(Map<String, dynamic>.from(e as Map)))
          .toList(),
      resolution: map['resolution'] as String?,
      views: map['views'] as int? ?? 0,
      isAdult: map['is_adult'] as String? ?? '0',
      homieTv: map['homietv'] as int? ?? 0,
      ysflix: map['ysflix'] as int? ?? 0,
      isBookmark: map['is_bookmark'] as String?,
      bookmarkId: map['bookmark_id'] as int? ?? 0,
      shareableLink: map['shareable_link'] as String?,
      zipDownloadLinks: List<dynamic>.from(
        map['zip_download_links'] as List? ?? const [],
      ),
      seasons: (map['seasons'] as List? ?? const [])
          .map((e) => TvShowSeason.fromMap(Map<String, dynamic>.from(e as Map)))
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
  final String? imdbId;
  final String releaseDate;
  final String? runtime;
  final String rating;
  final String voteCount;
  final String backdropPath;
  final List<String> directors;
  final String? tagline;
  final String status;
  final String type;
  final List<TvShowCast> casts;
  final List<TvShowCategory> categories;
  final List<TvShowTag> tags;
  final String? resolution;
  final int views;
  final String isAdult;
  final int homieTv;
  final int ysflix;
  final String? isBookmark;
  final int bookmarkId;
  final String? shareableLink;
  final List<dynamic> zipDownloadLinks;
  final List<TvShowSeason> seasons;

  double get ratingValue {
    return double.tryParse(rating) ?? 0;
  }

  bool get bookmarked {
    return isBookmark != null;
  }

  int get episodeCount {
    return seasons.fold(0, (total, season) => total + season.episodes.length);
  }

  List<String> get genres {
    return categories.map((e) => e.name).toList();
  }
}

final class TvShowCast {
  const TvShowCast({required this.name, required this.profilePath});

  factory TvShowCast.fromMap(Map<String, dynamic> map) {
    return TvShowCast(
      name: map['name'] as String? ?? '',
      profilePath: map['profile_path'] as String?,
    );
  }

  final String name;
  final String? profilePath;
}

final class TvShowCategory {
  const TvShowCategory({
    required this.id,
    required this.tmdbGenreId,
    required this.name,
  });

  factory TvShowCategory.fromMap(Map<String, dynamic> map) {
    return TvShowCategory(
      id: map['id'] as int,
      tmdbGenreId: map['tmdb_genre_id']?.toString() ?? '',
      name: map['name'] as String? ?? '',
    );
  }

  final int id;
  final String tmdbGenreId;
  final String name;
}

final class TvShowTag {
  const TvShowTag({required this.id, required this.name});

  factory TvShowTag.fromMap(Map<String, dynamic> map) {
    return TvShowTag(id: map['id'] as int, name: map['name'] as String? ?? '');
  }

  final int id;
  final String name;
}

final class TvShowSeason {
  const TvShowSeason({
    required this.id,
    required this.name,
    required this.isEnd,
    required this.episodes,
  });

  factory TvShowSeason.fromMap(Map<String, dynamic> map) {
    return TvShowSeason(
      id: map['id'] as int,
      name: map['name'] as String? ?? '',
      isEnd: map['is_end'] as bool?,
      episodes: (map['episodes'] as List? ?? const [])
          .map(
            (e) => TvShowEpisode.fromMap(Map<String, dynamic>.from(e as Map)),
          )
          .toList(),
    );
  }

  final int id;
  final String name;
  final bool? isEnd;
  final List<TvShowEpisode> episodes;
}

final class TvShowEpisode {
  const TvShowEpisode({
    required this.id,
    required this.tvShowId,
    required this.seasonId,
    required this.seasonNumber,
    required this.seasonName,
    required this.tmdbEpisodeId,
    required this.name,
    required this.poster,
    required this.episodeNumber,
    required this.runtime,
    required this.airDate,
    required this.downloadLinks,
  });

  factory TvShowEpisode.fromMap(Map<String, dynamic> map) {
    return TvShowEpisode(
      id: map['id'] as int,
      tvShowId: map['tv_show_id']?.toString() ?? '',
      seasonId: map['season_id']?.toString() ?? '',
      seasonNumber: map['season_number']?.toString() ?? '',
      seasonName: map['season_name'] as String? ?? '',
      tmdbEpisodeId: map['tmdb_episode_id']?.toString() ?? '',
      name: map['name'] as String? ?? '',
      poster: map['poster'] as String? ?? '',
      episodeNumber: map['episode_number']?.toString() ?? '',
      runtime: map['runtime'] as String?,
      airDate: map['air_date'] as String? ?? '',
      downloadLinks: (map['tvshow_download_links'] as List? ?? const [])
          .map(
            (e) =>
                TvShowDownloadLink.fromMap(Map<String, dynamic>.from(e as Map)),
          )
          .toList(),
    );
  }

  final int id;
  final String tvShowId;
  final String seasonId;
  final String seasonNumber;
  final String seasonName;
  final String tmdbEpisodeId;
  final String name;
  final String poster;
  final String episodeNumber;
  final String? runtime;
  final String airDate;
  final List<TvShowDownloadLink> downloadLinks;

  String get displayTitle {
    if (name.trim().isNotEmpty) {
      return name;
    }

    return 'Episode $episodeNumber';
  }

  bool get hasDownloads {
    return downloadLinks.isNotEmpty;
  }
}

final class TvShowDownloadLink {
  const TvShowDownloadLink({
    required this.id,
    required this.serverName,
    required this.url,
    required this.size,
    required this.quality,
    required this.resolution,
    required this.viewable,
  });

  factory TvShowDownloadLink.fromMap(Map<String, dynamic> map) {
    return TvShowDownloadLink(
      id: map['id'] as int,
      serverName: (map['server_name'] as String? ?? '').trim(),
      url: map['url'] as String? ?? '',
      size: map['size'] as String? ?? '',
      quality: map['quality'] as String? ?? '',
      resolution: map['resolution'] as String? ?? '',
      viewable: map['viewable'] as String? ?? '',
    );
  }

  final int id;
  final String serverName;
  final String url;
  final String size;
  final String quality;
  final String resolution;
  final String viewable;
}
