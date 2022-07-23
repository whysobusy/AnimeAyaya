part of 'app_bloc.dart';

@immutable
abstract class AppEvent {}

class AppInit extends AppEvent {}

class AppUpdateFavourite extends AppEvent {
  AppUpdateFavourite({required this.anime, required this.add});
  
  final BasicAnime anime;
  final bool add;
}

class AppUpdateHistory extends AppEvent {
  AppUpdateHistory({this.anime, required this.add});

  final BasicAnime? anime;
  final bool add;
}
