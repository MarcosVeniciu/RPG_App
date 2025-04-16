import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rpg_app/models/scenario.dart';
import 'package:rpg_app/services/backend_service.dart';
import 'package:rpg_app/services/scenario_service.dart';
import 'package:rpg_app/services/scenario_service_impl.dart';

// Mock class for BackendService
class MockBackendService extends Mock implements BackendService {}

void main() {
  late MockBackendService mockBackendService;
  late ScenarioService scenarioService;

  setUp(() {
    mockBackendService = MockBackendService();
    scenarioService = ScenarioServiceImpl(backendService: mockBackendService);
    
    // Register fallback values for null-safety
    registerFallbackValue(<Scenario>[]);
  });

  group('ScenarioServiceImpl Tests with Mocktail', () {
    test('should return scenarios when backend fetch succeeds', () async {
      // Arrange
      final expectedScenarios = [
        Scenario(
          id: '1',
          title: 'Dominus and Dragons',
          genre: 'Fantasia',
          description: 'A classic fantasy adventure'
        )
      ];
      
      // Setup mock behavior with proper typing
      when(() => mockBackendService.fetchScenarios())
          .thenAnswer((_) async => expectedScenarios as List<Scenario>);

      // Act
      final result = await scenarioService.getAvailableScenarios();

      // Assert
      expect(result, equals(expectedScenarios));
      verify(() => mockBackendService.fetchScenarios()).called(1);
    });

    test('should return empty list when backend fetch fails', () async {
      // Arrange
      when(() => mockBackendService.fetchScenarios())
          .thenThrow(Exception('Network error'));

      // Act
      final result = await scenarioService.getAvailableScenarios();

      // Assert
      expect(result, isEmpty);
      verify(() => mockBackendService.fetchScenarios()).called(1);
    });
  });
}