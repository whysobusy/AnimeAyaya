import 'package:anime_player/bloc/app/app_bloc.dart';
import 'package:anime_player/ui/screens/home_page.dart';
import 'package:anime_player/ui/screens/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

// This widget is the root of the application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppBloc()..add(AppInit()),
      child: MaterialApp(
        title: 'Ayaya',
        theme: ThemeData(
            colorSchemeSeed: Colors.red,
            brightness: Brightness.dark,
            // Define the default `TextTheme`. Use this to specify the default
            // text styling for headlines, titles, bodies of text, and more.
            textTheme: const TextTheme(
              headline1: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              headline6: TextStyle(fontSize: 24, fontStyle: FontStyle.italic),
              bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
            )),
        home: BlocBuilder<AppBloc, AppState>(
          builder: (context, state) {
            if (state is AppInitialized) {
              return const HomePage();
            }

            return const LoadingPage();
          },
        ),
      ),
    );
  }
}
