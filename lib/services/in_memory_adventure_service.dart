import 'dart:math'; // For random ID generation (temporary)

import '../models/adventure.dart';
import '../models/game_state.dart';
import '../models/message.dart';
import '../models/scenario.dart';
import 'adventure_service.dart';

/// Simulated implementation of [AdventureService] that stores adventures
/// in memory. Data will be lost when the app restarts.
class InMemoryAdventureService implements AdventureService {
  // Use a Map to store adventures, keyed by their unique ID.
  final Map<String, Adventure> _adventures = {};
  int _nextId = 1; // Simple counter for unique IDs in this simulation

  @override
  Future<List<Adventure>> getOngoingAdventures() async {
    // Simply return all adventures currently stored in memory.
    await Future.delayed(const Duration(milliseconds: 50)); // Simulate network delay
    return _adventures.values.toList();
  }

  @override
  Future<Adventure?> getAdventure(String adventureId) async {
    await Future.delayed(const Duration(milliseconds: 30)); // Simulate delay
    return _adventures[adventureId];
  }

  @override
  Future<Adventure> createNewAdventure(Scenario scenario) async {
    await Future.delayed(const Duration(milliseconds: 100)); // Simulate delay

    // Generate a unique ID for the new adventure
    final newId = 'adv_${_nextId++}_${DateTime.now().millisecondsSinceEpoch}';

    // Create the initial adventure state
    final newAdventure = Adventure(
      id: newId,
      scenarioId: scenario.id,
      scenarioTitle: scenario.title, // Store title for easy access
      progress: "Starting...", // Initial progress indicator
      conversationHistory: [
        // Optionally add an initial AI message here if needed
        // Message(sender: 'AI', content: 'Welcome to "${scenario.title}"!', timestamp: DateTime.now()),
      ],
      gameState: GameState(
        currentScene: 'intro', // Default starting scene ID
        characterData: {}, // Empty character data initially
      ),
    );

    _adventures[newId] = newAdventure;
    print("Created Adventure: ${newAdventure.id} for Scenario: ${scenario.title}");
    return newAdventure;
  }

  @override
  Future<void> saveAdventure(Adventure adventure) async {
    await Future.delayed(const Duration(milliseconds: 80)); // Simulate delay
    if (_adventures.containsKey(adventure.id)) {
      _adventures[adventure.id] = adventure; // Update existing adventure
      print("Saved Adventure: ${adventure.id}");
    } else {
      // Handle case where adventure to save doesn't exist (optional)
      print("Warning: Attempted to save non-existent adventure: ${adventure.id}");
      // Optionally add it: _adventures[adventure.id] = adventure;
    }
  }

  @override
  Future<void> deleteAdventure(String adventureId) async {
    await Future.delayed(const Duration(milliseconds: 60)); // Simulate delay
    if (_adventures.containsKey(adventureId)) {
      _adventures.remove(adventureId);
      print("Deleted Adventure: $adventureId");
    } else {
      print("Warning: Attempted to delete non-existent adventure: $adventureId");
    }
  }
}