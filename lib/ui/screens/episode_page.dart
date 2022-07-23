import 'package:anime_player/Util.dart';
import 'package:anime_player/bloc/app/app_bloc.dart';
import 'package:anime_player/bloc/episode/episode_cubit.dart';
import 'package:anime_player/data/models/basic_anime.dart';
import 'package:anime_player/data/models/anime_video.dart';
import 'package:anime_player/data/models/one_episode_info.dart';
import 'package:anime_player/ui/screens/anime_detail_page.dart';
import 'package:anime_player/ui/screens/category_page.dart';
import 'package:anime_player/ui/screens/watch_anime_page.dart';
import 'package:anime_player/ui/widgets/search_anime_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

/// EpisodePage class
class EpisodePage extends StatefulWidget {
  const EpisodePage({
    Key? key,
    required this.info,
  }) : super(key: key);

  final BasicAnime? info;

  @override
  State<EpisodePage> createState() => _EpisodePageState();
}

class _EpisodePageState extends State<EpisodePage>
    with SingleTickerProviderStateMixin {
  String? link;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EpisodeCubit()..loadInfo(widget.info?.link),
      child: BlocBuilder<EpisodeCubit, EpisodeState>(
        builder: (context, state) {
          if (state is EpisodeLoaded) {
            if (state.info.currentEpisode == null) {
              // Sometimes, it doesn't load properly
              return const Center(
                child: Text('Failed to load. Please try again.'),
              );
            }

            return Scaffold(
              appBar: AppBar(
                title: Text(
                  'Episode ${state.info.currentEpisode ?? '??'}',
                ),
              ),
              body: renderBody(state.info),
              bottomNavigationBar: BottomAppBar(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Tooltip(
                        message: 'Previous episode',
                        child: IconButton(
                          onPressed: state.info.prevEpisodeLink != null
                              ? () {
                                  context
                                      .read<EpisodeCubit>()
                                      .loadInfo(state.info.prevEpisodeLink);
                                }
                              : null,
                          icon: const Icon(Icons.arrow_back),
                        ),
                      ),
                      SearchAnimeButton(name: state.fomattedName),
                      Tooltip(
                        message: 'Next episode',
                        child: IconButton(
                          onPressed: state.info.nextEpisodeLink != null
                              ? () {
                                  context
                                      .read<EpisodeCubit>()
                                      .loadInfo(state.info.nextEpisodeLink);
                                }
                              : null,
                          icon: const Icon(Icons.arrow_forward),
                        ),
                      ),
                    ]),
              ),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget renderBody(OneEpisodeInfo info) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ListTile(
              title: const Text('Anime Info', textAlign: TextAlign.center),
              subtitle: Text(
                info.name ?? 'No information',
                textAlign: TextAlign.center,
              ),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AnimeDetailPage(info: info),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Category', textAlign: TextAlign.center),
              subtitle: Text(
                info.category ?? 'Unknown',
                textAlign: TextAlign.center,
              ),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryPage(
                      url: info.categoryLink,
                      title: info.category,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Server List', textAlign: TextAlign.center),
              subtitle: Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: renderServerList(info) ?? [],
                ),
              ),
            ),
            const Text(
              'Please note that this app does not\nhave any controls over these sources',
              textAlign: TextAlign.center,
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Divider(),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget>? renderServerList(OneEpisodeInfo info) {
    return info.servers.map((e) {
      return Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Tooltip(
          message: 'Watch on ${e.title} server',
          child: ActionChip(
            onPressed: () {
              if (Util.isMobile()) {
                openInAppPlayer(e);
                _addToHistory(BasicAnime(
                  info.episodeName,
                  info.currentEpisodeLink,
                ));
              } else {
                if (e.link != null) launchUrl(Uri.parse(e.link!));
                _addToHistory(BasicAnime(
                  info.episodeName,
                  info.currentEpisodeLink,
                ));
              }
            },
            label: Text(e.title ?? 'Unknown'),
          ),
        ),
      );
    }).toList();
  }

  /// Watch with in app player
  openInAppPlayer(VideoServer e) {
    // Only android has the
    if (Util.isAndroid()) {
      Navigator.pop(context);
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WatchAnimePage(video: e),
        fullscreenDialog: true,
      ),
    );
  }

  /// Save this to watch history
  _addToHistory(BasicAnime anime) {
    BlocProvider.of<AppBloc>(context).add(AppUpdateHistory(anime: anime, add: true));
  }
}
