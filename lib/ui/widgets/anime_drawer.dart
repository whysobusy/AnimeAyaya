import 'package:anime_player/ui/screens/drawer/favourite.dart';
import 'package:anime_player/ui/screens/drawer/history.dart';
import 'package:anime_player/ui/screens/drawer/setting.dart';
import 'package:flutter/material.dart';

/// AnimeDrawer class
class AnimeDrawer extends StatefulWidget {
  const AnimeDrawer({
    Key? key,
  }) : super(key: key);

  @override
  State<AnimeDrawer> createState() => _AnimeDrawerState();
}

class _AnimeDrawerState extends State<AnimeDrawer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              // Use black instead orange to not hurt users' eyes at night
              color:  Colors.pinkAccent
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                'Ayaya',
                style: TextStyle(
                  fontSize: 32,
                  // Different colour for dark mode
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Expanded(
            child: MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: ListView(
                children: <Widget>[
                  ListTile(
                    title: const Text('History'),
                    leading: const Icon(Icons.history, color: Colors.pinkAccent,),
                    onTap: () => push(
                      context,
                      const History(),
                    ),
                  ),
                  ListTile(
                    title: const Text('Favourite'),
                    leading: const Icon(Icons.favorite, color: Colors.pinkAccent,),
                    onTap: () => push(
                      context,
                      const Favourite(),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('Settings'),
                    leading: const Icon(Icons.settings, color: Colors.pinkAccent,),
                    onTap: () => push(
                      context,
                      const Settings(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Push to new screen and also remove all routes in the middle
  void push(BuildContext context, Widget screen) {
    // Pop the drawer
    Navigator.pop(context);
    // How to push to new screen?
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }
}