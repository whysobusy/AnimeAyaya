import 'dart:math';

import 'package:anime_player/constant.dart';
import 'package:anime_player/data/models/anime_info.dart';
import 'package:anime_player/parser/anime_parser.dart';
import 'package:anime_player/ui/screens/anime_detail_page.dart';
import 'package:anime_player/ui/screens/episode_page.dart';
import 'package:anime_player/ui/widgets/anime_card.dart';
import 'package:flutter/material.dart';

class AnimeGrid extends StatefulWidget {
  const AnimeGrid({
    Key? key,
    required this.url,
  }) : super(key: key);

  final String? url;

  @override
  State<AnimeGrid> createState() => _AnimeGridState();
}

class _AnimeGridState extends State<AnimeGrid> {
  bool loading = true;
  List<AnimeInfo> list = [];

  int page = 1;
  bool canLoadMore = true;

  late ScrollController controller;
  bool showIndicator = false;

  void loadData({bool refresh = false}) {
    if (refresh) page = 1;
    setState(() {
      canLoadMore = false;
      showIndicator = true;
    });

    bool isSearch = widget.url?.startsWith('/search') ?? false;
    final link =
        '${Constant.defaultDomain}${widget.url!}${isSearch ? '&' : '?'}page=$page';
    final parser = AnimeParser(link);
    parser.downloadHTML().then((value) {
      final moreData = parser.parseHTML(value);
      // Append more data
      setState(() {
        loading = false;
        // If refresh, just reset the list to more data
        if (refresh) {
          list = moreData;
        } else {
          list += moreData;
        }
        // If more data is emptp, we have reached the end
        canLoadMore = moreData.isNotEmpty;
        showIndicator = false;
      });
    });
  }

  void loadMoreData() {
    if (controller.position.extentAfter < 10 && canLoadMore) {
      page += 1;
      loadData();
    }
  }

  void reload() {
    setState(() {
      loading = true;
    });
    loadData(refresh: true);
  }

  @override
  void initState() {
    super.initState();
    // Load some data here
    loadData();
    controller = ScrollController()..addListener(() => loadMoreData());
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return SafeArea(
      child: Stack(
        children: <Widget>[
          RefreshIndicator(
            onRefresh: () async {
              loadData(refresh: true);
            },
            child: Scrollbar(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final count =
                      max(min((constraints.maxWidth / 200).floor(), 6), 2);
                  final imageWidth = constraints.maxWidth / count.toDouble();
                  // Calculat ratio, adjust the offset (70)
                  final ratio = imageWidth / (imageWidth / 0.7 + 70);
                  final length = list.length;

                  return length > 0
                      ? GridView.builder(
                          controller: controller,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: count,
                            childAspectRatio: ratio,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            final info = list[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                child: AnimeCard(info: info),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      if (info.isCategory()) {
                                        return AnimeDetailPage(info: info);
                                      }
                                        return EpisodePage(info: info);
                                    }),
                                  );
                                },
                              ),
                            );
                          },
                          itemCount: length,
                        )
                      : _NotFound(
                          callback: reload,
                        );
                },
              ),
            ),
          ),
          showIndicator
              ? const Align(
                  alignment: Alignment.bottomCenter,
                  child: LinearProgressIndicator(),
                )
              : Container(),
        ],
      ),
    );
  }
}

class _NotFound extends StatelessWidget {
  const _NotFound({required this.callback});

  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Nothing was found. Try loading it again.\nDouble check the website link in Settings as well.',
            textAlign: TextAlign.center,
          ),
          IconButton(
            onPressed: callback,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }
}
