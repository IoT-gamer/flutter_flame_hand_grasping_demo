import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_bloc/flame_bloc.dart';

import '../cubit/hand_tracking_cubit.dart';
import 'components/hand_visualizer.dart';
import 'components/water_bottle.dart';
import 'components/status.dart';
import '../models/hand_landmark.dart';

class HandGraspingGame extends FlameGame
    with HasGameReference<HandGraspingGame> {
  final HandTrackingCubit handTrackingCubit;
  late final HandGraspingWorld handGraspingWorld;
  late final double gameWidth;
  late final double gameHeight;

  HandGraspingGame({required this.handTrackingCubit});

  @override
  Future<void> onLoad() async {
    // Determine game dimensions based on the largest screen dimension
    final size = game.size;
    if (size.x > size.y) {
      gameWidth = size.x;
      gameHeight = size.y;
    } else {
      gameWidth = size.y;
      gameHeight = size.x;
    }

    // Set up camera with fixed resolution to match game dimensions
    camera = CameraComponent.withFixedResolution(
      width: gameWidth,
      height: gameHeight,
    );
    handGraspingWorld = HandGraspingWorld();
    world = handGraspingWorld;
  }
}

class HandGraspingWorld extends World
    with HasCollisionDetection, HasGameReference<HandGraspingGame> {
  final Status status = Status();
  late WaterBottle waterBottle;
  late HandVisualizer handVisualizer;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    await add(status);

    // Define which landmarks should have hitboxes
    final Set<HandLandmark> interactiveLandmarks = {
      HandLandmark.INDEX_FINGER_TIP,
      HandLandmark.THUMB_TIP,
      // Add other landmarks you want to be interactive here
    };

    waterBottle = WaterBottle();
    await add(waterBottle);

    await add(
      FlameBlocProvider<HandTrackingCubit, HandTrackingState>.value(
        value: game.handTrackingCubit,
        children: [
          handVisualizer = HandVisualizer(
            landmarksWithHitboxes: interactiveLandmarks,
          ), // Pass the set
        ],
      ),
    );
  }
}
