/// Abstract class defining the contract for managing instructions content
/// and first launch status.
abstract class InstructionsService {
  /// Retrieves the formatted instructions content.
  Future<String> getInstructionsContent();

  /// Checks if the app is being launched for the first time.
  Future<bool> isFirstLaunch();

  /// Marks the first launch sequence as completed.
  Future<void> setFirstLaunchCompleted();
}