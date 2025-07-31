import 'hand_landmark.dart';

/// Defines the connections between hand landmarks to draw the hand skeleton.
/// Each pair represents a connection between two landmarks.
class HandConnections {
  static const List<List<HandLandmark>> connections = [
    // Thumb
    [HandLandmark.WRIST, HandLandmark.THUMB_CMC],
    [HandLandmark.THUMB_CMC, HandLandmark.THUMB_MCP],
    [HandLandmark.THUMB_MCP, HandLandmark.THUMB_IP],
    [HandLandmark.THUMB_IP, HandLandmark.THUMB_TIP],

    // Index Finger
    [HandLandmark.WRIST, HandLandmark.INDEX_FINGER_MCP],
    [HandLandmark.INDEX_FINGER_MCP, HandLandmark.INDEX_FINGER_PIP],
    [HandLandmark.INDEX_FINGER_PIP, HandLandmark.INDEX_FINGER_DIP],
    [HandLandmark.INDEX_FINGER_DIP, HandLandmark.INDEX_FINGER_TIP],

    // Middle Finger
    [HandLandmark.WRIST, HandLandmark.MIDDLE_FINGER_MCP],
    [HandLandmark.MIDDLE_FINGER_MCP, HandLandmark.MIDDLE_FINGER_PIP],
    [HandLandmark.MIDDLE_FINGER_PIP, HandLandmark.MIDDLE_FINGER_DIP],
    [HandLandmark.MIDDLE_FINGER_DIP, HandLandmark.MIDDLE_FINGER_TIP],

    // Ring Finger
    [HandLandmark.WRIST, HandLandmark.RING_FINGER_MCP],
    [HandLandmark.RING_FINGER_MCP, HandLandmark.RING_FINGER_PIP],
    [HandLandmark.RING_FINGER_PIP, HandLandmark.RING_FINGER_DIP],
    [HandLandmark.RING_FINGER_DIP, HandLandmark.RING_FINGER_TIP],

    // Pinky Finger
    [HandLandmark.WRIST, HandLandmark.PINKY_MCP],
    [HandLandmark.PINKY_MCP, HandLandmark.PINKY_PIP],
    [HandLandmark.PINKY_PIP, HandLandmark.PINKY_DIP],
    [HandLandmark.PINKY_DIP, HandLandmark.PINKY_TIP],

    // Connections between MCPs (palm)
    [HandLandmark.INDEX_FINGER_MCP, HandLandmark.MIDDLE_FINGER_MCP],
    [HandLandmark.MIDDLE_FINGER_MCP, HandLandmark.RING_FINGER_MCP],
    [HandLandmark.RING_FINGER_MCP, HandLandmark.PINKY_MCP],
  ];
}
