import 'package:flutter/foundation.dart';

import '../services/instructions_service.dart';

// TODO: Import navigation service or context access mechanism

class InstructionsScreenController with ChangeNotifier {
  final InstructionsService _instructionsService;

  InstructionsScreenController({required InstructionsService instructionsService})
      : _instructionsService = instructionsService {
    // Load content when controller is created
    loadInstructionsScreen();
  }

  // --- State ---
  String _instructionsContent = "";
  bool _isLoading = false;
  String? _errorMessage;

  // --- Getters for View ---
  String get instructionsContent => _instructionsContent;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // --- Actions ---

  /// Loads the instructions content.
  Future<void> loadInstructionsScreen() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _instructionsContent = await _instructionsService.getInstructionsContent();
    } catch (e) {
      if (kDebugMode) {
        print("Error loading instructions content: $e");
      }
      _errorMessage = "Failed to load instructions.";
      _instructionsContent = "Error loading instructions."; // Show error in content
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Handles the close action, potentially marking first launch as complete.
  Future<void> handleCloseAction() async {
    try {
      // Check if it was the first launch before marking complete
      // (This logic might be better placed depending on navigation flow)
      bool wasFirstLaunch = await _instructionsService.isFirstLaunch();
      if (wasFirstLaunch) {
        await _instructionsService.setFirstLaunchCompleted();
        if (kDebugMode) {
          print("Marked first launch as completed.");
        }
      }
    } catch (e) {
       if (kDebugMode) {
          print("Error marking first launch complete: $e");
        }
    }
    // Navigation logic (e.g., Navigator.pop(context)) should be handled
    // in the View or a dedicated navigation service based on the architecture.
     if (kDebugMode) {
        print("Controller: Close action handled.");
      }
  }

  // handleBackAction is likely the same as handleCloseAction for this screen
  Future<void> handleBackAction() async {
    await handleCloseAction();
  }
}