import 'package:flutter/foundation.dart'; // For ChangeNotifier

import '../models/adventure.dart';
import '../models/scenario.dart';
import '../services/adventure_service.dart';
import '../services/scenario_service.dart';
import '../services/instructions_service.dart'; // Needed for first launch check

// TODO: Import navigation service or context access mechanism

class MainScreenController with ChangeNotifier {
  final AdventureService _adventureService;
  final ScenarioService _scenarioService;
  final InstructionsService _instructionsService;

  MainScreenController({
    required AdventureService adventureService,
    required ScenarioService scenarioService,
    required InstructionsService instructionsService,
  })  : _adventureService = adventureService,
        _scenarioService = scenarioService,
        _instructionsService = instructionsService {
    // Optionally load data immediately upon creation
    // loadMainScreen();
  }

  // --- State ---
  List<Adventure> _ongoingAdventures = [];
  List<Scenario> _scenarios = [];
  bool _isLoading = false;
  String? _errorMessage;

  // --- Getters for View ---
  List<Adventure> get ongoingAdventures => _ongoingAdventures;
  List<Scenario> get scenarios => _scenarios;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // --- Actions ---

  /// Loads the main screen data (adventures and scenarios).
  Future<void> loadMainScreen() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); // Notify UI that loading has started

    try {
      // Fetch data in parallel
      final results = await Future.wait([
        _adventureService.getOngoingAdventures(),
        _scenarioService.getAvailableScenarios(),
      ]);

      _ongoingAdventures = results[0] as List<Adventure>;
      _scenarios = results[1] as List<Scenario>;

    } catch (e) {
      if (kDebugMode) {
        print("Error loading main screen data: $e");
      }
      _errorMessage = "Failed to load data. Please try again.";
      // Clear data on error? Optional.
      // _ongoingAdventures = [];
      // _scenarios = [];
    } finally {
      _isLoading = false;
      notifyListeners(); // Notify UI that loading is complete (or failed)
    }
  }

  /// Checks if it's the first launch and triggers navigation if needed.
  Future<void> checkFirstLaunch() async {
     try {
       bool firstLaunch = await _instructionsService.isFirstLaunch();
       if (firstLaunch) {
         if (kDebugMode) {
           print("First launch detected. Navigating to Instructions.");
         }
         // TODO: Implement navigation to InstructionsScreen
         // navigatorKey.currentState?.pushNamed('/instructions'); // Example
         // await _instructionsService.setFirstLaunchCompleted(); // Mark after navigation? Or on screen close?
       }
     } catch (e) {
        if (kDebugMode) {
          print("Error checking first launch status: $e");
        }
     }
  }


  /// Handles tapping the "Continue" button for an adventure.
  void handleContinueAdventure(String adventureId) {
    if (kDebugMode) {
      print("Controller: Continue adventure $adventureId");
    }
    // TODO: Implement navigation to ChatScreen with adventureId
    // navigatorKey.currentState?.pushNamed('/chat', arguments: adventureId);
  }

  /// Handles tapping the "Start" button for a scenario.
  void handleStartNewAdventure(String scenarioId) {
     if (kDebugMode) {
      print("Controller: Start new adventure for scenario $scenarioId");
    }
    // TODO: Implement navigation to ChatScreen, possibly creating the adventure first
    // Adventure newAdventure = await _adventureService.createNewAdventure(findScenarioById(scenarioId));
    // navigatorKey.currentState?.pushNamed('/chat', arguments: newAdventure.id);
  }

  /// Handles tapping the "Subscription" button.
  void handleSubscriptionTapped() {
     if (kDebugMode) {
      print("Controller: Navigate to Subscription Screen");
    }
    // TODO: Implement navigation to SubscriptionScreen
    // navigatorKey.currentState?.pushNamed('/subscription');
  }

  /// Handles tapping the "Instructions" button.
  void handleInstructionsTapped() {
     if (kDebugMode) {
      print("Controller: Navigate to Instructions Screen");
    }
    // TODO: Implement navigation to InstructionsScreen
    // navigatorKey.currentState?.pushNamed('/instructions');
  }

  // Helper to find scenario (optional, might be handled differently)
  // Scenario findScenarioById(String id) => _scenarios.firstWhere((s) => s.id == id);
}