part of 'app_bloc.dart';

@immutable
abstract class AppState {}

class AppInitial extends AppState {}

class AppInitialized extends AppState {
  AppInitialized({
    required this.favouriteList,
    required this.historyList,
    required this.hideDUB,
  });
  final List<BasicAnime> favouriteList;

  final List<BasicAnime?> historyList;

  final bool hideDUB;
}

class AppError extends AppState {}