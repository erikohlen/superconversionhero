import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:superconversionhero/actors/background.dart';
import 'package:superconversionhero/actors/throwable_product.dart';
import 'package:superconversionhero/constants/constants.dart';
import 'package:superconversionhero/levels_game.dart';
import 'package:flame/image_composition.dart';
import 'package:flutter/services.dart';

import 'package:flame/extensions.dart';
import '../actors/platform.dart';
import '../actors/player.dart';
import '../actors/product_page.dart';

class AddToCart extends Component with HasGameRef<LevelsGame> {
  late Player _player;

  late Rect _levelBounds;
  late SpriteComponent _background;
  final Function onDeath;
  final Function onSucceed;
  final List<int> productIds;

  AddToCart({
    required this.onDeath,
    required this.onSucceed,
    required this.productIds,
  }) : super();

  // Level config
  final double playerWidth = 140;
  final double playerHeight = 140;

  // Level state
  bool isDead = false;
  bool hasSucceded = false;

  // Level specific state
  List<ProductPage> productsToThrow = [];
  int _addedToCart = 0;
  List<int> _addedToCartIds = [];

  // Level components
  final addedToCartText =
      TextComponent(text: 'Products added to cart: 0', textRenderer: kRegular);

  final diedText = TextComponent(
      text: 'You added 0 products to cart!', textRenderer: kBiggerText);
  final succeedText = TextComponent(
      text: 'You added products to cart!', textRenderer: kBiggerText);
  late SpriteComponent _basket;
  @override
  Future<void>? onLoad() async {
    _levelBounds = const Rect.fromLTWH(
      0,
      0,
      kScreenWidth,
      kScreenHeight,
    );
    _spawnActors();
    return super.onLoad();
  }

  // This method takes care of spawning
  // all the actors in the game world.
  void _spawnActors() {
    //! Background
    _background = Background(gameRef.overworldSky);
    _background.size = Vector2(kScreenWidth, kScreenHeight);
    add(_background);

    //! Added to cart text
    addedToCartText
      ..anchor = Anchor.topCenter
      ..x = kScreenWidth / 2 // size is a property from game
      ..y = 40.0;
    add(addedToCartText);

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
    final _platform = PlatformHitbox(
      type: 'platform',
      anchor: Anchor.bottomLeft,
      size: Vector2(kScreenWidth, 132),
      position: Vector2(0, kScreenHeight),
    );
    add(_platform);

    //! Player
    final playerImage = gameRef.heroRight;
    _player = Player(
      playerImage,
      decrementAttentionSpan: () {},
      incrementPoints: (int productId) {
        if (!isDead && !hasSucceded) {
          _addedToCart += 1;
          _addedToCartIds.add(productId);

          succeedText.text =
              'You added $_addedToCart products! $_addedToCartIds';
        }
      },
      anchor: Anchor.bottomCenter,
      levelBounds: _levelBounds,
      position: Vector2(200, 200),
      size: Vector2(
        playerWidth,
        playerHeight,
      ),
    );
    add(_player);

    //! Ground platform hitbox
    final _playerHitbox = PlatformHitbox(
      type: 'playerholding',
      anchor: Anchor.bottomLeft,
      size: Vector2(200, 123),
      position: Vector2(100, kScreenHeight - 100),
    );
    add(_playerHitbox);

    //! Spawn products to throw behind player
    int _productsAdded = 0;
    for (int _productId in productIds) {
      Image _productImage;
      switch (_productId) {
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
        default:
          _productImage = gameRef.product1;
      }
      // Create list of product components to throw

      productsToThrow.add(
        ProductPage(
          _productImage,
          isRelevantProduct: true,
          levelBounds: Rect.fromLTWH(
            0,
            0,
            kScreenWidth,
            kScreenHeight - 100 - (_productsAdded * 80),
          ),
          anchor: Anchor.bottomCenter,
          productId: _productId,
          position: Vector2(40, 200),
          size: Vector2(276 / 4, 325 / 4),
          //scale: Vector2(0.3, 0.3),
          priority: 0,
        ),
      );
      _productsAdded += 1;
    }
    // Spawn products
    int _productsSpawned = 0;
    for (var product in productsToThrow) {
      Future.delayed(Duration(milliseconds: _productsSpawned * 500), () {
        add(product);
        product.x += _productsSpawned * 5;
      });
      _productsSpawned += 1;
    }

    //! Basket
    _basket = SpriteComponent(
      sprite: Sprite(
        gameRef.basket,
      ),
      anchor: Anchor.center,
      position: Vector2(
        kScreenWidth - 120,
        250,
      ),
      priority: 100,
    );
    add(_basket);

    //! Basket hitboxes
    //Frontrim
    add(
      PlatformHitbox(
        type: 'playerholding',
        anchor: Anchor.topLeft,
        size: Vector2(10, 80),
        position: Vector2(
          kScreenWidth - 200,
          220,
        ),
        angle: -0.3,
        priority: 300,
      ),
    );
    //Bottom
    add(
      PlatformHitbox(
        type: 'basketbottom',
        anchor: Anchor.topLeft,
        size: Vector2(100, 40),
        position: Vector2(
          kScreenWidth - 180,
          260,
        ),
        priority: 300,
      ),
    );
    //Backboard
    add(
      PlatformHitbox(
        type: 'playerholding',
        anchor: Anchor.topLeft,
        size: Vector2(50, 100),
        position: Vector2(kScreenWidth - 90, 180),
      ),
    );

    //! Handle Throwing
    //TODO: Wrap in function
    Future.delayed(
        Duration(milliseconds: 1 /* productsToThrow.length * 500 + 1000 */),
        () {
      // Hide from stack
      if (productsToThrow.length > 0) {
        ThrowableProduct _productToThrow = ThrowableProduct(
          productsToThrow.last.sprite!.image,
          levelBounds: Rect.fromLTWH(
            -400,
            -400,
            kScreenWidth + 800,
            kScreenHeight + 800,
          ),
          productId: productsToThrow.last.productId,
          position: Vector2(205, 500),
          size: Vector2(276 / 4, 325 / 4),
        );
        remove(productsToThrow.last);
        add(_productToThrow);
        Future.delayed(Duration(seconds: 1), () {
          _productToThrow.getThrown(throwStrength: 15);
        });
      }
    });
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
            onSucceed();
          },
        );
      },
    );
  }
}
