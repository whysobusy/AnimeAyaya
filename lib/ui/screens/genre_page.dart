import 'package:anime_player/bloc/app/app_bloc.dart';
import 'package:anime_player/data/models/anime_genre.dart';
import 'package:anime_player/ui/screens/loading_page.dart';
import 'package:anime_player/ui/widgets/anime_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// AnimeGenrePage class
class GenrePage extends StatelessWidget {
  const GenrePage({
    Key? key,
    required this.genre,
  }) : super(key: key);

  final AnimeGenre genre;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(genre.getAnimeGenreName()),
        ),
        body: BlocBuilder<AppBloc, AppState>(
          builder: (context, state) {
            if (state is AppInitialized) {
              return AnimeGrid(
                url: genre.getFullLink(),
                hideDUB: state.hideDUB,
              );
            }

            return const LoadingPage();
          },
        ));
  }
}
