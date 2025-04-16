import '../models/scenario.dart';

/// Abstract class defining the contract for fetching scenario data from the backend.
/// This backend can be real (like Firebase) or simulated (reading local files).
abstract class BackendService {
  /// Fetches the list of available scenarios.
  ///
  /// Returns a list of [Scenario] objects.
  /// Throws an exception if fetching fails.
  Future<List<Scenario>> fetchScenarios();

  // Add other backend-related methods if needed in the future,
  // e.g., fetchUserDetails(), saveFeedback(), etc.
}