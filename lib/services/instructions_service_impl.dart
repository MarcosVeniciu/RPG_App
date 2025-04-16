import 'package:shared_preferences/shared_preferences.dart';

import 'instructions_service.dart';

/// Implementation of [InstructionsService] using SharedPreferences
/// for first launch flag and hardcoded content for simplicity.
class InstructionsServiceImpl implements InstructionsService {
  static const String _firstLaunchKey = 'hasLaunchedBefore';

  // Hardcoded instructions content for this simulation.
  // In a real app, this might come from assets, a remote config, etc.
  final String _instructionsContent = """
# Welcome to the RPG Adventure App!

## Getting Started

*   **Main Screen:** This is your hub. Find ongoing adventures or start new ones.
*   **Ongoing Adventures:** See adventures you've already started. Hit "Continue" to jump back in.
*   **Scenario Options:** Browse available stories (fantasy, sci-fi, etc.). Read the description and hit "Start" to begin a new journey.

## Gameplay (Chat Screen)

*   **Interaction:** The game unfolds like a chat. Read the AI's narration and type your actions or dialogue in the input field.
*   **Character Creation:** For new adventures, the AI will guide you through creating a character via chat prompts. Don't worry, characters are temporary for each adventure!
*   **Dice Rolls (D20):** Sometimes, you'll need to roll the dice! Tap the "Dice Roll" button when prompted by the story or when you want to attempt a challenging action. The AI will describe the outcome based on your roll.
*   **Audio:** Use the toggle button to enable/disable voice narration (Text-to-Speech) and potentially voice input (Speech-to-Text) if implemented.

## Subscriptions & Purchases

*   **Tiers:** Check the "Subscription" screen (from the Main Screen) for different monthly adventure limits.
*   **Running Low?:** If you use up your monthly adventures, you can buy individual extra adventures on the Subscription screen.

Have fun exploring!
""";

  @override
  Future<String> getInstructionsContent() async {
    // Simulate potential delay (e.g., loading from assets)
    await Future.delayed(const Duration(milliseconds: 20));
    return _instructionsContent;
  }

  @override
  Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    // If the key doesn't exist, it's the first launch (default to true).
    return !(prefs.getBool(_firstLaunchKey) ?? false);
  }

  @override
  Future<void> setFirstLaunchCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_firstLaunchKey, true);
  }
}