import 'package:flame/components.dart';
import 'package:flame/image_composition.dart';

import '../constants/constants.dart';

class Background extends SpriteComponent {
  Background(Image image)
      : super.fromImage(
          image,
          size: Vector2(
            kScreenWidth,
            kScreenHeight,
          ),
        );
}
