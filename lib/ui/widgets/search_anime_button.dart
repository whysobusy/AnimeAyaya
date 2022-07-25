import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// SearchAnimeButton class
class SearchAnimeButton extends StatelessWidget {
  const SearchAnimeButton({
    Key? key,
    required this.name,
  }) : super(key: key);

  final String? name;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        MaterialButton(
          onPressed: () {
            launchUrl(Uri.parse('https://www.google.com/search?q=$name'));
          },
          child: const Text(
            'Google',
          ),
        ),
        MaterialButton(
          onPressed: () {
            launchUrl(Uri.parse('https://duckduckgo.com/?q=$name'));
          },
          child: const Text('DuckDuckGo'),
        ),
      ],
    );
  }
}
