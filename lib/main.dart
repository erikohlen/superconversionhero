import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'actors/platform.dart';
import 'actors/player.dart';

final style = const TextStyle(
    color: Colors.white, fontSize: 20, fontFamily: 'MarioRegular');
final regular = TextPaint(style: style);
final biggerText = TextPaint(style: style.copyWith(fontSize: 32));
void main() {
  print('load the game widgets');
  runApp(Focus(
      onKey: (FocusNode node, RawKeyEvent event) => KeyEventResult.handled,
      child: GameWidget(game: MyGame())));
}

class MyGame extends FlameGame
    with HasCollidables, HasKeyboardHandlerComponents {
  final double screenWidth = 1080;
  final double screenHeight = 900;
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
  bool isDead = false;
  // Text Style

  final bounceRateText =
      TextComponent(text: 'Current bounce rate: 100%', textRenderer: regular);
  final youDiedText =
      TextComponent(text: 'You bounced!', textRenderer: biggerText);

  //! ON LOAD
  @override
  Future<void> onLoad() async {
    super.onLoad();
    //! Viewport

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

    //! Text components
    bounceRateText
      ..anchor = Anchor.topCenter
      ..x = screenWidth / 2 // size is a property from game
      ..y = 40.0;
    add(bounceRateText);
  }

  @override
  void update(double dt) {
    super.update(dt);

    bounce.x -= bounceSpeed * dt;
    if (bounce.x < 0 - 400 && isDead == false) {
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

    if (_player.y > size[1] && isDead == false) {
      handleDeath();
    }
    if (isDead == true) {}
  }

  void handleDeath() async {
    print('You died!');
    isDead = true;
    Future.delayed(
      Duration(
        milliseconds: 1000,
      ),
      () {
        add(youDiedText);
        youDiedText.anchor = Anchor.topCenter;
        youDiedText.x = screenWidth / 2;
        youDiedText.y = 300;
      },
    );
    Future.delayed(
      Duration(
        milliseconds: 3000,
      ),
      () {
        print('Go to Game Over Screen');
      },
    );
  }
}
