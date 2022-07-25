import 'package:anime_player/bloc/app/app_bloc.dart';
import 'package:anime_player/ui/screens/loading_page.dart';
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
        title: Container(
          height: 50,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: TextField(
            style: const TextStyle(color: Colors.black, fontSize: 20),
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search, color: Colors.pink),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.pink, width: 2.0),
                  borderRadius: BorderRadius.circular(25.0),
                )),
            cursorColor: Colors.black,
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

          return const LoadingPage();
        },
      );
    }
  }
}
