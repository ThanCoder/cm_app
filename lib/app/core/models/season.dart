import 'package:than_pkg/services/t_map.dart';
import 'package:cm_app/app/core/models/movie_download_link.dart';

class Season {
  final String id;
  final String name;
  final List<Episode> episodes;
  Season({required this.id, required this.name, required this.episodes});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'episodes': episodes.map((x) => x.toMap()).toList(),
    };
  }

  factory Season.fromMap(Map<String, dynamic> map) {
    List<dynamic> dList = map['episodes'] ?? [];

    return Season(
      id: map.getString(['id']),
      name: map.getString(['name']),
      episodes: dList.map((map) => Episode.fromMap(map)).toList(),
    );
  }
}

class Episode {
  final String id;
  final String poster;
  final int episodeNumber;
  final String airDate;
  final List<MovieDownloadLink> tvshowDownloadLinks;
  Episode({
    required this.id,
    required this.poster,
    required this.episodeNumber,
    required this.airDate,
    required this.tvshowDownloadLinks,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'poster': poster,
      'episode_number': episodeNumber,
      'air_date': airDate,
      'tvshow_download_links': tvshowDownloadLinks
          .map((x) => x.toMap())
          .toList(),
    };
  }

  factory Episode.fromMap(Map<String, dynamic> map) {
    List<dynamic> dList = map['tvshow_download_links'] ?? [];
    return Episode(
      id: map.getString(['id']),
      poster: map.getString(['poster']),
      episodeNumber: map.getInt(['episode_number']),
      airDate: map.getString(['air_date']),
      tvshowDownloadLinks: dList
          .map((map) => MovieDownloadLink.fromMap(map))
          .toList(),
    );
  }
}
