import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:superconversionhero/actors/background.dart';
import 'package:superconversionhero/constants/constants.dart';
import 'package:superconversionhero/levels_game.dart';
import 'package:flame/image_composition.dart';
import 'package:flutter/services.dart';

import 'package:flame/extensions.dart';
import '../actors/player.dart';

class GoDownFunnel extends Component with HasGameRef<LevelsGame> {
  final int levelNumber;
  final String levelName;
  final Function next;
  late Rect _levelBounds;
  late SpriteComponent _background;
  late SpriteComponent _superConversionHero;

  GoDownFunnel({
    required this.levelNumber,
    required this.levelName,
    required this.next,
  }) : super();

  @override
  Future<void>? onLoad() async {
    _levelBounds = const Rect.fromLTWH(
      0,
      0,
      kScreenWidth,
      kScreenHeight,
    );

    _spawnActors();

    Future.delayed(
        Duration(
          seconds: 5,
        ), () {
      //next();
    });

    return super.onLoad();
  }

  // This method takes care of spawning
  // all the actors in the game world.
  void _spawnActors() {
    //! Background
    _background = Background(gameRef.overworldBg);
    _background.size = Vector2(kScreenWidth, kScreenHeight);
    add(_background);

    add(TextComponent(
      text: 'You have progressed to\nthe next step in the funnel!',
      textRenderer: kBiggerText,
      anchor: Anchor.center,
      position: Vector2(kScreenWidth / 2, kScreenHeight / 2 - 200),
    ));

    // Pipe
    add(
      SpriteComponent(
        sprite: Sprite(
          gameRef.pipe,
        ),
        anchor: Anchor.bottomCenter,
        position: Vector2(kScreenWidth / 2, kScreenHeight - 136),
        //size: Vector2(300, 400),
        scale: Vector2(0.4, 0.4),
        priority: 100,
      ),
    );
    add(
      SpriteComponent(
        sprite: Sprite(
          gameRef.heroRight,
        ),
        anchor: Anchor.bottomCenter,
        position: Vector2(kScreenWidth / 2 - 20, kScreenHeight - 300),
        scale: Vector2(1.5, 1.5),
        //size: Vector2(300, 400),
        //  scale: Vector2(0.5, 0.5),
      ),
    );
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (keysPressed.contains(LogicalKeyboardKey.space)) {
      //TODO: Go to level 1 stay on site

    }
    return true;
  }
}
