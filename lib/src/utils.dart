import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class Flashly {
  static final navigatorKey = GlobalKey<NavigatorState>();
  static final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  static BuildContext get context => navigatorKey.currentState!.context;
}

Future<void> playAudio(String path) async {
  await AudioPlayer().play(AssetSource(path));
}

Future<void> playAlert({
  String? errorPath, 
  required String path, 
  bool isError = false, 
}) async {
  if (isError && errorPath != null) {
    await playAudio(errorPath);

    return;
  }
  await playAudio(path);
}