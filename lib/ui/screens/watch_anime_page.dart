import 'package:anime_player/data/models/anime_video.dart';
import 'package:anime_player/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// WatchAnimePage class
class WatchAnimePage extends StatefulWidget {
  const WatchAnimePage({
    Key? key,
    required this.video,
  }) : super(key: key);

  final VideoServer video;

  @override
  State<WatchAnimePage> createState() => _WatchAnimePageState();
}

class _WatchAnimePageState extends State<WatchAnimePage> {
  @override
  void initState() {
    super.initState();
    // Fullscreen mode
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    // Landscape only
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    // Reset UI overlay
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    // Reset orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Util.isIOS()
          ? AppBar(
              title: Text(widget.video.title ?? ''),
            )
          : null,
      body: WebView(
        initialUrl: widget.video.link,
        javascriptMode: JavascriptMode.unrestricted,
        initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
        navigationDelegate: (request) async {
          if (widget.video.link != null) {
            if (!request.url.contains(widget.video.link!)) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          } else {
            return NavigationDecision.prevent;
          }
        },
      ),
    );
  }
}
