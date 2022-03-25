import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'levels_game.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Focus(
          onKey: (FocusNode node, RawKeyEvent event) => KeyEventResult.handled,
          child: GameWidget(
            game: LevelsGame(),
          ),
        ),
      ),
    ),
  );
}
