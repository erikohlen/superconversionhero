import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:superconversionhero/actors/background.dart';
import 'package:superconversionhero/constants/constants.dart';
import 'package:superconversionhero/levels_game.dart';
import 'package:flame/image_composition.dart';
import 'package:flutter/services.dart';

import 'package:flame/extensions.dart';
import '../actors/player.dart';

class LevelBlackIntro extends Component with HasGameRef<LevelsGame> {
  final int levelNumber;
  final String levelName;
  final Function next;
  late Rect _levelBounds;
  late SpriteComponent _background;
  late SpriteComponent _superConversionHero;

  LevelBlackIntro({
    required this.levelNumber,
    required this.levelName,
    required this.next,
  }) : super();

  @override
  Future<void>? onLoad() async {
    if (FlameAudio.bgm.isPlaying == false) {
      FlameAudio.bgm.play('overworld.mp3');
    }
    _levelBounds = const Rect.fromLTWH(
      0,
      0,
      kScreenWidth,
      kScreenHeight,
    );

    _spawnActors();

    Future.delayed(
        Duration(
          seconds: 3,
        ), () {
      next();
    });

    return super.onLoad();
  }

  // This method takes care of spawning
  // all the actors in the game world.
  void _spawnActors() {
    /* _background = Background(Rect.fromLTWH(left, top, width, height));
    _background.size = Vector2(kScreenWidth, kScreenHeight);
    add(_background); */

    add(TextComponent(
      text: 'World $levelNumber-1',
      textRenderer: kBiggerText,
      anchor: Anchor.center,
      position: Vector2(kScreenWidth / 2, kScreenHeight / 2 - 80),
    ));
    add(TextComponent(
      text: levelName,
      textRenderer: kBiggerText,
      anchor: Anchor.center,
      position: Vector2(kScreenWidth / 2, kScreenHeight / 2 + 80),
    ));
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (keysPressed.contains(LogicalKeyboardKey.space)) {
      //TODO: Go to level 1 stay on site

    }
    return true;
  }
}
