import 'package:flame/components.dart';
import 'package:superconversionhero/actors/background.dart';
import 'package:superconversionhero/constants.dart';
import 'package:superconversionhero/levels_game.dart';

import 'package:flame/extensions.dart';
import '../actors/player.dart';

class LevelTitleScreen extends Component with HasGameRef<LevelsGame> {
  late Player _player;
  late Rect _levelBounds;
  late SpriteComponent _background;
  late SpriteComponent _superConversionHero;

  LevelTitleScreen() : super();

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
}
