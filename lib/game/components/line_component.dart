import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// A custom Flame component for drawing a series of connected lines.
/// This class is not part of the standard Flame library but is provided
/// as a utility for drawing lines between points.
class LineComponent extends Component {
  LineComponent(this.points, this.paint);

  List<Vector2> points; // Made mutable to allow updates
  final Paint paint;
  final Path path = Path(); // Path is used for efficient drawing

  @override
  void update(double dt) {
    // Rebuild the path every update to reflect changes in points
    path
      ..reset() // Clear previous path
      ..addPolygon(
        points.map((p) => p.toOffset()).toList(growable: false),
        false, // 'false' means don't close the polygon (draw lines, not a filled shape)
      );
  }

  @override
  void render(Canvas canvas) {
    // Draw each line segment individually
    for (var i = 0; i < points.length - 1; ++i) {
      canvas.drawLine(points[i].toOffset(), points[i + 1].toOffset(), paint);
    }
  }
}
