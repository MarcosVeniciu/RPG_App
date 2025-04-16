import 'message.dart'; // Assuming message.dart will be created
import 'game_state.dart'; // Assuming game_state.dart will be created

/// Represents an ongoing or completed adventure.
class Adventure {
  final String id; // Unique identifier for the adventure
  final String scenarioId; // Identifier of the scenario being played
  final String scenarioTitle; // Title of the scenario (denormalized for easy display)
  int progress; // Progress indicator (0-100) - mutable
  List<Message> conversationHistory; // List of messages in the chat - mutable
  GameState gameState; // Current state of the game - mutable

  Adventure({
    required this.id,
    required this.scenarioId,
    required this.scenarioTitle,
    required this.progress, // Deve ser um valor entre 0 e 100
    required this.conversationHistory,
    required this.gameState,
  });

  // TODO: Add fromJson and toJson methods if needed for persistence
  // Example (needs Message.fromJson/toJson and GameState.fromJson/toJson):
  /*
  factory Adventure.fromJson(Map<String, dynamic> json) {
    return Adventure(
      id: json['id'] as String,
      scenarioId: json['scenarioId'] as String,
      scenarioTitle: json['scenarioTitle'] as String,
      progress: int.parse(json['progress']), // Converte string para int
      conversationHistory: (json['conversationHistory'] as List<dynamic>? ?? [])
          .map((item) => Message.fromJson(item as Map<String, dynamic>))
          .toList(),
      gameState: GameState.fromJson(json['gameState'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'scenarioId': scenarioId,
      'scenarioTitle': scenarioTitle,
      'progress': progress,
      'conversationHistory': conversationHistory.map((msg) => msg.toJson()).toList(),
      'gameState': gameState.toJson(),
    };
  }
  */
}