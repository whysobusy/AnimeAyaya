import 'package:anime_player/bloc/app/app_bloc.dart';
import 'package:anime_player/ui/screens/home_page.dart';
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
        home: BlocBuilder<AppBloc, AppState>(
          builder: (context, state) {
            if (state is AppInitialized) {
              return const HomePage();
            }

            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
