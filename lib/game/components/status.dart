import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flame/text.dart';

import '../hand_grasping_game.dart';

class Status extends TextComponent with HasGameReference<HandGraspingGame> {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    text = 'Initializing hand tracking...'; // Initial status
    // Position the status text at the top-left corner
    position = Vector2(-game.gameWidth / 2 + 20, -game.gameHeight / 2 + 20);
    textRenderer = TextPaint(
      style: const TextStyle(
        fontSize: 24.0,
        color: Color.fromARGB(255, 255, 255, 255),
      ),
    );
  }
}
