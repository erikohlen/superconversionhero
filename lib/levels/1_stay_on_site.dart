import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:superconversionhero/actors/background.dart';
import 'package:superconversionhero/constants/constants.dart';
import 'package:superconversionhero/levels_game.dart';
import 'package:flame/image_composition.dart';
import 'package:flutter/services.dart';

import 'package:flame/extensions.dart';
import '../actors/platform.dart';
import '../actors/player.dart';

class StayOnSite extends Component with HasGameRef<LevelsGame> {
  late Player _player;
  late SpriteComponent bounce;
  late Rect _levelBounds;
  late SpriteComponent _background;
  final Function onSucceed;
  final Function onDeath;

  StayOnSite({required this.onSucceed, required this.onDeath}) : super();

  // Level config
  final double playerWidth = 140;
  final double playerHeight = 140;

  // Level state
  int bounceSpeed = 500;
  bool isDead = false;
  bool hasSucceded = false;
  int bounceRate = 100;
  bool hasPassedPlayer = false;

  // Level components
  final bounceRateText =
      TextComponent(text: 'Bounce rate: 100%', textRenderer: kRegular);
  final resultText =
      TextComponent(text: 'You bounced!', textRenderer: kBiggerText);

  @override
  Future<void>? onLoad() async {
    _levelBounds = const Rect.fromLTWH(
      0,
      0,
      kScreenWidth,
      kScreenHeight + 400,
    );

    _spawnActors();

    return super.onLoad();
  }

  // This method takes care of spawning
  // all the actors in the game world.
  void _spawnActors() {
    _background = Background(gameRef.overworldSky);
    _background.size = Vector2(kScreenWidth, kScreenHeight);
    add(_background);
    //! Mushroom
    add(SpriteComponent(
      sprite: Sprite(
        gameRef.gigantMushroom,
      ),
      anchor: Anchor.bottomCenter,
      position: Vector2(kScreenWidth / 2, kScreenHeight),
      size: Vector2(300, 400),
    ));
    //! Mushroom platform hitbox
    final platform = PlatformHitbox(
      type: 'platform',
      anchor: Anchor.bottomCenter,
      size: Vector2(340, 390),
      position: Vector2(kScreenWidth / 2, kScreenHeight),
    );
    add(platform);
    //! Player
    final playerImage = gameRef.heroRight;
    _player = Player(
      playerImage,
      decrementAttentionSpan: () {},
      incrementRelevantViewed: () {},
      anchor: Anchor.bottomCenter,
      levelBounds: _levelBounds,
      position: Vector2(kScreenWidth / 2, 200),
      size: Vector2(playerWidth, playerHeight),
    );
    add(_player);
    //! Bounce
    bounce = SpriteComponent(
      sprite: Sprite(gameRef.bounce),
      anchor: Anchor.topLeft,
      size: Vector2(300, 160),
      position: Vector2(kScreenWidth + 400, kScreenHeight - 560),
    );
    add(bounce);

    //! Text components
    bounceRateText
      ..anchor = Anchor.topCenter
      ..x = kScreenWidth / 2 // size is a property from game
      ..y = 40.0;
    add(bounceRateText);
  }

  //! UPDATE
  @override
  void update(double dt) {
    super.update(dt);

    bounce.x -= bounceSpeed * dt;
    // Check if bounce has passed left side of screen
    if (bounce.x < 0 - 400 && isDead == false && hasSucceded == false) {
      bounceSpeed = Random().nextInt(10) * 100 + 500;
      bounce.x = kScreenWidth;
      hasPassedPlayer = false;
    }
    // Check if bounce has passed player, update bounce rate
    if (bounce.x - 100 < _player.x &&
        _player.y < bounce.x + 200 &&
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

    if (_player.y > kScreenHeight && isDead == false) {
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
        resultText.x = kScreenWidth / 2;
        resultText.y = 300;
      },
    );
    Future.delayed(
      const Duration(
        milliseconds: 3000,
      ),
      () {
        onDeath();
      },
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
        resultText.x = kScreenWidth / 2;
        resultText.y = 300;
      },
    );
    Future.delayed(
      const Duration(
        milliseconds: 3000,
      ),
      () {
        onSucceed();
      },
    );
  }
}
