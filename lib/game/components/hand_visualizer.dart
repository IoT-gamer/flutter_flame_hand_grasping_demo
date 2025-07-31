import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';

import '../../cubit/hand_tracking_cubit.dart';
import '../../models/hand_connections.dart';
import '../../models/hand_landmark.dart';
import '../hand_grasping_game.dart';
import 'hand_connection_component.dart';
import 'hand_landmark_component.dart';

/// A component responsible for visualizing hand landmarks and connections.
class HandVisualizer extends Component
    with
        FlameBlocListenable<HandTrackingCubit, HandTrackingState>,
        HasGameReference<HandGraspingGame> {
  final Map<HandLandmark, HandLandmarkComponent> _landmarkComponents = {};
  final List<HandConnectionComponent> _connectionComponents = [];
  static const double _smoothingFactor = 0.3;

  // A property to define which landmarks should have hitboxes
  final Set<HandLandmark> landmarksWithHitboxes;

  HandVisualizer({this.landmarksWithHitboxes = const {}}) : super();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    children.register<HandLandmarkComponent>();

    await game.handTrackingCubit.startTracking();

    // Initialize all landmark components (invisible initially)
    for (final landmarkType in HandLandmark.values) {
      final landmarkComponent = HandLandmarkComponent(
        landmarkType: landmarkType,
        // Initial position is offscreen
        position: Vector2(game.gameWidth * 2, game.gameHeight * 2),
        radius: 8.0, // Adjust radius as needed
        paint: Paint()..color = Colors.greenAccent.withAlpha(200),
        hasHitbox: landmarksWithHitboxes.contains(landmarkType),
      );
      _landmarkComponents[landmarkType] = landmarkComponent;
      add(landmarkComponent);
    }

    // Initialize all connection components
    for (final connection in HandConnections.connections) {
      final startLandmarkType = connection[0];
      final endLandmarkType = connection[1];

      final startComponent = _landmarkComponents[startLandmarkType]!;
      final endComponent = _landmarkComponents[endLandmarkType]!;
      final connectionComponent = HandConnectionComponent(
        startLandmark: startComponent,
        endLandmark: endComponent,
        paint: Paint()
          ..color = Colors.blueAccent.withAlpha(180)
          ..strokeWidth = 3.0
          ..strokeCap = StrokeCap.round,
      );
      _connectionComponents.add(connectionComponent);
      add(connectionComponent);
    }

    // Initially hide all components until hand is detected
    _toggleVisibility(false);
  }

  /// Toggles the visibility of all landmark and connection components.
  void _toggleVisibility(bool visible) {
    for (final component in _landmarkComponents.values) {
      component.isVisible = visible;
    }
    for (final component in _connectionComponents) {
      component.isVisible = visible;
    }
  }

  @override
  void onNewState(HandTrackingState state) {
    if (state is HandTrackingSuccess) {
      if (state.hands.isNotEmpty) {
        game.handGraspingWorld.status.text = ''; // Clear status message
        _toggleVisibility(true); // Show components

        final hand = state.hands.first; // Assuming only one hand for now

        // Update each landmark component's position
        for (final landmarkType in HandLandmark.values) {
          final landmarkData = hand.landmarks[landmarkType.value];
          // Scale and flip X-axis for correct visualization
          final scaledX = game.gameWidth / 2 - landmarkData.x * game.gameWidth;
          final scaledY =
              landmarkData.y * game.gameHeight - game.gameHeight / 2;
          final targetPosition = Vector2(scaledX, scaledY);

          final component = _landmarkComponents[landmarkType]!;

          // Apply smoothing
          if (component.position == Vector2.zero()) {
            // First update, set directly
            component.position = targetPosition;
          } else {
            // Smoothly interpolate to the target position
            component.position.lerp(targetPosition, _smoothingFactor);
          }
        }
      } else {
        game.handGraspingWorld.status.text = 'no hand detected';
        _toggleVisibility(false); // Hide components if no hand
      }
    } else if (state is HandTrackingLoading) {
      game.handGraspingWorld.status.text = 'Initializing hand tracking...';
      _toggleVisibility(false);
    } else if (state is HandTrackingFailure) {
      game.handGraspingWorld.status.text = 'Error: ${state.error}';
      _toggleVisibility(false);
    } else if (state is HandTrackingInitial) {
      game.handGraspingWorld.status.text = 'Waiting to start hand tracking...';
      _toggleVisibility(false);
    }
  }
}
