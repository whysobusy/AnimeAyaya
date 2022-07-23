
import 'package:anime_player/data/models/anime_detail_info.dart';
import 'package:anime_player/parser/basic_parser.dart';
import 'package:html/dom.dart';

class DetailedInfoParser extends BasicParser {
  DetailedInfoParser(String link) : super(link);

  @override
  AnimeDetailedInfo parseHTML(Document? body) {
    return AnimeDetailedInfo(body);
  }
}
