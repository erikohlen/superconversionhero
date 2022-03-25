import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/image_composition.dart';
import 'package:flame/input.dart';

// Represents a player in the game world.
class ProductPage extends SpriteComponent
    with HasHitboxes, Collidable, KeyboardHandler {
  final double _gravity = 10;
  final Vector2 _up = Vector2(0, -1);
  final Vector2 _velocity = Vector2.zero();

  // Limits for clamping player.
  late Vector2 _minClamp;
  late Vector2 _maxClamp;

  // Product page state
  bool hasBeenViewed = false;
  late bool isRelevantProduct;

  // Product details
  final int productId;

  ProductPage(
    Image image, {
    required Rect levelBounds,
    required this.isRelevantProduct,
    required this.productId,
    Vector2? position,
    Vector2? size,
    Vector2? scale,
    double? angle,
    Anchor? anchor,
    int? priority,
  }) : super.fromImage(
          image,
          srcPosition: Vector2.zero(),
          srcSize: Vector2(276, 325),
          position: position,
          size: size,
          scale: scale,
          angle: angle,
          anchor: anchor,
          priority: priority,
        ) {
    // Since anchor point for player is at the center,
    // min and max clamp limits will have to be adjusted by
    // half-size of player.
    final halfSize = size! / 2;
    _minClamp = levelBounds.topLeft.toVector2() + halfSize;
    _maxClamp = levelBounds.bottomRight.toVector2() - halfSize;
  }

  @override
  Future<void>? onLoad() {
    addHitbox(HitboxRectangle(relation: Vector2(1, 1.0)));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    // Modify components of velocity based on
    // inputs and gravity.

    _velocity.y += _gravity;

    // delta movement = velocity * time
    position += _velocity * dt;

    // Keeps player within level bounds.
    position.clamp(_minClamp, _maxClamp);

    super.update(dt);
  }
}
