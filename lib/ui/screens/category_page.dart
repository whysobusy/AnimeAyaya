import 'package:anime_player/ui/widgets/anime_grid.dart';
import 'package:flutter/material.dart';

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
      body: AnimeGrid(url: url),
    );
  }
}