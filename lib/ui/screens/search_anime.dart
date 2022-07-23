import 'package:anime_player/bloc/app/app_bloc.dart';
import 'package:anime_player/ui/widgets/anime_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// SearchAnime class
class SearchAnime extends StatefulWidget {
  const SearchAnime({
    Key? key,
  }) : super(key: key);

  @override
  State<SearchAnime> createState() => _SearchAnimeState();
}

class _SearchAnimeState extends State<SearchAnime> {
  String search = '';
  String formattedSearch = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          style: const TextStyle(color: Colors.white, fontSize: 20),
          decoration: const InputDecoration.collapsed(
            hintText: 'Search anime',
            hintStyle: TextStyle(color: Colors.white70, fontSize: 20),
          ),
          cursorColor: Colors.white70,
          autocorrect: false,
          autofocus: true,
          onChanged: (t) {
            setState(() {
              search = t;
              formattedSearch = '';
            });
          },
          onEditingComplete: () {
            FocusScope.of(context).requestFocus(FocusNode());
            setState(() {
              // Replcae space with %20
              formattedSearch = search.split(' ').join('%20');
            });
          },
        ),
      ),
      body: renderGrid(),
    );
  }

  Widget renderGrid() {
    if (formattedSearch.length < 3) {
      return Container();
    } else {
      return BlocBuilder<AppBloc, AppState>(
        builder: (context, state) {
          if (state is AppInitialized) {
            return AnimeGrid(
              url: '/search.html?keyword=$formattedSearch',
              hideDUB: state.hideDUB,
            );
          }

          return CircularProgressIndicator();
        },
      );
    }
  }
}