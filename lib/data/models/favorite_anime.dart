import 'package:anime_player/data/models/basic_anime_list.dart';

class FavouriteAnime extends BasicAnimeList {
  FavouriteAnime();
  FavouriteAnime.fromJson(Map<String, dynamic> json) : super.fromJson(json);

  @override
  String getName() => 'favourite';
}
