/// Maintains the current state of an adventure's gameplay.
class GameState {
  String currentScene; // Identifier of the current scene - mutable
  Map<String, String> characterData; // Temporary character data - mutable

  GameState({
    required this.currentScene,
    required this.characterData,
  });

  // TODO: Add fromJson and toJson methods if needed for persistence
  /*
  factory GameState.fromJson(Map<String, dynamic> json) {
    return GameState(
      currentScene: json['currentScene'] as String,
      // Ensure characterData is correctly parsed as Map<String, String>
      characterData: Map<String, String>.from(json['characterData'] as Map? ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentScene': currentScene,
      'characterData': characterData,
    };
  }
  */
}