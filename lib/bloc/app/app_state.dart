part of 'app_bloc.dart';

@immutable
abstract class AppState {}

class AppInitial extends AppState {}

class AppInitialized extends AppState {
  AppInitialized({
    required this.favouriteList,
    required this.historyList,
  });
  // TODO EQUATBLE
  final List<BasicAnime> favouriteList;

  final List<BasicAnime?> historyList;
}

class AppError extends AppState {}