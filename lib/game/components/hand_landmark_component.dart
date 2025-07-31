import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

import '../../models/hand_landmark.dart';
import '../hand_grasping_game.dart';

/// A [CircleComponent] representing a single hand landmark.
class HandLandmarkComponent extends CircleComponent
    with HasVisibility, CollisionCallbacks, HasGameReference<HandGraspingGame> {
  final HandLandmark landmarkType;
  final bool hasHitbox;

  HandLandmarkComponent({
    required this.landmarkType,
    super.position,
    super.radius,
    Paint? paint,
    this.hasHitbox = false,
  }) : super(paint: paint ?? (BasicPalette.green.withAlpha(200).paint()));

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    radius = 5.0; // Default radius if not provided

    if (hasHitbox) {
      add(
        CircleHitbox(radius: radius * 2.5)
          ..isSolid = true
          ..collisionType = CollisionType.active,
      );
    }

    // debugMode = true; // Enable debug mode for collision visualization
  }

  /// Updates the position of the landmark component.
  void updatePosition(Vector2 newPosition) {
    position = newPosition;
  }

  // Implement onCollisionStart, onCollisionEnd, onCollision
  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is HandLandmarkComponent) {
      // Example: Change color when two specific landmarks collide
      if ((landmarkType == HandLandmark.INDEX_FINGER_TIP &&
              other.landmarkType == HandLandmark.THUMB_TIP) ||
          (landmarkType == HandLandmark.THUMB_TIP &&
              other.landmarkType == HandLandmark.INDEX_FINGER_TIP)) {
        paint.color = Colors.red; // Change color to red on collision
        game.handGraspingWorld.waterBottle.fingersTouchingEachOther = true;
      }
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    if (other is HandLandmarkComponent) {
      if ((landmarkType == HandLandmark.INDEX_FINGER_TIP &&
              other.landmarkType == HandLandmark.THUMB_TIP) ||
          (landmarkType == HandLandmark.THUMB_TIP &&
              other.landmarkType == HandLandmark.INDEX_FINGER_TIP)) {
        paint.color = Colors.greenAccent.withAlpha(200); // Revert color
        game.handGraspingWorld.waterBottle.fingersTouchingEachOther = false;
      }
    }
  }
}
