import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:collection/collection.dart';

import '../../models/hand_landmark.dart';
import '../hand_grasping_game.dart';
import 'hand_landmark_component.dart';

class WaterBottle extends SpriteComponent
    with
        CollisionCallbacks,
        HasGameReference<HandGraspingGame>,
        HasWorldReference<HandGraspingWorld> {
  static const _waterBottleImagePath = 'water_bottle.png';
  static const _crushedWaterBottleImagePath = 'water_bottle_crushed.png';

  late Sprite _waterBottleSprite;
  late Sprite _crushedWaterBottleSprite;
  bool fingersTouchingEachOther = false;

  // Use Sets to keep track of currently colliding landmarks with the WaterBottle
  final Set<HandLandmarkComponent> _collidingFingerTipsWithPlayer = {};

  // Flag to indicate if the WaterBottle is being "grabbed" (both index and thumb colliding)
  bool _isGrabbed = false;

  // Flag to indicate the WaterBottle is being "crushed"
  bool _isCrushed = false;

  WaterBottle() : super(position: Vector2.all(0), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final idleImage = await game.images.load(_waterBottleImagePath);
    _waterBottleSprite = Sprite(idleImage);

    final fingersTouchingImage = await game.images.load(
      _crushedWaterBottleImagePath,
    );
    _crushedWaterBottleSprite = Sprite(fingersTouchingImage);

    final imageAspectRatio = idleImage.width / idleImage.height;
    angle = 90 * pi / 180; // rotate 90 degrees
    size = Vector2(
      200 * imageAspectRatio,
      200,
    ); // Set size based on image aspect ratio

    sprite = _waterBottleSprite;
    // Add a RectangleHitbox to the waterBottle sprite
    // This hitbox will detect collisions with the CircleHitboxes of the HandLandmarkComponents
    add(
      RectangleHitbox(
        size: Vector2(size.x * 1.2, size.y), // Expand a bit
        anchor: Anchor.center,
        position: Vector2(x + size.x / 2, y + size.y / 2),
        isSolid: true,
        collisionType: CollisionType.active,
      ),
    );

    // debugMode = true; // View hitbox
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Determine if the sprite is being grabbed based on currently colliding finger tips
    _isGrabbed =
        _collidingFingerTipsWithPlayer.length == 2 &&
        _collidingFingerTipsWithPlayer.any(
          (l) => l.landmarkType == HandLandmark.INDEX_FINGER_TIP,
        ) &&
        _collidingFingerTipsWithPlayer.any(
          (l) => l.landmarkType == HandLandmark.THUMB_TIP,
        );

    // Determine if the sprite is being crushed based on colliding finger tips
    _isCrushed = fingersTouchingEachOther && _isGrabbed;

    // Update sprite based on state priority
    if (_isCrushed) {
      sprite = _crushedWaterBottleSprite;
    } else {
      sprite = _waterBottleSprite;
    }

    // Move sprite if grabbed
    if (_isGrabbed) {
      Vector2 sumPositions = Vector2.zero();
      int count = 0;

      // Get the latest positions of the relevant landmarks from the game world
      // Ensure we get the *actual* latest positions from the world, not just from the collision set
      final indexTip = game.handGraspingWorld.handVisualizer.children
          .query<HandLandmarkComponent>()
          .firstWhereOrNull(
            (l) =>
                l.landmarkType == HandLandmark.INDEX_FINGER_TIP && l.isVisible,
          );
      final thumbTip = game.handGraspingWorld.handVisualizer.children
          .query<HandLandmarkComponent>()
          .firstWhereOrNull(
            (l) => l.landmarkType == HandLandmark.THUMB_TIP && l.isVisible,
          );

      if (indexTip != null) {
        sumPositions += indexTip.position;
        count++;
      }
      if (thumbTip != null) {
        sumPositions += thumbTip.position;
        count++;
      }

      if (count > 0) {
        position.lerp(
          sumPositions / count.toDouble(),
          0.5,
        ); // Smoothly interpolate
      }
    }
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is HandLandmarkComponent) {
      if (other.landmarkType == HandLandmark.INDEX_FINGER_TIP ||
          other.landmarkType == HandLandmark.THUMB_TIP) {
        _collidingFingerTipsWithPlayer.add(other);
      }
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    if (other is HandLandmarkComponent) {
      if (other.landmarkType == HandLandmark.INDEX_FINGER_TIP ||
          other.landmarkType == HandLandmark.THUMB_TIP) {
        _collidingFingerTipsWithPlayer.remove(other);
      }
    }
  }
}
