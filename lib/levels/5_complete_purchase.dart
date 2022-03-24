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
import '../actors/product_page.dart';

class CompletePurchase extends Component with HasGameRef<LevelsGame> {
  late SpriteComponent _background;
  late Player _player;

  late Rect _levelBounds;
  final Function onDeath;
  final Function onSucceed;

  CompletePurchase({
    required this.onDeath,
    required this.onSucceed,
  }) : super();

  // Level config
  final double playerWidth = 140;
  final double playerHeight = 140;
  final double castleWidth = 4676;
  final double castleHeight = 1030;

  // Level state
  bool isDead = false;
  bool hasSucceded = false;

  // Level specific state

  // Level components
  final attentionSpanText =
      TextComponent(text: 'Attention span left: 100%', textRenderer: kRegular);
  final relevantProductsText =
      TextComponent(text: 'Relevant products found: 0', textRenderer: kRegular);
  final diedText = TextComponent(
      text: 'You got choice paralysis!', textRenderer: kBiggerText);
  final succeedText =
      TextComponent(text: 'You found products!', textRenderer: kBiggerText);

  @override
  Future<void>? onLoad() async {
    _levelBounds = Rect.fromLTWH(
      0,
      0,
      castleWidth,
      castleHeight,
    );
    _spawnActors();
    _setupCamera();
    return super.onLoad();
  }

  // This method takes care of spawning
  // all the actors in the game world.
  void _spawnActors() {
    //! Background
    _background = SpriteComponent(
      sprite: Sprite(
        gameRef.castleBg,
      ),
      size: Sprite(
        gameRef.castleBg,
      ).originalSize,
      /* size: Vector2(
        kScreenWidth,
        kScreenHeight,
      ), */
    );
    add(_background);

    //! Ground platform hitboxes
    // Bottom
    add(
      PlatformHitbox(
        type: 'platform',
        anchor: Anchor.bottomLeft,
        position: Vector2(0, castleHeight),
        size: Vector2(castleWidth, 145),
      ),
    );

    //! Player
    final playerImage = gameRef.heroRight;
    _player = Player(
      playerImage,
      levelBounds: _levelBounds,
      decrementAttentionSpan: () {},
      incrementPoints: (int productId) {},
      jumpSpeed: 1200,
      moveSpeed: 600,
      anchor: Anchor.bottomCenter,
      position: Vector2(100, 200),
      size: Vector2(
        playerWidth,
        playerHeight,
      ),
    );
    add(_player);
  }

  //! UPDATE
  @override
  void update(double dt) {
    super.update(dt);
  }

  //! HANDLE DEATH
  void handleDeath() async {
    isDead = true;
    Future.delayed(
      const Duration(
        milliseconds: 3000,
      ),
      () {
        add(diedText);
        // TODO: Move into first definition
        diedText.anchor = Anchor.topCenter;
        diedText.x = kScreenWidth / 2;
        diedText.y = kScreenHeight / 2;

        Future.delayed(
          const Duration(
            milliseconds: 5000,
          ),
          () {
            onDeath();
          },
        );
      },
    );
  }

  //! HANDLE SUCCEED
  void handleSuccess() async {
    hasSucceded = true;
    Future.delayed(
      const Duration(
        milliseconds: 3000,
      ),
      () {
        add(succeedText);
        succeedText.anchor = Anchor.topCenter;
        succeedText.x = kScreenWidth / 2;
        succeedText.y = 300;
        Future.delayed(
          const Duration(
            milliseconds: 5000,
          ),
          () {
            onSucceed();
          },
        );
      },
    );
  }

  // This method is responsible for making the camera
  // follow the player component and also for keeping
  // the camera within level bounds.
  /// NOTE: Call only after [_spawnActors].
  void _setupCamera() {
    gameRef.camera.followComponent(_player);
    gameRef.camera.worldBounds = _levelBounds;
  }
}
