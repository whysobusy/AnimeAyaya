import 'dart:async';

import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

/// This is the parent of all parsers and it handles 404 not found.
abstract class BasicParser {
  String? _link;

  /// Get the link for current page
  String? getLink() => _link;

  BasicParser(String link) {
    _link = link;
  }

  /// Download HTML string from link
  Future<Document?> downloadHTML() async {
    try {
      final response = await http
          .get(
            Uri.parse(_link!),
          )
          .timeout(const Duration(seconds: 8)); // Timeout in 8s

      if (response.statusCode == 200) {
        return parse(response.body);
      } else {
        // Not 200, just null
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  /// All subclasses have different implementations
  parseHTML(Document? body);
}
