import 'package:anime_player/ui/screens/main_page.dart';
import 'package:anime_player/ui/screens/search_anime.dart';
import 'package:anime_player/ui/widgets/anime_drawer.dart';
import 'package:anime_player/ui/screens/genre_list.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Container(
            height: 40,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: InkWell(
              child: TextField(
                enabled: false,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.search, color: Colors.pink),
                  border: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.pink, width: 2.0),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                autofocus: false,
                showCursor: false,
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const SearchAnime()));
              },
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48.0),
            child: Container(
              height: 48.0,
              alignment: Alignment.center,
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                children: [
                  const Expanded(
                    child: TabBar(indicatorColor: Colors.pinkAccent, tabs: [
                      Tab(
                        text: "New Release",
                      ),
                      Tab(
                        text: "Popular",
                      ),
                      Tab(
                        text: "Movie",
                      ),
                    ]),
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GenreList(),
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.grid_view,
                        color: Colors.pinkAccent,
                      )),
                ],
              ),
            ),
          ),
        ),
        drawer: const AnimeDrawer(),
        body: const TabBarView(
          children: [
            MainPage(
              url: '/page-recent-release.html',
            ),
            MainPage(
              url: '/popular.html',
            ),
            MainPage(
              url: '/anime-movies.html',
            ),
            //GenreList(),
          ],
        ),
      ),
    );
  }
}
