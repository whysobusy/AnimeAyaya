import 'package:anime_player/constant.dart';
import 'package:anime_player/data/models/one_episode_info.dart';
import 'package:anime_player/parser/one_episode_parser.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'episode_state.dart';

class EpisodeCubit extends Cubit<EpisodeState> {
  EpisodeCubit() : super(EpisodeInitial());

  void loadInfo(String? link) async {
    final parser = OneEpisodeParser(Constant.defaultDomain + (link ?? ''));
    final body = await parser.downloadHTML();
    final info = parser.parseHTML(body);
    info.currentEpisodeLink = link;
    final fomattedName = info.name?.split(RegExp(r"[^a-zA-Z0-9]")).join('+') ?? "";
    emit(EpisodeLoaded(info: info, fomattedName: fomattedName));
  }
}
