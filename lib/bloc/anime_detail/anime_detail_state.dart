part of 'anime_detail_cubit.dart';

@immutable
abstract class AnimeDetailState {}

class AnimeDetailInitial extends AnimeDetailState {}

class AnimeDetailLoaded extends AnimeDetailState {
  AnimeDetailLoaded({required this.info});

  final AnimeDetailedInfo info;
}
