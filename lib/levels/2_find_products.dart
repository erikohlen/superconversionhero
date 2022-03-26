import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame_audio/flame_audio.dart';
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
  final Function onDeath;
  final Function onSucceed;

  FindProducts({
    required this.onDeath,
    required this.onSucceed,
  }) : super();

  // Level config
  final double playerWidth = 140;
  final double playerHeight = 140;

  // Level state
  bool isDead = false;
  bool hasSucceded = false;

  // Level specific state
  bool timeToLoadProduct = true;
  double _attentionSpan = 100;
  int _relevantFound = 0;
  List<int> _relevantFoundIds = [];

  // Level components
  final attentionSpanText =
      TextComponent(text: 'Attention span left: 100%', textRenderer: kRegular);
  final relevantProductsText =
      TextComponent(text: 'Relevant products found: 0', textRenderer: kRegular);
  final diedText = TextComponent(
      text: "You've got choice paralysis!", textRenderer: kBiggerText);
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

    add(PlatformHitbox(
      type: 'platform',
      anchor: Anchor.bottomLeft,
      size: Vector2(kScreenWidth, 132),
      position: Vector2(0, kScreenHeight),
    ));

    //! Player
    final playerImage = gameRef.heroRight;
    _player = Player(
      playerImage,
      decrementAttentionSpan: () {
        if (_attentionSpan > 0) {
          _attentionSpan -= 1;
          attentionSpanText.text =
              'Attention span left: ${_attentionSpan.toStringAsFixed(0)}%';
        } else {
          attentionSpanText.text = 'Attention span left: 0%';
        }
      },
      incrementPoints: (int productId) {
        if (!isDead && !hasSucceded) {
          _relevantFound += 1;
          _relevantFoundIds.add(productId);
          relevantProductsText.text =
              'Relevant products found: $_relevantFound';
          succeedText.text = 'You found $_relevantFound products! ';
          if (_relevantFound == 1) {
            succeedText.text = 'You found $_relevantFound product! ';
          }
        }
        FlameAudio.play('smb_coin.wav');
      },
      anchor: Anchor.bottomCenter,
      levelBounds: _levelBounds,
      position: Vector2(kScreenWidth / 2, 200),
      size: Vector2(
        playerWidth,
        playerHeight,
      ),
      jumpSpeed: 400,
      moveSpeed: 600,
    );
    add(_player);

    //! Attention span
    attentionSpanText
      ..anchor = Anchor.topCenter
      ..x = kScreenWidth / 2 // size is a property from game
      ..y = 40.0;
    add(attentionSpanText);

    //! Relevant products
    relevantProductsText
      ..anchor = Anchor.topCenter
      ..x = kScreenWidth / 2 // size is a property from game
      ..y = 72.0;
    add(relevantProductsText);
  }

  //! UPDATE
  @override
  void update(double dt) {
    //! Spawn new product pages
    if (timeToLoadProduct == true && !isDead && !hasSucceded) {
      timeToLoadProduct = false;
      final _x = Random().nextInt(kScreenWidth.toInt()).toDouble();
      //TODO: Implement real product info
      // Random int between 0 and 14 to randomize what productpage.
      final _productIndex = Random().nextInt(24) + 1;
      Image _productImage;

      switch (_productIndex) {
        case 1:
          _productImage = gameRef.product1;
          break;
        case 2:
          _productImage = gameRef.product2;
          break;
        case 3:
          _productImage = gameRef.product3;
          break;
        case 4:
          _productImage = gameRef.product4;
          break;
        case 5:
          _productImage = gameRef.product5;
          break;
        case 6:
          _productImage = gameRef.product6;
          break;
        case 7:
          _productImage = gameRef.product7;
          break;
        case 8:
          _productImage = gameRef.product8;
          break;
        case 9:
          _productImage = gameRef.product9;
          break;
        case 10:
          _productImage = gameRef.product10;
          break;
        case 11:
          _productImage = gameRef.product11;
          break;
        case 12:
          _productImage = gameRef.product12;
          break;
        case 13:
          _productImage = gameRef.product13;
          break;
        case 14:
          _productImage = gameRef.product14;
          break;
        case 15:
          _productImage = gameRef.product5;
          break;
        case 16:
          _productImage = gameRef.product6;
          break;
        case 17:
          _productImage = gameRef.product7;
          break;
        case 18:
          _productImage = gameRef.product8;
          break;
        case 19:
          _productImage = gameRef.product9;
          break;
        case 20:
          _productImage = gameRef.product10;
          break;
        case 21:
          _productImage = gameRef.product11;
          break;
        case 22:
          _productImage = gameRef.product12;
          break;
        case 23:
          _productImage = gameRef.product13;
          break;
        case 24:
          _productImage = gameRef.product14;
          break;
        case 25:
          _productImage = gameRef.product5;
          break;
        case 26:
          _productImage = gameRef.product6;
          break;
        case 27:
          _productImage = gameRef.product7;
          break;
        case 28:
          _productImage = gameRef.product8;
          break;
        case 29:
          _productImage = gameRef.product9;
          break;
        case 30:
          _productImage = gameRef.product10;
          break;
        case 31:
          _productImage = gameRef.product11;
          break;
        case 32:
          _productImage = gameRef.product12;
          break;
        case 33:
          _productImage = gameRef.product13;
          break;
        case 34:
          _productImage = gameRef.product14;
          break;
        default:
          _productImage = gameRef.product11; // of course goomba is default :)
      }
      bool _isRelevant = _productIndex <= 4 ? true : false;

      add(
        ProductPage(
          _productImage,
          productId: _productIndex,
          isRelevantProduct: _isRelevant,
          levelBounds: _levelBounds,
          anchor: Anchor.topCenter,
          size: Vector2(276, 325),
          position: Vector2(
            _x,
            -800,
          ),
        ),
      );
      Future.delayed(Duration(milliseconds: 500), () {
        timeToLoadProduct = true;
      });
    }

    //! Check if attention span has reached 0
    if (_attentionSpan <= 0 && !isDead && !hasSucceded) {
      if (_relevantFound == 0) {
        handleDeath();
      }
      if (_relevantFound > 0) {
        handleSuccess();
      }
    }

    super.update(dt);
  }

  //! HANDLE DEATH
  void handleDeath() async {
    isDead = true;
    FlameAudio.bgm.stop();
    FlameAudio.play('smb_mariodie.wav');
    _player.collidableType = CollidableType.inactive;
    Future.delayed(
      const Duration(
        milliseconds: 3000,
      ),
      () {
        add(diedText);
        // TODO: Move into first definition
        diedText.anchor = Anchor.topCenter;
        diedText.x = kScreenWidth / 2;
        diedText.y = 300;

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
            onSucceed(_relevantFoundIds);
          },
        );
      },
    );
  }
}
