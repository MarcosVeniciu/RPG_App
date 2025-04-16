import '../models/adventure.dart';

/// Abstract class defining the contract for interacting with the AI model.
abstract class AIService {
  /// Generates an AI response based on the current adventure state and user input.
  ///
  /// Takes the current [Adventure] and the [userInput] string.
  /// Returns the AI-generated response string.
  /// Throws an exception if the API call fails.
  Future<String> generateResponse({
    required Adventure adventure,
    required String userInput,
    String? model, // Optional model override
  });

  /// Generates an AI response based on a dice roll result and adventure state.
  ///
  /// Takes the current [Adventure] and the [rollResult] integer.
  /// Returns the AI-generated response string describing the outcome.
  /// Throws an exception if the API call fails.
  Future<String> generateDiceRollResponse({
    required Adventure adventure,
    required int rollResult,
    String? model, // Optional model override
  });

  /// Generates the initial character-creation prompt for a new adventure.
  ///
  /// Takes the [scenarioId] or potentially the full [Adventure] object.
  /// Returns the AI-generated starting prompt string.
  /// Throws an exception if the API call fails.
  Future<String> generateInitialPrompt({
    required String scenarioId, // Or Adventure adventure
    String? model, // Optional model override
  });
}