import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame_audio/flame_audio.dart';
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

class AddToCart extends Component with HasGameRef<LevelsGame>, KeyboardHandler {
  late Player _player;

  late Rect _levelBounds;
  late SpriteComponent _background;
  late PlatformHitbox _platform;
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
  bool _isFirstProductLoaded = false;

  // Level components
  final addedToCartText =
      TextComponent(text: 'Products added to cart: 0', textRenderer: kRegular);

  final diedText = TextComponent(
      text: 'You had Fears, Uncertainties\nand Doubts!',
      textRenderer: kBiggerText);
  final succeedText = TextComponent(
      text: 'You added products to cart!', textRenderer: kBiggerText);
  final endOfDemo = TextComponent(
      text: 'This is the end of the Demo\nof the game. Good bye!',
      textRenderer: kBiggerText);
  late SpriteComponent _basket;
  late SpriteComponent _meter;
  late SpriteComponent _triangle;

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

  ThrowableProduct? _productToThrow;

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
    _platform = PlatformHitbox(
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
      //TODO Add back in
      isMovableSideways: false,
      decrementAttentionSpan: () {},
      incrementPoints: (int productId) {},
      /* (int productId) {
        if (!isDead && !hasSucceded) {
          _addedToCart += 1;
          _addedToCartIds.add(productId);

          succeedText.text = 'You added $_addedToCart products to cart!';
        }
      }, */
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
        size: Vector2(40, 40),
        position: Vector2(
          kScreenWidth - 120,
          220,
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
  }

  bool _isProductLoaded = false;
  bool _isMeterShowing = false;
  int _triangleSpeed = 5;
  double _throwStrength = 0;

  //! Handle Throwing
  void showMeter() {
    _meter = SpriteComponent(
      sprite: Sprite(gameRef.meter),
      anchor: Anchor.center,
      position: Vector2(kScreenWidth / 2, kScreenHeight / 2),
    );
    add(_meter);
    _triangle = SpriteComponent(
      sprite: Sprite(gameRef.triangle),
      anchor: Anchor.center,
      position: Vector2(kScreenWidth / 2 + 80, kScreenHeight / 2),
    );
    add(_triangle);
    _isMeterShowing = true;
  }

  void loadProductToThrow() {
    // Double check there is a product to load, for null check
    if (productsToThrow.length > 0) {
      // Define product to throw before removing stacked product behind player
      _productToThrow = ThrowableProduct(
        productsToThrow.last.sprite!.image,
        levelBounds: const Rect.fromLTWH(
          -400,
          -400,
          kScreenWidth + 800,
          kScreenHeight + 800,
        ),
        productId: productsToThrow.last.productId,
        position: Vector2(205, 500),
        size: Vector2(276 / 4, 325 / 4),
        addToCart: (int productId) {
          _addedToCart += 1;
          addedToCartText.text = 'Products added to cart: $_addedToCart';
          succeedText.text = 'You added $_addedToCart products to cart!';
          if (_addedToCart == 1) {
            succeedText.text = 'You added 1 product to cart!';
          }
          //FlameAudio.play('smb_mariodie.wav');
        },
      );
      // Remove product from level
      remove(productsToThrow.last);
      // Remove product from list
      productsToThrow.remove(productsToThrow.last);
      if (_productToThrow != null) {
        add(_productToThrow!);
      }

      // TODO: Wait X seconds after  product is loaded in hands of player, then init throw
      // TODO: Function to init meter and throw
      //TODO: Load meter. Listen to "Space" keypress. Loop through strength.
      //TODO: When pressed, throw with currentstrength
      //_productToThrow.getThrown(throwStrength: 15);

      Future.delayed(Duration(seconds: 1), () {
        showMeter();
      });
    }
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    print('Key pressed!');
    if (keysPressed.contains(LogicalKeyboardKey.space)) {
      if (_isMeterShowing) {
        print('Thrown with strength: $_throwStrength');
        _productToThrow?.getThrown(throwStrength: _throwStrength);

        FlameAudio.play('cannon.mp3');
        remove(_meter);
        remove(_triangle);
        _isMeterShowing = false;
        Future.delayed(Duration(seconds: 3), () {
          _isProductLoaded = false;
        });
      }
    }

    return true;
  }

  //! UPDATE
  @override
  void update(double dt) {
    // Load first product
    if (!_isProductLoaded && !_isFirstProductLoaded) {
      _isFirstProductLoaded = true;
      _isProductLoaded = true;
      Future.delayed(Duration(seconds: 3), () {
        loadProductToThrow();
      });
    }
    if (!_isProductLoaded &&
        productsToThrow.length > 0 &&
        _isFirstProductLoaded) {
      _isProductLoaded = true;

      loadProductToThrow();
    }
    if (_isMeterShowing) {
      _triangle.y -= _triangleSpeed;
      _throwStrength =
          //7 + (5 * ((kScreenHeight / 2) - _triangle.y) / 140); //TODO
          20 + (5 * ((kScreenHeight / 2) - _triangle.y) / 140); //TODO

      if (_triangle.y <= (kScreenHeight / 2) - 140) {
        _triangleSpeed = -15;
      }
      if (_triangle.y >= (kScreenHeight / 2) + 140) {
        _triangleSpeed = 15;
      }
    }
    // Handle end of level
    if (!_isProductLoaded && productsToThrow.length == 0) {
      if (_addedToCart == 0 && !isDead) {
        isDead = true;
        handleDeath();
      }
      if (_addedToCart > 0 && !hasSucceded) {
        hasSucceded = true;
        handleSuccess();
      }
    }

    super.update(dt);
  }

  //! HANDLE DEATH
  void handleDeath() async {
    Future.delayed(
      const Duration(
        milliseconds: 3000,
      ),
      () {
        FlameAudio.bgm.stop();
        FlameAudio.play('smb_mariodie.wav');
        _player.collidableType = CollidableType.inactive;
        _platform.collidableType = CollidableType.inactive;
        add(diedText);
        // TODO: Move into first definition
        diedText.anchor = Anchor.topCenter;
        diedText.x = kScreenWidth / 2;
        diedText.y = kScreenHeight / 2;

        Future.delayed(
          const Duration(
            milliseconds: 3000,
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
    add(succeedText);
    succeedText.anchor = Anchor.topCenter;
    succeedText.x = kScreenWidth / 2;
    succeedText.y = kScreenHeight / 2 - 100;
    Future.delayed(
      const Duration(
        milliseconds: 2000,
      ),
      () {
        FlameAudio.bgm.stop();
        Future.delayed(
          const Duration(
            milliseconds: 1000,
          ),
          () {
            //FlameAudio.bgm.stop();
            FlameAudio.bgm.play('win.mp3');
            add(endOfDemo);
            endOfDemo.anchor = Anchor.topCenter;
            endOfDemo.x = kScreenWidth / 2;
            endOfDemo.y = kScreenHeight / 2 + 30;
            Future.delayed(
                Duration(
                  seconds: 1,
                ),
                () {});
          },
        );
      },
    );
  }
}
