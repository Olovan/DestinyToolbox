import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class Secrets {
  final String clientID;
  final String clientSecret;

  static Future<Secrets> fromFile(String path) async {
    WidgetsFlutterBinding.ensureInitialized(); // Required for the rootBundle to be available
    var contents = await rootBundle.loadString(path);
    return Secrets.fromString(contents);
  }

  factory Secrets.fromString(String jsonString) {
    var json = jsonDecode(jsonString);
    return Secrets(
      clientID: json['client_id'],
      clientSecret: json['client_secret']
    );
  }

  Secrets({this.clientID, this.clientSecret});
}