import 'package:flutter/material.dart';

class Utils {
  static var messengerKey;

  static showSnackBar(String? text, [String? s]) {
    if (text == null) return;
    var messengerKey = GlobalKey<ScaffoldMessengerState>();
    final snackBar = SnackBar(content: Text(text), backgroundColor: Colors.red);

    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}