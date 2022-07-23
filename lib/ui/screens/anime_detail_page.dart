import 'dart:math';

import 'package:anime_player/bloc/anime_detail/anime_detail_cubit.dart';
import 'package:anime_player/bloc/app/app_bloc.dart';
import 'package:anime_player/bloc/episode_list/episode_list_cubit.dart';
import 'package:anime_player/data/models/anime_detail_info.dart';
import 'package:anime_player/data/models/basic_anime.dart';
import 'package:anime_player/ui/screens/category_page.dart';
import 'package:anime_player/ui/screens/episode_page.dart';
import 'package:anime_player/ui/screens/genre_page.dart';
import 'package:anime_player/ui/widgets/anime_flat_button.dart';
import 'package:anime_player/ui/widgets/search_anime_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// AnimeDetailPage class
class AnimeDetailPage extends StatefulWidget {
  const AnimeDetailPage({
    Key? key,
    required this.info,
  }) : super(key: key);

  final BasicAnime info;

  @override
  State<AnimeDetailPage> createState() => _AnimeDetailPageState();
}

class _AnimeDetailPageState extends State<AnimeDetailPage> {

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AnimeDetailCubit>(
          create: (BuildContext context) =>
              AnimeDetailCubit()..loadAnimeDetail(widget.info.link ?? ''),
        ),
        BlocProvider<EpisodeListCubit>(
          create: (BuildContext context) => EpisodeListCubit(),
        ),
      ],
      child: BlocBuilder<AnimeDetailCubit, AnimeDetailState>(
        builder: (context, state) {
          if (state is AnimeDetailLoaded) {
            if (state.info.episodes.length <= 1) {
              final episodes = state.info.episodes;
              context
                  .read<EpisodeListCubit>()
                  .loadEpisodeList(episodes.isEmpty ? null : episodes.first);
            }
            return Scaffold(
              appBar: AppBar(
                title: Text(state.info.status ?? 'Error'),
                actions: <Widget>[
                  BlocBuilder<AppBloc, AppState>(
                    builder: (context, appState) {
                      final appBloc = BlocProvider.of<AppBloc>(context);
    final isFavourite = appBloc.cache.isFavourite(widget.info);
                      return IconButton(
                        icon: Icon(
                          isFavourite ? Icons.favorite : Icons.favorite_border,
                        ),
                        onPressed: () {
                          BlocProvider.of<AppBloc>(context).add(
                              AppUpdateFavourite(
                                  anime: widget.info, add: !isFavourite));
                        },
                      );
                    },
                  ),
                ],
              ),
              body: SafeArea(child: renderBody(state.info)),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget renderBody(AnimeDetailedInfo info) {
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            info.name ?? '',
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 24),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                flex: 1,
                child: info.image != null
                    ? Image.network(info.image!)
                    : Container(),
              ),
              Flexible(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    centeredListTile('Released', info.released ?? 'Unkown'),
                    centeredListTile(
                        'Episode(s)', info.lastEpisode ?? 'Unkown'),
                    ListTile(
                      title:
                          const Text('Category', textAlign: TextAlign.center),
                      // TODO: This button is very hidden so the user may not know about this
                      subtitle: AnimeFlatButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return CategoryPage(
                                // The domain will be added later so DON'T ADD IT HERE
                                url: info.categoryLink,
                                title: info.category,
                              );
                            }),
                          );
                        },
                        child: Text(
                          info.category ?? 'Unknown',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(pi),
                  child: info.image != null
                      ? Image.network(info.image!)
                      : Container(),
                ),
              ),
            ],
          ),
        ),
        SearchAnimeButton(name: widget.info.name),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: ListTile(
            title: const Text('Genre', textAlign: TextAlign.center),
            subtitle: Wrap(
                alignment: WrapAlignment.center,
                spacing: 4,
                children: info.genre.map((e) {
                  return ActionChip(
                    label: Text(e.getAnimeGenreName()),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return GenrePage(genre: e);
                        }),
                      );
                    },
                  );
                }).toList(growable: false)),
          ),
        ),
        centeredListTile('Summary', info.summary ?? 'No summary'),
        const Padding(
          padding: EdgeInsets.only(top: 8),
          child: Text(
            'Episode List',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ),
        BlocBuilder<EpisodeListCubit, EpisodeListState>(
          builder: (context, epState) {
            return Column(
              children: [
                Wrap(
                    alignment: WrapAlignment.center,
                    children: info.episodes.map((section) {
                      return Padding(
                        padding: const EdgeInsets.all(2),
                        child: InkWell(
                          onTap: () {
                            context
                                .read<EpisodeListCubit>()
                                .loadEpisodeList(section);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Text(
                              '${section.episodeStart} - ${section.episodeEnd}',
                              // style: TextStyle(
                              //   decoration:
                              //       state.currEpisode == section.episodeStart
                              //           ? TextDecoration.underline
                              //           : TextDecoration.none,
                              // ),
                            ),
                          ),
                        ),
                      );
                    }).toList(growable: false)),
                if (epState is EpisodeListLoaded)
                  renderEpisodeList(context, epState),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget renderEpisodeList(BuildContext context, EpisodeListLoaded state) {
    if (state.currEpisode == null) {
      return const Text("Upcoming");
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          children: state.infoList.map((e) {
            return ElevatedButton(
              style: ButtonStyle(
                textStyle: MaterialStateProperty.all(
                  const TextStyle(color: Colors.white),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return EpisodePage(info: e);
                  }),
                );
              },
              child: Text(e.name ?? '??'),
            );
          }).toList(growable: false),
        ),
      );
    }
  }

  Widget centeredListTile(String title, String subtitle) {
    return ListTile(
      title: Text(
        title,
        textAlign: TextAlign.center,
      ),
      subtitle: Text(
        subtitle,
        textAlign: TextAlign.center,
      ),
    );
  }
}
