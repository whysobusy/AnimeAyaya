import 'package:anime_player/data/models/basic_anime.dart';
import 'package:anime_player/data/models/basic_anime_list.dart';
import 'package:anime_player/data/models/one_episode_info.dart';

class WatchHistory extends BasicAnimeList {
  WatchHistory();
  WatchHistory.fromJson(
    Map<String, dynamic> json,
  ) : super.fromJson(json);

  @override
  bool contains(BasicAnime? anime) {
    if (anime is OneEpisodeInfo) {
      return list.any((e) => e?.name == anime.episodeName);
    } else {
      return list.any((e) => e?.name == anime?.name);
    }
  }

  @override
  String getName() => 'history';
}