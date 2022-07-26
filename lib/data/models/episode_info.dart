import 'package:anime_player/data/models/basic_anime.dart';
import 'package:html/dom.dart';

class EpisodeInfo extends BasicAnime {
  EpisodeInfo(Element e) : super.fromJson(null) {
    final node = e.nodes[0];
    name = node.nodes[1].text?.trim();
    link = node.attributes['href']?.trim();
  }
}
