import '../models/scenario.dart';
import 'backend_service.dart'; // Depends on the BackendService interface
import 'scenario_service.dart';

/// Implementation of [ScenarioService] that uses a [BackendService]
/// to fetch the available scenarios.
class ScenarioServiceImpl implements ScenarioService {
  final BackendService _backendService;

  /// Creates an instance of [ScenarioServiceImpl].
  ///
  /// Requires a [BackendService] instance (which could be the simulated one
  /// or a real one later) to be injected.
  ScenarioServiceImpl({required BackendService backendService})
      : _backendService = backendService;

  @override
  Future<List<Scenario>> getAvailableScenarios() async {
    try {
      // Delegate fetching to the injected backend service
      final scenarios = await _backendService.fetchScenarios();
      // TODO: Add caching logic here if needed in the future
      return scenarios;
    } catch (e) {
      // Handle or rethrow the exception from the backend service
      print("Error fetching available scenarios: $e"); // Basic logging
      // Depending on requirements, might return empty list or rethrow
      // throw Exception('Failed to get available scenarios: $e');
      return []; // Return empty list on error for now
    }
  }
}