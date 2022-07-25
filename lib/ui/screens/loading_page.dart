import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
            margin: const EdgeInsets.all(50),
            child: const Text(
              "Loading...",
              style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
            )),
        LoadingAnimationWidget.beat(
          color: Colors.pink,
          size: 100,
        ),
      ]),
    ));
  }
}
