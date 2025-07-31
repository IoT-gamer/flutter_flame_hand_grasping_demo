import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

import '../hand_grasping_game.dart';
import 'hand_landmark_component.dart';
import 'line_component.dart';

/// A custom [LineComponent] representing a connection between two hand landmarks.
class HandConnectionComponent extends LineComponent
    with HasVisibility, HasGameReference<HandGraspingGame> {
  final HandLandmarkComponent startLandmark;
  final HandLandmarkComponent endLandmark;

  HandConnectionComponent({
    required this.startLandmark,
    required this.endLandmark,
    Paint? paint,
  }) : super(
         [
           startLandmark.position,
           endLandmark.position,
         ], // Pass initial points to custom LineComponent
         paint ??
             (BasicPalette.blue.withAlpha(150).paint()
               ..strokeWidth =
                   3.0 // Make the line visible
               ..strokeCap = StrokeCap.round),
       );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Update the points list of the custom LineComponent
    points[0] = startLandmark.position;
    points[1] = endLandmark.position;
  }
}
