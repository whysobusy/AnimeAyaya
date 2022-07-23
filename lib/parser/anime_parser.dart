import 'package:anime_player/data/models/anime_info.dart';
import 'package:anime_player/parser/basic_parser.dart';
import 'package:html/dom.dart';

/// This parses the grid gogoanime uses
class AnimeParser extends BasicParser {
  AnimeParser(String link) : super(link);

  @override
  List<AnimeInfo> parseHTML(Document? body) {
    List<AnimeInfo> list = [];

    if (body != null) {
      final div = body.getElementsByClassName('items');
      // There should only one of the list
      if (div.length == 1) {
        final items = div.first;
        // check if items contains an error message
        if (!items.text.contains('Sorry')) {
          // It can be an empty list
          if (items.hasChildNodes()) {
            // ignore: avoid_function_literals_in_foreach_calls
            items.nodes.forEach((element) {
              // Only parse elements, no Text
              if (element is Element) {
                list.add(AnimeInfo(element));
              }
            });
          }
        }
      }
    }

    return list;
  }
}
