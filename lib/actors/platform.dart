import 'package:flame/geometry.dart';
import 'package:flame/components.dart';

// Represents a platform in the game world.
class PlatformHitbox extends PositionComponent with HasHitboxes, Collidable {
  final String type;
  PlatformHitbox({
    required Vector2 position,
    required Vector2 size,
    required this.type,
    Vector2? scale,
    double? angle,
    Anchor? anchor,
    int? priority,
  }) : super(
          position: position,
          size: size,
          scale: scale,
          angle: angle,
          anchor: anchor,
        );

  @override
  Future<void>? onLoad() {
    // Passive cause we don't want platforms to
    // collide with each other.
    collidableType = CollidableType.passive;
    addHitbox(HitboxRectangle());
    return super.onLoad();
  }
}
