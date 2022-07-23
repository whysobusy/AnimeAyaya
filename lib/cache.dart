import 'dart:convert';

import 'package:anime_player/data/models/basic_anime.dart';
import 'package:anime_player/data/models/favorite_anime.dart';
import 'package:anime_player/data/models/watch_hishory.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Cache {
  // Relating to local data
  late SharedPreferences prefs;
  final watchHistory = 'Ayaya:WatchHistory';
  final favouriteAnime = 'Ayaya:FavouriteAnime';
  final hideDubAnime = 'Ayaya:HideDUB';

  /// Whwther dub anime should be hidden
  late bool _hideDUB;
  bool get hideDUB => _hideDUB;
  set hideDUB(bool value) {
    _hideDUB = value;
    prefs.setBool(hideDubAnime, _hideDUB);
  }

  /// History list
  WatchHistory _history = WatchHistory();
  List<BasicAnime?> get historyList => _history.list;
  bool hasWatched(BasicAnime? anime) => _history.contains(anime);
  void clearAll() {
    _history = WatchHistory();
    prefs.setString(watchHistory, 'null');
  }

  void addToHistory(BasicAnime anime) {
    _history.add(anime);
    // Save
    prefs.setString(watchHistory, jsonEncode(_history.toJson()));
  }

  /// Favourite list
  FavouriteAnime _favourite = FavouriteAnime();
  List<BasicAnime> get favouriteList => _favourite.list;
  bool isFavourite(BasicAnime anime) => _favourite.contains(anime);
  void removeFromFavourite(BasicAnime anime) {
    _favourite.remove(anime);
    prefs.setString(favouriteAnime, jsonEncode(_favourite.toJson()));
  }

  void addToFavourite(BasicAnime anime) {
    _favourite.add(anime);
    // Save
    prefs.setString(favouriteAnime, jsonEncode(_favourite.toJson()));
  }

  Future<void> init() async {
    // Setup shared preference
    prefs = await SharedPreferences.getInstance();

    try {
      // Load history and favourite anime
      String? historyString = prefs.getString(watchHistory);
      if (historyString != null) {
        _history = WatchHistory.fromJson(jsonDecode(historyString));
      }
    } catch (e) {
      _history = WatchHistory();
    }

    try {
      String? favouriteString = prefs.getString(favouriteAnime);
      if (favouriteString != null) {
        _favourite = FavouriteAnime.fromJson(jsonDecode(favouriteString));
      }
    } catch (e) {
      _favourite = FavouriteAnime();
    }

    // Set to false by default
    try {
      _hideDUB = prefs.getBool(hideDubAnime) ?? false;
    } catch (e) {
      _hideDUB = false;
    }
  }
}
