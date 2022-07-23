import 'package:anime_player/constant.dart';
import 'package:anime_player/data/models/anime_detail_info.dart';
import 'package:anime_player/parser/detailed_info_parser.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'anime_detail_state.dart';

class AnimeDetailCubit extends Cubit<AnimeDetailState> {
  AnimeDetailCubit() : super(AnimeDetailInitial());

  void loadAnimeDetail(String link) async {
    final parser =
        DetailedInfoParser(Constant.defaultDomain + link);
    final body = await parser.downloadHTML();
    final info = parser.parseHTML(body);
    emit(AnimeDetailLoaded(info: info));
  }
}
