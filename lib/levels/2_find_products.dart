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

class FindProducts extends Component with HasGameRef<LevelsGame> {
  late Player _player;

  late Rect _levelBounds;
  late SpriteComponent _background;
  final Function onSucceed;
  final Function onDeath;

  FindProducts({required this.onSucceed, required this.onDeath}) : super();

  // Level config
  final double playerWidth = 140;
  final double playerHeight = 140;

  // Level state
  bool isDead = false;
  bool hasSucceded = false;

  // Level specific state
  bool timeToLoadProduct = true;

  // Level components
  final viewedProductsText =
      TextComponent(text: 'Viewed products: 0', textRenderer: kRegular);
  final relevantProductsText =
      TextComponent(text: 'Relevant products: 0', textRenderer: kRegular);
  final diedText = TextComponent(
      text: 'You got choice paralysis!', textRenderer: kBiggerText);
  final succeedText =
      TextComponent(text: 'You found products!', textRenderer: kBiggerText);

  @override
  Future<void>? onLoad() async {
    _levelBounds = const Rect.fromLTWH(
      0,
      -800,
      kScreenWidth,
      kScreenHeight + 1600,
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

    //! Ground
    add(SpriteComponent(
      sprite: Sprite(
        gameRef.overworldGround,
      ),
      anchor: Anchor.bottomLeft,
      position: Vector2(0, kScreenHeight),
      size: Vector2(kScreenWidth, 140),
      priority: 1,
    ));

    //! Ground platform hitbox
    final platform = PlatformHitbox(
      type: 'platform',
      anchor: Anchor.bottomLeft,
      size: Vector2(kScreenWidth, 132),
      position: Vector2(0, kScreenHeight),
    );
    add(platform);

    //! Player
    final playerImage = gameRef.heroRight;
    _player = Player(
      playerImage,
      anchor: Anchor.bottomCenter,
      levelBounds: _levelBounds,
      position: Vector2(kScreenWidth / 2, 200),
      size: Vector2(
        playerWidth,
        playerHeight,
      ),
    );
    add(_player);

    //! Viewed products
    viewedProductsText
      ..anchor = Anchor.topCenter
      ..x = kScreenWidth / 2 // size is a property from game
      ..y = 40.0;
    add(viewedProductsText);

    //! Relevant products
    relevantProductsText
      ..anchor = Anchor.topCenter
      ..x = kScreenWidth / 2 // size is a property from game
      ..y = 72.0;
    add(relevantProductsText);

    //! Test add product
    add(
      ProductPage(
        gameRef.product,
        levelBounds: _levelBounds,
        anchor: Anchor.topCenter,
        size: Vector2(276, 325),
        position: Vector2(
          200,
          -800,
        ),
      ),
    );
  }

  //! UPDATE
  @override
  void update(double dt) {
    if (timeToLoadProduct == true) {
      timeToLoadProduct = false;
      final _x = Random().nextInt(kScreenWidth.toInt()).toDouble();
      add(
        ProductPage(
          gameRef.product,
          levelBounds: _levelBounds,
          anchor: Anchor.topCenter,
          size: Vector2(276, 325),
          position: Vector2(
            _x,
            -800,
          ),
        ),
      );
      print('Add product page');
      Future.delayed(Duration(seconds: 3), () {
        timeToLoadProduct = true;
      });
    }

    super.update(dt);
  }

  //! HANDLE DEATH
  void handleDeath() async {
    isDead = true;
    Future.delayed(
      const Duration(
        milliseconds: 1000,
      ),
      () {
        add(diedText);
        // TODO: Move into first definition
        diedText.anchor = Anchor.topCenter;
        diedText.x = kScreenWidth / 2;
        diedText.y = 300;
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
        add(succeedText);
        succeedText.anchor = Anchor.topCenter;
        succeedText.x = kScreenWidth / 2;
        succeedText.y = 300;
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
