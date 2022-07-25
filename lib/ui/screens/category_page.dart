import 'package:anime_player/bloc/app/app_bloc.dart';
import 'package:anime_player/ui/screens/loading_page.dart';
import 'package:anime_player/ui/widgets/anime_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// CategoryPage class
class CategoryPage extends StatelessWidget {
  const CategoryPage({
    Key? key,
    required this.url,
    required this.title,
  }) : super(key: key);

  final String? url;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? 'Unknown'),
      ),
      body: BlocBuilder<AppBloc, AppState>(
          builder: (context, state) {
            if (state is AppInitialized) {
              return AnimeGrid(
                url: url,
                hideDUB: state.hideDUB,
              );
            }

            return const LoadingPage();
          },
        ),
    );
  }
}