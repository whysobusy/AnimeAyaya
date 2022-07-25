import 'package:anime_player/bloc/app/app_bloc.dart';
import 'package:anime_player/ui/screens/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Settings class
class Settings extends StatefulWidget {
  const Settings({
    Key? key,
  }) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        if (state is AppInitialized) {
          final bloc = BlocProvider.of<AppBloc>(context);
          final hideDUB = bloc.cache.hideDUB;
          return Scaffold(
            appBar:  AppBar(title: const Text('Settings')),
            body: ListView(
              children: <Widget>[
                CheckboxListTile(
                  title: const Text('Hide Dub'),
                  subtitle: const Text('Hide all dub anime if you prefer sub'),
                  onChanged: (bool? value) {
                    bloc.add(AppUpdateDUB(hideDUB: value!));
                  },
                  value: hideDUB,
                ),
              ],
            ),
          );
        }

        return const LoadingPage();
      },
    );
  }
}
