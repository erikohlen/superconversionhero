import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

void main() {
  print('load the game widgets');
  runApp(GameWidget(game: MyGame()));
}

class MyGame extends FlameGame {
  SpriteComponent background = SpriteComponent();
  SpriteComponent hero = SpriteComponent();
  SpriteComponent platform = SpriteComponent();
  SpriteComponent bounce = SpriteComponent();
  final double heroWidth = 140;
  final double heroHeight = 120;
  int bounceSpeed = 500;
  @override
  Future<void> onLoad() async {
    super.onLoad();
    camera.viewport = FixedResolutionViewport(
      Vector2(800, 600),
    );
    final screenWidth = size[0];
    final screenHeight = size[1];

    add(background
      ..sprite = await loadSprite('overworld_bg.png')
      ..size = size);
    hero
      ..sprite = await loadSprite('hero_right.png')
      ..size = Vector2(heroWidth, heroHeight)
      ..x = size[0] / 2 - 150
      ..y = size[1] - 400 - heroHeight;
    add(hero);
    platform
      ..sprite = await loadSprite('gigant_mushroom.png')
      ..size = Vector2(300, 400)
      ..anchor = Anchor.bottomCenter
      ..x = size[0] / 2
      ..y = size[1];

    add(platform);
    bounce
      ..sprite = await loadSprite('bounce.png')
      ..size = Vector2(300, 200)
      ..y = size[1] - 400 - heroHeight
      ..x = size[0];
    add(bounce);
  }

  @override
  void update(double dt) {
    super.update(dt);
    bounce.x -= bounceSpeed * dt;
    if (bounce.x < 0 - 400) {
      bounceSpeed = Random().nextInt(10) * 100 + 500;
      bounce.x = size[0];
    }
  }
}



 






























/* 
// A single instance to avoid creation of
// multiple instances in every build.
final _game = SimplePlatformer();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: GameWidget(
          game: kDebugMode ? SimplePlatformer() : _game,
        ),
      ),
    );
  }
}
 */