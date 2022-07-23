import 'package:anime_player/cache.dart';
import 'package:anime_player/data/models/basic_anime.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(AppInitial()) {
    on<AppInit>(_onAppInit);
    on<AppUpdateHistory>(_onAppUpdateHistory);
    on<AppUpdateFavourite>(_onAPpUpdateFavourite);
    on<AppUpdateDUB>(_onAppUpdateDUB);
  }

  final Cache cache = Cache();

  void _onAppInit(AppInit event, emit) async {
    try {
      await cache.init();
      emit(AppInitialized(
        favouriteList: cache.favouriteList,
        historyList: cache.historyList,
        hideDUB: cache.hideDUB,
      ));
    } catch (e) {
      emit(AppError());
    }
  }

  void _onAppUpdateHistory(AppUpdateHistory event, emit) async {
    try {
      if (event.add) {
        cache.addToHistory(event.anime!);
      } else {
        cache.clearAll();
      }
      emit(AppInitialized(
        favouriteList: cache.favouriteList,
        historyList: cache.historyList,
        hideDUB: cache.hideDUB,
      ));
    } catch (e) {
      emit(AppError());
    }
  }

  void _onAPpUpdateFavourite(AppUpdateFavourite event, emit) async {
    try {
      if (event.add) {
        cache.addToFavourite(event.anime);
      } else {
        cache.removeFromFavourite(event.anime);
      }
      emit(AppInitialized(
        favouriteList: cache.favouriteList,
        historyList: cache.historyList,
        hideDUB: cache.hideDUB,
      ));
    } catch (e) {
      emit(AppError());
    }
  }

  void _onAppUpdateDUB(AppUpdateDUB event, emit) async {
    try {
      cache.hideDUB = event.hideDUB;
      emit(AppInitialized(
        favouriteList: cache.favouriteList,
        historyList: cache.historyList,
        hideDUB: cache.hideDUB,
      ));
    } catch (e) {
      emit(AppError());
    }
  }
}
