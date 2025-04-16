import '../models/adventure.dart';
import '../models/scenario.dart'; // Needed for creating new adventures

/// Abstract class defining the contract for managing adventure data.
abstract class AdventureService {
  /// Retrieves the list of ongoing adventures for the current user.
  Future<List<Adventure>> getOngoingAdventures();

  /// Retrieves a specific ongoing adventure by its ID.
  /// Returns null if the adventure is not found.
  Future<Adventure?> getAdventure(String adventureId);

  /// Creates a new adventure based on a selected scenario.
  ///
  /// Takes a [Scenario] object as input.
  /// Returns the newly created [Adventure].
  Future<Adventure> createNewAdventure(Scenario scenario);

  /// Saves the current state of an ongoing adventure.
  Future<void> saveAdventure(Adventure adventure);

  /// Deletes an adventure, typically when it's completed or abandoned.
  Future<void> deleteAdventure(String adventureId);
}