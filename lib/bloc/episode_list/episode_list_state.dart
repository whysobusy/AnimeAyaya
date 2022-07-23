part of 'episode_list_cubit.dart';

@immutable
abstract class EpisodeListState {}

class EpisodeListInitial extends EpisodeListState {}

class EpisodeListLoaded extends EpisodeListState {
  EpisodeListLoaded({required this.infoList, required this.currEpisode});

  final List<EpisodeInfo> infoList;
  final String? currEpisode;
}