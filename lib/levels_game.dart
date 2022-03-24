import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flame/input.dart';
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

  // References to game assets
  late Image superConversionHero;
  late Image overworldSky;
  late Image overworldGround;
  late Image overworldBg;
  late Image heroRight;
  late Image gigantMushroom;
  late Image bounce;
  late Image product;

  @override
  Future<void>? onLoad() async {
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
    product = await images.load('product.png');

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
                              next: () {}));
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
    //_loadLevels();

    loadLevel(
      FindProducts(
        onDeath: _loadLevels,
        onSucceed: () {
          loadLevel(LevelBlackIntro(
              levelNumber: 3, levelName: 'ADD TO CART', next: () {}));
        },
      ),
    );

    return super.onLoad();
  }

  // Swaps current level with given level
  void loadLevel(Component levelToLoad) {
    _currentLevel?.removeFromParent();
    _currentLevel = levelToLoad;
    add(_currentLevel!);
  }
}
