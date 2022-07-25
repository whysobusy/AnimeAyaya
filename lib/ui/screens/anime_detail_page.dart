import 'package:anime_player/bloc/anime_detail/anime_detail_cubit.dart';
import 'package:anime_player/bloc/app/app_bloc.dart';
import 'package:anime_player/bloc/episode_list/episode_list_cubit.dart';
import 'package:anime_player/data/models/anime_detail_info.dart';
import 'package:anime_player/data/models/basic_anime.dart';
import 'package:anime_player/data/models/episode_section.dart';
import 'package:anime_player/ui/screens/episode_page.dart';
import 'package:anime_player/ui/screens/genre_page.dart';
import 'package:anime_player/ui/screens/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AnimeDetailPage extends StatelessWidget {
  const AnimeDetailPage({super.key, required this.info});

  final BasicAnime info;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<AnimeDetailCubit>(
            create: (BuildContext context) =>
                AnimeDetailCubit()..loadAnimeDetail(info.link ?? ''),
          ),
          BlocProvider<EpisodeListCubit>(
            create: (BuildContext context) => EpisodeListCubit(),
          ),
        ],
        child: BlocBuilder<AnimeDetailCubit, AnimeDetailState>(
            builder: (context, state) {
          if (state is AnimeDetailLoaded) {
            //if (state.info.episodes.length <= 1) {
            final episodes = state.info.episodes;
            context
                .read<EpisodeListCubit>()
                .loadEpisodeList(episodes.isEmpty ? null : episodes.first);
            //}

            return Scaffold(
              appBar: AppBar(
                title: Text(
                  state.info.status ?? 'Error',
                  style: const TextStyle(color: Colors.white),
                ),
                actions: <Widget>[
                  BlocBuilder<AppBloc, AppState>(
                    builder: (context, appState) {
                      final appBloc = BlocProvider.of<AppBloc>(context);
                      final isFavourite = appBloc.cache.isFavourite(info);
                      return IconButton(
                        icon: Icon(
                          isFavourite ? Icons.favorite : Icons.favorite_border,
                          color: Colors.pinkAccent,
                        ),
                        onPressed: () {
                          BlocProvider.of<AppBloc>(context).add(
                              AppUpdateFavourite(
                                  anime: info, add: !isFavourite));
                        },
                      );
                    },
                  ),
                ],
              ),
              body: SafeArea(
                child: ListView(
                  children: [
                    // anime info
                    _AnimeInfo(info: state.info),
                    _Summary(state.info.summary ?? 'No summary'),
                    // genre
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: state.info.genre.map((e) {
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: ActionChip(
                                shape: const StadiumBorder(
                                    side: BorderSide(color: Colors.pinkAccent)),
                                backgroundColor: Colors.transparent,
                                label: Text(
                                  e.getAnimeGenreName(),
                                  style:
                                      const TextStyle(color: Colors.pinkAccent),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      return GenrePage(genre: e);
                                    }),
                                  );
                                },
                              ),
                            );
                          }).toList(growable: false)),
                    ),
                    // episode list
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text(
                        'Episode List',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    _EpisodeList(episodes: state.info.episodes)
                  ],
                ),
              ),
            );
          }

          return const LoadingPage();
        }));
  }
}

class _AnimeInfo extends StatelessWidget {
  const _AnimeInfo({super.key, required this.info});

  final AnimeDetailedInfo info;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 300,
          width: 200,
          child: AspectRatio(
            aspectRatio: 0.7,
            child: Ink(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(info.image!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                info.name ?? '',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 24,
                    color: Colors.pinkAccent,
                    fontStyle: FontStyle.italic),
                maxLines: 3,
              ),
              _CenteredListTile(
                  title: 'Released', subtitle: info.released ?? 'Unkown'),
              _CenteredListTile(
                  title: 'Episode(s)', subtitle: info.lastEpisode ?? 'Unkown'),
              _CenteredListTile(
                  title: 'Category', subtitle: info.category ?? 'Unkown'),
            ],
          ),
        ),
      ],
    );
  }
}

class _EpisodeList extends StatelessWidget {
  const _EpisodeList({super.key, required this.episodes});

  final List<EpisodeSection> episodes;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EpisodeListCubit, EpisodeListState>(
      builder: (context, epState) {
        return Column(
          children: [
            Wrap(
                alignment: WrapAlignment.center,
                children: episodes.map((section) {
                  return Padding(
                      padding: const EdgeInsets.all(2),
                      child: MaterialButton(
                        shape: const StadiumBorder(
                            side: BorderSide(color: Colors.pinkAccent)),
                        onPressed: (() {
                          context
                              .read<EpisodeListCubit>()
                              .loadEpisodeList(section);
                        }),
                        child: Text(
                          '${section.episodeStart} - ${section.episodeEnd}',
                        ),
                      ));
                }).toList(growable: false)),
            if (epState is EpisodeListLoaded)
              renderEpisodeList(context, epState),
          ],
        );
      },
    );
  }

  Widget renderEpisodeList(BuildContext context, EpisodeListLoaded state) {
    if (state.currEpisode == null) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          "Upcoming",
          style: TextStyle(
              fontSize: 24, color: Colors.white, fontStyle: FontStyle.italic),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          children: state.infoList.map((e) {
            return MaterialButton(
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
}

class _CenteredListTile extends StatelessWidget {
  const _CenteredListTile(
      {super.key, required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        textAlign: TextAlign.center,
      ),
      subtitle: Text(
        subtitle,
        textAlign: TextAlign.center,
        maxLines: 2,
      ),
    );
  }
}

class _Summary extends StatefulWidget {
  _Summary(this.text);

  final String text;
  bool isExpanded = false;

  @override
  _SummaryState createState() => _SummaryState();
}

class _SummaryState extends State<_Summary> {
  @override
  Widget build(BuildContext context) {
    return Stack(alignment: AlignmentDirectional.bottomEnd, children: <Widget>[
      ListTile(
          title: const Text(
            "Summary",
            textAlign: TextAlign.center,
          ),
          subtitle: Text(
            widget.text,
            maxLines: widget.isExpanded ? null : 2,
            textAlign: TextAlign.center,
          )),
      widget.isExpanded
          ? Container()
          : MaterialButton(
              color: Colors.black54,
              child: const Text(
                'More',
                style: TextStyle(color: Colors.pinkAccent),
              ),
              onPressed: () => setState(() => widget.isExpanded = true))
    ]);
  }
}
