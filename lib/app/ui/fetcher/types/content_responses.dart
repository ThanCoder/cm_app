class MovieContentResponse {
  final String descText;
  final List<MovieContentDownloadItem> downloadItems;
  const MovieContentResponse({
    required this.descText,
    required this.downloadItems,
  });
}

class MovieContentDownloadItem {
  final String title;
  final String quality;
  final String url;
  final String size;

  const MovieContentDownloadItem({
    required this.title,
    required this.quality,
    required this.url,
    required this.size,
  });
}

class TvShowContentResponse {
  final String descText;
  final List<TvShowSeason> seasons;
  final List<TvShowCast> castList;

  const TvShowContentResponse({
    required this.descText,
    required this.seasons,
    required this.castList,
  });
}

class TvShowSeason {
  final String title;
  final List<TvShowEpisode> episodios;

  const TvShowSeason({required this.title, required this.episodios});
}

class TvShowEpisode {
  final String title;
  final String number;
  final String url;
  final String coverUrl;

  const TvShowEpisode({
    required this.title,
    required this.number,
    required this.url,
    required this.coverUrl
  });
}

class TvShowCast {
  final String name;
  final String profileUrl;
  final String characterName;

  const TvShowCast({
    required this.name,
    required this.profileUrl,
    required this.characterName,
  });
}
