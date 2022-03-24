/* import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'actors/platform.dart';
import 'actors/player.dart';
import 'constants/constants.dart';

class MyGame extends FlameGame
    with HasCollidables, HasKeyboardHandlerComponents {
  //! All kinds of variables. For game, for level.
  final double screenWidth = 1080;
  final double screenHeight = 900;
  SpriteComponent background = SpriteComponent();
  late Player _player;
  late Rect _levelBounds;
  SpriteComponent hero = SpriteComponent();
  SpriteComponent mushroom = SpriteComponent();
  SpriteComponent bounce = SpriteComponent();
  final double playerWidth = 140;
  final double playerHeight = 140;
  int bounceSpeed = 500;
  bool isDead = false;
  bool hasSucceded = false;
  int bounceRate = 100;
  bool hasPassedPlayer = false;

  final bounceRateText =
      TextComponent(text: 'Bounce rate: 100%', textRenderer: kRegular);
  final resultText =
      TextComponent(text: 'You bounced!', textRenderer: kBiggerText);

  //! LOAD
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
    final platform = PlatformHitbox(
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
      incrementProductsViewed: () {},
      incrementRelevantViewed: () {},
      anchor: Anchor.bottomCenter,
      levelBounds: _levelBounds,
      position: Vector2(screenWidth / 2, 200),
      size: Vector2(playerWidth, playerHeight),
    );
    add(_player);

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

  //! UPDATE
  @override
  void update(double dt) {
    super.update(dt);

    bounce.x -= bounceSpeed * dt;
    // Check when bounce has passed left side of screen
    if (bounce.x < 0 - 400 && isDead == false && hasSucceded == false) {
      bounceSpeed = Random().nextInt(10) * 100 + 500;
      bounce.x = size[0];
      hasPassedPlayer = false;
    }
    // Check when bounce has passed player, update bounce rate
    if (bounce.x - 100 < _player.x &&
        isDead == false &&
        hasPassedPlayer == false) {
      bounceRate -= 10;
      bounceRateText.text = 'Bounce rate: $bounceRate %';
      hasPassedPlayer = true;
      if (bounceRate <= 0) {
        handleSuccess();
      }
    }
    // Check if bounce is colliding with hero
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

  //! HANDLE DEATH
  void handleDeath() async {
    isDead = true;
    Future.delayed(
      const Duration(
        milliseconds: 1000,
      ),
      () {
        add(resultText);
        resultText.anchor = Anchor.topCenter;
        resultText.x = screenWidth / 2;
        resultText.y = 300;
      },
    );
    Future.delayed(
      const Duration(
        milliseconds: 3000,
      ),
      () {},
    );
  }

  //! HANDLE SUCCEED
  void handleSuccess() async {
    hasSucceded = true;
    Future.delayed(
      const Duration(
        milliseconds: 1000,
      ),
      () {
        add(resultText);
        resultText.text = 'You stayed on site!';
        resultText.anchor = Anchor.topCenter;
        resultText.x = screenWidth / 2;
        resultText.y = 300;
      },
    );
    Future.delayed(
      const Duration(
        milliseconds: 3000,
      ),
      () {},
    );
  }
}
 */