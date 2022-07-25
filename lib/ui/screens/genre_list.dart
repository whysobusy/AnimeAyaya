import 'package:anime_player/data/models/anime_genre.dart';
import 'package:anime_player/ui/screens/genre_page.dart';
import 'package:flutter/material.dart';

/// GenreList class
class GenreList extends StatelessWidget {
  /// The entire genre list all in one
  final genreList = [
    'Action',
    'Adventure',
    'Cars',
    'Comedy',
    'Dementia',
    'Demons',
    'Drama',
    'Ecchi',
    'Fantasy',
    'Game',
    'Harem',
    'Historical',
    'Horror',
    'Josei',
    'Kids',
    'Magic',
    'Martial Arts',
    'Mecha',
    'Military',
    'Music',
    'Mystery',
    'Parody',
    'Police',
    'Psychological',
    'Romance',
    'Samurai',
    'School',
    'Sci-Fi',
    'Seinen',
    'Shoujo',
    'Shoujo Ai',
    'Shounen',
    'Shounen Ai',
    'Slice of Life',
    'Space',
    'Sports',
    'Super Power',
    'Supernatural',
    'Thriller',
    'Vampire',
    'Yaoi',
    'Yuri'
  ];

  GenreList({
    Key? key,
    this.func,
  }) : super(key: key);

  /// This is only used by TabletHomePage
  final Function? func;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Genre", style: TextStyle(color: Colors.white),),
        ),
        body: Container(
          padding: const EdgeInsets.all(10.0),
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.0,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
            ),
            itemCount: genreList.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                      colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.45), BlendMode.dstATop),
                      image: AssetImage("assets/images/a$index.jpg")
                    ),
                    border: Border.all(width: 3.0),
                    borderRadius: BorderRadius.circular(10)),
                child: InkWell(
                  onTap: (() => _onPressed(genreList[index], context)),
                  child: Center(
                      child: Text(
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontStyle: FontStyle.italic),
                          genreList[index])),
                ),
              );
            },
          ),
        ));
  }

  void _onPressed(String item, context) {
    final genre = AnimeGenre(item);
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GenrePage(genre: genre),
      ),
    );
  }
}
