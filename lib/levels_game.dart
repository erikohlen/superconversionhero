import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flame/input.dart';
import 'package:superconversionhero/levels/3_add_to_cart.dart';
import 'package:superconversionhero/levels/5_complete_purchase.dart';
import 'package:superconversionhero/levels/level_black_intro.dart';
import 'package:superconversionhero/levels/1_stay_on_site.dart';

import 'constants/constants.dart';
import 'levels/2_find_products.dart';
import 'levels/title_screen.dart';
import 'package:flame/extensions.dart';

// Represents the game world
class LevelsGame extends FlameGame
    with HasCollidables, HasKeyboardHandlerComponents {
  // Current active level
  Component? _currentLevel;
  Component? _levelToLoad;

  @override

  // References to game assets
  late Image superConversionHero;
  late Image overworldSky;
  late Image overworldGround;
  late Image overworldBg;
  late Image heroRight;
  late Image gigantMushroom;
  late Image bounce;
  late Image product1;
  late Image product2;
  late Image product3;
  late Image product4;
  late Image product5;
  late Image product6;
  late Image product7;
  late Image product8;
  late Image product9;
  late Image product10;
  late Image product11;
  late Image product12;
  late Image product13;
  late Image product14;
  late Image basket;
  late Image meter;
  late Image triangle;
  late Image castleBg;
  late Image player2;

  @override
  Future<void>? onLoad() async {
    super.debugMode = true;
    // Device setup
    await Flame.device.fullScreen();
    await Flame.device.setLandscape();

    camera.viewport = FixedResolutionViewport(
      Vector2(kScreenWidth, kScreenHeight),
    );

    // Load and define game assets
    superConversionHero = await images.load('super_conversion_hero.png');
    overworldSky = await images.load('overworld_sky.png');
    overworldGround = await images.load('overworld_ground.png');
    overworldBg = await images.load('overworld_bg.png');
    heroRight = await images.load('hero_right_small.png');
    gigantMushroom = await images.load('gigant_mushroom.png');
    bounce = await images.load('bounce.png');
    product1 = await images.load('product1.png');
    product2 = await images.load('product2.png');
    product3 = await images.load('product3.png');
    product4 = await images.load('product4.png');
    product5 = await images.load('product5.png');
    product6 = await images.load('product6.png');
    product7 = await images.load('product7.png');
    product8 = await images.load('product8.png');
    product9 = await images.load('product9.png');
    product10 = await images.load('product10.png');
    product11 = await images.load('product11.png');
    product12 = await images.load('product12.png');
    product13 = await images.load('product13.png');
    product14 = await images.load('product14.png');
    basket = await images.load('basket1.png');
    meter = await images.load('meter.png');
    triangle = await images.load('triangle.png');
    castleBg = await images.load('castle_bg.png');
    player2 = await images.load('player2.png');

    // Game state
    List<int> _productIdsCart = [1];

    // Load first level
    void _loadLevels() {
      loadLevel(LevelTitleScreen(
        next: () {
          loadLevel(LevelBlackIntro(
            levelNumber: 1,
            levelName: 'STAY ON SITE',
            next: () {
              loadLevel(StayOnSite(
                onDeath: _loadLevels,
                onSucceed: () {
                  loadLevel(LevelBlackIntro(
                    levelNumber: 2,
                    levelName: 'FIND PRODUCTS',
                    next: () {
                      loadLevel(FindProducts(
                        onDeath: _loadLevels,
                        onSucceed: () {
                          loadLevel(LevelBlackIntro(
                              levelNumber: 3,
                              levelName: 'ADD TO CART',
                              next: () {
                                loadLevel(
                                  AddToCart(
                                      productIds: _productIdsCart,
                                      onDeath: _loadLevels,
                                      onSucceed: () {
                                        loadLevel(LevelBlackIntro(
                                            levelNumber: 5,
                                            levelName: 'COMPLETE PURCHASE',
                                            next: () {
                                              loadLevel(
                                                CompletePurchase(
                                                  onDeath: _loadLevels,
                                                  onSucceed: () {},
                                                ),
                                              );
                                            }));
                                      }),
                                );
                              }));
                        },
                      ));
                    },
                  ));
                },
              ));
            },
          ));
        },
      ));
    }

    _loadLevels();

    /*   loadLevel(
      CompletePurchase(
        onDeath: _loadLevels,
        onSucceed: () {},
      ),
    ); */

    return super.onLoad();
  }

  // Swaps current level with given level
  void loadLevel(Component levelToLoad) {
    _currentLevel?.removeFromParent();
    _currentLevel = levelToLoad;
    add(_currentLevel!);
  }
}
