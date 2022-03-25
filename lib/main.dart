import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'levels_game.dart';

void main() {
  runApp(
    MaterialApp(
      /*  theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          headline1: TextStyle(
            fontFamily: 'MarioRegular',
          ),
        ),
      ), */
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
