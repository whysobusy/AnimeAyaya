import 'package:html/dom.dart';

class VideoServer {
  VideoServer(Element e) {
    final node = e.nodes[1];

    // Fix link with https
    var link1 = node.attributes['data-video'] ?? '';
    if (!link1.startsWith('http')) {
      link1 = 'https://$link1';
    }
    link = link1;

    // Get the title
    final title1 = node.nodes[0].text ?? '';
    if (title1.trim().isEmpty) {
      title = node.nodes[2].text?.toUpperCase();
    } else {
      title = title1.toUpperCase();
    }
  }

  String? title;
  String? link;
}