import 'package:anime_player/data/models/basic_anime.dart';
import 'package:anime_player/data/models/anime_video.dart';
import 'package:html/dom.dart';

class OneEpisodeInfo extends BasicAnime {
  OneEpisodeInfo(Element? e) : super.fromJson(null) {
    // Get name and category
    final body = e?.getElementsByClassName('anime_video_body_cate').first;
    final rawTitle = e?.nodes[1].text;
    if (rawTitle != null) {
      final regex = RegExp(r"Episode (\w.*?) ");
      final match = regex.firstMatch(rawTitle);
      currentEpisode = match?.group(1);
    }

    final categoryClass = body?.nodes[3];
    category = categoryClass?.attributes['title'];
    categoryLink = categoryClass?.attributes['href'];

    final nameClass = body?.nodes[5].nodes[3];
    name = nameClass?.attributes['title'];
    link = nameClass?.attributes['href'];

    // Get all video servers
    final server = e?.getElementsByClassName('anime_muti_link').first;
    final serverList = server?.nodes[1];
    serverList?.nodes.forEach((element) {
      if (element.runtimeType == Element) {
        // Add to servers
        servers.add(VideoServer(element as Element));
      }
    });

    final episode =
        e?.getElementsByClassName('anime_video_body_episodes').first;

    // TODO: make this look nicer
    try {
      nextEpisodeLink = episode?.nodes[3].nodes[1].attributes['href'];
    } catch (_) {}
    try {
      prevEpisodeLink = episode?.nodes[1].nodes[1].attributes['href'];
    } catch (_) {}
  }

  OneEpisodeInfo.fromJson(Map<String, dynamic> json)
      : currentEpisode = json['currentEpisode'],
        super.fromJson(json);

  String? category;
  String? categoryLink;

  String? currentEpisode;
  String? currentEpisodeLink;
  String? prevEpisodeLink;
  String? nextEpisodeLink;

  List<VideoServer> servers = [];
  
  String get episodeName => '[$currentEpisode] $name';

  /// Only need to save current episode
  @override
  Map<String, dynamic> toJson() => {
        'name': name,
        'link': link,
        'currentEpisode': currentEpisode,
      };
}