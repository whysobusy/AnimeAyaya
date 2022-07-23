import 'package:anime_player/data/models/anime_genre.dart';
import 'package:anime_player/data/models/episode_section.dart';
import 'package:html/dom.dart';

/// This contains the detailed anime info including descriptions
class AnimeDetailedInfo {
  String? image;
  String? name;
  String? category;
  String? categoryLink;
  String? summary;
  List<AnimeGenre> genre = [];
  String? released;
  String? status;

  /// A list of episode (1 - 100, 101 - 200 and so on)
  List<EpisodeSection> episodes = [];
  String? lastEpisode;

  AnimeDetailedInfo(Document? body) {
    // Parse basic info
    final infoClass = body?.getElementsByClassName('anime_info_body_bg').first;
    image = infoClass?.nodes[1].attributes['src'];
    name = infoClass?.nodes[3].text;

    final categoryNode = infoClass?.nodes[7].nodes[2];
    category = categoryNode?.attributes['title']?.replaceAll('Anime', '');
    categoryLink = categoryNode?.attributes['href'];

    // Remove the title
    try {
      // Can be empty
      summary = infoClass?.nodes[9].nodes[1].text?.trimRight();
    } catch (e) {
      summary = 'No summary';
    }
    final genreNode = infoClass?.nodes[13].nodes;
    // Remove the first node, it is just genre
    genreNode?.removeAt(0);
    genreNode?.forEach((element) {
      if (element is Element) {
        // Only the first item doesn't have a comma
        genre.add(AnimeGenre(element.text.split(',').last.trim()));
      }
    });

    released = infoClass?.nodes[15].nodes[1].text;
    status = infoClass?.nodes[17].nodes[1].text;

    // Parse current anime movie id
    final movieClass = body?.getElementById('movie_id');
    // This is necessary for episode section to return the link
    final animeID = movieClass?.attributes['value'];

    final episodeClass = body?.getElementById('episode_page');
    // ignore: avoid_function_literals_in_foreach_calls
    episodeClass?.nodes.forEach((element) {
      if (element is Element) {
        episodes.add(EpisodeSection(element, animeID));
      }
    });

    // Make sure it is not empty at least
    if (episodes.isNotEmpty) lastEpisode = episodes.last.episodeEnd;
  }
}
