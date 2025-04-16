import '../models/scenario.dart';

/// Abstract class defining the contract for managing scenario data.
abstract class ScenarioService {
  /// Retrieves the list of available scenarios.
  ///
  /// This might involve fetching from a backend or cache.
  Future<List<Scenario>> getAvailableScenarios();
}