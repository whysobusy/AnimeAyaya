import 'package:anime_player/bloc/app/app_bloc.dart';
import 'package:anime_player/ui/screens/anime_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Favourite class
class Favourite extends StatelessWidget {
  const Favourite({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        if (state is AppInitialized) {
          final list = state.favouriteList;
          return Scaffold(
            appBar: AppBar(title: const Text('Favourite Anime')),
            body: list.isNotEmpty
                ? ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (c, i) {
                      final curr = list[i];
                      return ListTile(
                        title: Text(curr.name ?? 'Unknown'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (c) => AnimeDetailPage(info: curr),
                            ),
                          );
                        },
                      );
                    },
                  )
                : const Center(
                    child: Text('No anime found'),
                  ),
          );
        }

        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
