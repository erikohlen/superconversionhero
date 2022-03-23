import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'actors/platform.dart';
import 'actors/player.dart';

void main() {
  print('load the game widgets');
  runApp(Focus(
      onKey: (FocusNode node, RawKeyEvent event) => KeyEventResult.handled,
      child: GameWidget(game: MyGame())));
}

class MyGame extends FlameGame
    with HasCollidables, HasKeyboardHandlerComponents {
  SpriteComponent background = SpriteComponent();
  late Player _player;
  late Image spriteSheet;
  late Rect _levelBounds;
  SpriteComponent hero = SpriteComponent();
  SpriteComponent mushroom = SpriteComponent();
  SpriteComponent bounce = SpriteComponent();
  final double playerWidth = 140;
  final double playerHeight = 140;
  int bounceSpeed = 500;

  //! ON LOAD
  @override
  Future<void> onLoad() async {
    super.onLoad();
    //! Viewport
    final double screenWidth = 1080;
    final double screenHeight = 900;

    camera.viewport = FixedResolutionViewport(
      Vector2(screenWidth, screenHeight),
    );
    _levelBounds = Rect.fromLTWH(
      0,
      0,
      screenWidth,
      screenHeight + 200,
    );
    //! Background
    add(background
      ..sprite = await loadSprite('overworld_sky.png')
      ..size = size);

    //! Mushroom
    mushroom
      ..sprite = await loadSprite('gigant_mushroom.png')
      ..anchor = Anchor.bottomCenter
      ..size = Vector2(300, 400)
      ..x = screenWidth / 2
      ..y = screenHeight;
    add(mushroom);

    //! Mushroom platform hitbox
    final platform = MyHitbox(
      type: 'platform',
      anchor: Anchor.bottomCenter,
      size: Vector2(340, 390),
      position: Vector2(screenWidth / 2, screenHeight),
    );
    add(platform);
    //! Player
    final playerImage = await images.load('hero_right_small.png');
    _player = Player(
      playerImage,
      anchor: Anchor.bottomCenter,
      levelBounds: _levelBounds,
      position: Vector2(screenWidth / 2, 200),
      size: Vector2(playerWidth, playerHeight),
    );
    add(_player);
    print('has loaded player');
    //! Bounce
    bounce
      ..anchor = Anchor.topLeft
      ..sprite = await loadSprite('bounce.png')
      ..size = Vector2(300, 160)
      ..x = screenWidth + 400
      ..y = screenHeight - 560;
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
    // Check if bounce is collid ing with hero
    if (bounce.x < _player.x &&
        bounce.x + 300 > _player.x &&
        bounce.y + 20 < _player.y) {
      //double diff = _player.x - bounce.x;
      _player.x -= (bounceSpeed * dt) / 1;
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
