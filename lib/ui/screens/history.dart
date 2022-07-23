import 'package:anime_player/bloc/app/app_bloc.dart';
import 'package:anime_player/ui/screens/episode_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// History class
class History extends StatelessWidget {
  const History({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        if (state is AppInitialized) {
          return Scaffold(
            appBar: AppBar(actions: [
              InkWell(onTap: () {
                BlocProvider.of<AppBloc>(context).add(AppUpdateHistory(add: false));
              }, child: Icon(Icons.cleaning_services))
            ], title: Text('Watch History')),
            body: 
  
                  state.historyList.isNotEmpty
                      ? ListView.builder(
                          itemCount: state.historyList.length,
                          itemBuilder: (c, i) {
                            final curr = state.historyList[i];
                            return ListTile(
                              title: Text(curr?.name ?? 'Unknown'),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (c) => EpisodePage(info: curr),
                                  ),
                                );
                              },
                            );
                          },
                        )
                      : Center(
                          child: Text('No anime found'),
                        )
                );
        }

        return Center(child: CircularProgressIndicator(),);
      },
    );
  }
}
