import 'package:than_pkg/services/index.dart';

class MovieDownloadLink {
  final String id;
  final String url;
  final String serverName;
  final String size;
  final String quality;
  final String resolution;
  MovieDownloadLink({
    required this.id,
    required this.url,
    required this.serverName,
    required this.size,
    required this.quality,
    required this.resolution,
  });

  factory MovieDownloadLink.fromMap(Map<String, dynamic> map) {
    return MovieDownloadLink(
      id: map.getString(['id']),
      url: map.getString(['url']),
      serverName: map.getString(['server_name']).trim(),
      size: map.getString(['size']),
      quality: map.getString(['quality']),
      resolution: map.getString(['resolution']),
    );
  }

  @override
  String toString() {
    return serverName;
  }
}
