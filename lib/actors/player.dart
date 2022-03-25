import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/image_composition.dart';
import 'package:flame/input.dart';
import 'package:flame_audio/flame_audio.dart';

import 'package:flutter/services.dart';
import 'package:superconversionhero/actors/platform.dart';
import 'package:superconversionhero/actors/product_page.dart';

// Represents a player in the game world.
class Player extends SpriteComponent
    with HasHitboxes, Collidable, KeyboardHandler {
  int _hAxisInput = 0;
  bool _jumpInput = false;
  bool _isOnGround = false;
  bool freeze = false;

  double gravity; //30;
  double jumpSpeed; // = 800;
  final double _fallDown = 800;
  double moveSpeed; // = 400;

  final Vector2 _up = Vector2(0, -1);
  final Vector2 _velocity = Vector2.zero();

  // Limits for clamping player.
  late Vector2 _minClamp;
  late Vector2 _maxClamp;

  // Callbacks to levels
  final Function decrementAttentionSpan;
  final void Function(int) incrementPoints;
  bool isMovableSideways;

  Player(
    Image image, {
    required Rect levelBounds,
    required this.decrementAttentionSpan,
    required this.incrementPoints,
    this.jumpSpeed = 800,
    this.moveSpeed = 400,
    this.gravity = 30,
    this.isMovableSideways = true,
    Vector2? position,
    Vector2? size,
    Vector2? scale,
    double? angle,
    Anchor? anchor,
    int? priority,
  }) : super.fromImage(
          image,
          srcPosition: Vector2.zero(),
          srcSize: Vector2.all(140),
          position: position,
          size: Vector2(140, 140),
          scale: scale,
          angle: angle,
          anchor: anchor,
          priority: 10,
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
    addHitbox(HitboxCircle());
    //addHitbox(HitboxRectangle(relation: Vector2(1, 1.0)));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (freeze) {
      return;
    }
    // Modify components of velocity based on
    // inputs and gravity.
    _velocity.x = _hAxisInput * moveSpeed;
    _velocity.y += gravity;

    // Allow jump only if jump input is pressed
    // and player is already on ground.
    if (_jumpInput) {
      if (_isOnGround) {
        _velocity.y = -jumpSpeed;
        _isOnGround = false;
      }
      _jumpInput = false;
    }

    // Clamp velocity along y to avoid player tunneling
    // through platforms at very high velocities.
    _velocity.y = _velocity.y.clamp(-jumpSpeed, _fallDown /* default: 150 */);

    // delta movement = velocity * time
    position += _velocity * dt;

    // Keeps player within level bounds.
    position.clamp(_minClamp, _maxClamp);

    // Flip player if needed.
    if (_hAxisInput < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
    } else if (_hAxisInput > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
    }

    super.update(dt);
  }

  bool _isPlayingJump = false;
  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    _hAxisInput = 0;
    if (isMovableSideways) {
      _hAxisInput +=
          keysPressed.contains(LogicalKeyboardKey.arrowLeft) ? -1 : 0;
      _hAxisInput +=
          keysPressed.contains(LogicalKeyboardKey.arrowRight) ? 1 : 0;
    }
    _jumpInput = keysPressed.contains(LogicalKeyboardKey.space);
    if (_isOnGround && keysPressed.contains(LogicalKeyboardKey.space)) {
      FlameAudio.play('jump.mp3');
      /*  Future.delayed(Duration(seconds: 2), () {
        _isPlayingJump = false;
      }); */
    }

    return true;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    if (other is PlatformHitbox && other.type != 'playerholding') {
      if (intersectionPoints.length == 2) {
        // Calculate the collision normal and separation distance.
        final mid = (intersectionPoints.elementAt(0) +
                intersectionPoints.elementAt(1)) /
            2;

        final collisionNormal = absoluteCenter - mid;
        final separationDistance = (size.x / 2) - collisionNormal.length;
        collisionNormal.normalize();

        // If collision normal is almost upwards,
        // player must be on ground.
        if (_up.dot(collisionNormal) > 0.9) {
          _isOnGround = true;
        }

        // Resolve collision by moving player along
        // collision normal by separation distance.
        position += collisionNormal.scaled(separationDistance);
      }
    }

    if (other is ProductPage) {
      print('Collided with product page');
      if (other.isRelevantProduct == false) {
        decrementAttentionSpan();
      }
      if (other.hasBeenViewed == false) {
        //TODO: Add to viewed counter

        //TODO: Add to
        if (other.isRelevantProduct == true) {
          print('Is relevant product!');
          if (other.productId != null) {
            incrementPoints(other.productId);
          }
        }
        other.hasBeenViewed = true;
      }
    }

    super.onCollision(intersectionPoints, other);
  }
}
