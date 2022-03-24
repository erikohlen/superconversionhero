import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:superconversionhero/actors/background.dart';
import 'package:superconversionhero/constants/constants.dart';
import 'package:superconversionhero/levels_game.dart';
import 'package:flame/image_composition.dart';
import 'package:flutter/services.dart';

import 'package:flame/extensions.dart';
import '../actors/player.dart';

class LevelTitleScreen extends Component
    with HasGameRef<LevelsGame>, KeyboardHandler {
  final Function handleNextScreen;
  late Player _player;
  late Rect _levelBounds;
  late SpriteComponent _background;
  late SpriteComponent _superConversionHero;

  LevelTitleScreen({required this.handleNextScreen}) : super();

  @override
  Future<void>? onLoad() async {
    _levelBounds = const Rect.fromLTWH(
      0,
      0,
      kScreenWidth,
      kScreenHeight,
    );

    _spawnActors();
    print('Inside title screen level');
    return super.onLoad();
  }

  // This method takes care of spawning
  // all the actors in the game world.
  void _spawnActors() {
    _background = Background(gameRef.overworldBg);
    _background.size = Vector2(kScreenWidth, kScreenHeight);
    add(_background);
    add(SpriteComponent(
      sprite: Sprite(
        gameRef.superConversionHero,
      ),
      anchor: Anchor.topCenter,
      position: Vector2(kScreenWidth / 2, 100),
    ));
    add(SpriteComponent(
      sprite: Sprite(
        gameRef.heroRight,
      ),
      anchor: Anchor.bottomCenter,
      position: Vector2(
        kScreenWidth / 2 - 200,
        kScreenHeight - 136,
      ),
    ));
    add(TextComponent(
      text: 'Press "Space" to start',
      textRenderer: kRegular,
      anchor: Anchor.topCenter,
      position: Vector2(kScreenWidth / 2, 540),
    ));
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    print('Key pressed!');
    if (keysPressed.contains(LogicalKeyboardKey.space)) {
      //TODO: Go to level 1 stay on site
      handleNextScreen();
    }

    return true;
  }
}
