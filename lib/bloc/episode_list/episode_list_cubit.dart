import 'package:anime_player/constant.dart';
import 'package:anime_player/data/models/episode_info.dart';
import 'package:anime_player/data/models/episode_section.dart';
import 'package:anime_player/parser/episode_list_parser.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'episode_list_state.dart';

class EpisodeListCubit extends Cubit<EpisodeListState> {
  EpisodeListCubit() : super(EpisodeListInitial());

  void loadEpisodeList(EpisodeSection? section) async {
    final currEpisode = section?.episodeStart;
    final parser = EpisodeListParser(
      '${Constant.defaultDomain}/load-list-episode',
      section,
    );
    final body = await parser.downloadHTML();
    final infoList = parser.parseHTML(body);
    emit(EpisodeListLoaded(infoList: infoList, currEpisode: currEpisode));
  }
}
