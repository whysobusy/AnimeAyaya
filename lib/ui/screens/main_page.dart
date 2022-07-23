import 'package:anime_player/ui/widgets/anime_grid.dart';
import 'package:flutter/material.dart';

/// Movie class
class MainPage extends StatefulWidget {
  const MainPage({
    Key? key,
    required this.url,
  }) : super(key: key);

  final String url;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AnimeGrid(url: widget.url);
  }
}