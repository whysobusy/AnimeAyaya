part of 'episode_cubit.dart';

@immutable
abstract class EpisodeState {}

class EpisodeInitial extends EpisodeState {}

class EpisodeLoaded extends EpisodeState {
  EpisodeLoaded({required this.info, required this.fomattedName});

  final OneEpisodeInfo info;
  final String fomattedName;
}
