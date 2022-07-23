import 'package:anime_player/ui/screens/main_page.dart';
import 'package:anime_player/ui/screens/search_anime.dart';
import 'package:anime_player/ui/widgets/anime_drawer.dart';
import 'package:anime_player/ui/widgets/genre_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: TextField(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => const SearchAnime()));
            },
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48.0),
            child: Theme(
              data: Theme.of(context).copyWith(accentColor: Colors.white),
              child: Container(
                height: 48.0,
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Expanded(
                      child: const TabBar(tabs: [
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
                    InkWell(onTap: () {
                      Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GenreList(),
                  ),
                );
                    }, child: Icon(Icons.ac_unit)),
                  ],
                ),
              ),
            ),
          ),
          
          
          
        ),
        drawer: const AnimeDrawer(),
        body: TabBarView(
          children: [
            MainPage(url: '/page-recent-release.html',),
            MainPage(url: '/popular.html',),
            MainPage(url: '/anime-movies.html',),
            //GenreList(),
          ],
        ),
      ),
    );
  }
}
