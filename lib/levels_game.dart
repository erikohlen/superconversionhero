import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flame/input.dart';

import 'constants.dart';
import 'levels/level_title_screen.dart';
import 'package:flame/extensions.dart';

// Represents the game world
class LevelsGame extends FlameGame
    with HasCollidables, HasKeyboardHandlerComponents {
  // Current active level
  Component? _currentLevel;

  // References to game assets
  late Image superConversionHero;
  late Image overworldSky;
  late Image overworldGround;
  late Image overworldBg;
  late Image heroRight;

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

    //overworldGround = await images.load('overworld_ground.png');

    // Load first level
    loadLevel(LevelTitleScreen());
    return super.onLoad();
  }

  // Swaps current level with given level
  void loadLevel(Component levelComponent) {
    _currentLevel?.removeFromParent();
    _currentLevel = levelComponent;
    add(_currentLevel!);
  }
}
