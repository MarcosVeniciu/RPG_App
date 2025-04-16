import 'package:flutter/foundation.dart';

import '../models/adventure.dart';
import '../models/message.dart';
import '../services/adventure_service.dart';
import '../services/ai_service.dart';
import '../services/dice_roll_service.dart';

// TODO: Import navigation service or context access mechanism

class ChatScreenController with ChangeNotifier {
  final AdventureService _adventureService;
  final AIService _aiService;
  final DiceRollService _diceRollService;

  ChatScreenController({
    required AdventureService adventureService,
    required AIService aiService,
    required DiceRollService diceRollService,
  })  : _adventureService = adventureService,
        _aiService = aiService,
        _diceRollService = diceRollService;

  // --- State ---
  Adventure? _currentAdventure;
  bool _isLoading = false;
  bool _isSending = false; // To disable input while AI responds
  String? _errorMessage;
  bool _isAudioEnabled = false; // Placeholder for audio state

  // --- Getters for View ---
  Adventure? get currentAdventure => _currentAdventure;
  List<Message> get messages => _currentAdventure?.conversationHistory ?? [];
  bool get isLoading => _isLoading;
  bool get isSending => _isSending;
  String? get errorMessage => _errorMessage;
  bool get isAudioEnabled => _isAudioEnabled; // Placeholder

  // --- Actions ---

  /// Loads the chat screen for a given adventure ID.
  /// If adventureId is null, it implies starting a new adventure (needs scenario context).
  /// TODO: Adjust logic if new adventures are started differently (e.g., passing Scenario object).
  Future<void> loadChatScreen(String? adventureId) async {
    if (adventureId == null) {
      // Handle case for starting a new adventure - requires scenario info
      _errorMessage = "Cannot load chat: Adventure ID is missing.";
      if (kDebugMode) print(_errorMessage);
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentAdventure = await _adventureService.getAdventure(adventureId);
      if (_currentAdventure == null) {
        throw Exception("Adventure with ID $adventureId not found.");
      }
      // TODO: If starting new and history is empty, call generateInitialPrompt?
      // if (_currentAdventure!.conversationHistory.isEmpty) { ... }

    } catch (e) {
      if (kDebugMode) {
        print("Error loading chat screen for adventure $adventureId: $e");
      }
      _errorMessage = "Failed to load adventure. Please try again.";
      _currentAdventure = null; // Clear adventure on error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Handles sending a user message and getting the AI response.
  Future<void> handleSendMessage(String text) async {
    if (_currentAdventure == null || _isSending || text.isEmpty) return;

    _isSending = true;
    _errorMessage = null;

    // Add user message immediately to the UI
    final userMessage = Message(
      sender: 'User',
      content: text,
      timestamp: DateTime.now(),
    );
    _currentAdventure!.conversationHistory.add(userMessage);
    notifyListeners(); // Update UI with user message

    try {
      // Get AI response
      final aiResponseContent = await _aiService.generateResponse(
        adventure: _currentAdventure!,
        userInput: text,
      );

      // Add AI message
      final aiMessage = Message(
        sender: 'AI',
        content: aiResponseContent,
        timestamp: DateTime.now(),
      );
      _currentAdventure!.conversationHistory.add(aiMessage);

      // TODO: Update adventure progress/state based on AI response if needed
      // _currentAdventure!.progress = ...
      // _currentAdventure!.gameState = ...

      // Save the updated adventure state
      await _adventureService.saveAdventure(_currentAdventure!);

    } catch (e) {
       if (kDebugMode) {
        print("Error getting AI response or saving adventure: $e");
      }
      _errorMessage = "Error communicating with AI. Please try again.";
      // Optionally remove the user message if AI fails? Or add an error message?
      _currentAdventure!.conversationHistory.add(Message(
        sender: 'System', // Or 'AI'
        content: "Error: Could not get AI response.",
        timestamp: DateTime.now(),
      ));
    } finally {
      _isSending = false;
      notifyListeners(); // Update UI with AI message or error
    }
  }

  /// Handles the dice roll action.
  Future<void> handleDiceRoll() async {
     if (_currentAdventure == null || _isSending) return;

    _isSending = true; // Prevent other actions during roll/response
    _errorMessage = null;
    notifyListeners(); // Show loading/disable input potentially

    try {
      final rollResult = _diceRollService.rollD20();

      // Add a message indicating the roll
       final rollMessage = Message(
        sender: 'System', // Or 'User' if user initiates roll explicitly
        content: "You rolled a D20 and got: $rollResult",
        timestamp: DateTime.now(),
      );
      _currentAdventure!.conversationHistory.add(rollMessage);
      notifyListeners(); // Show the roll result immediately

      // Get AI response based on the roll
      final aiResponseContent = await _aiService.generateDiceRollResponse(
        adventure: _currentAdventure!,
        rollResult: rollResult,
      );

      // Add AI message describing the outcome
      final aiMessage = Message(
        sender: 'AI',
        content: aiResponseContent,
        timestamp: DateTime.now(),
      );
      _currentAdventure!.conversationHistory.add(aiMessage);

      // Save the updated adventure state
      await _adventureService.saveAdventure(_currentAdventure!);

    } catch (e) {
       if (kDebugMode) {
        print("Error handling dice roll or saving adventure: $e");
      }
      _errorMessage = "Error processing dice roll. Please try again.";
       _currentAdventure!.conversationHistory.add(Message(
        sender: 'System',
        content: "Error: Could not process dice roll outcome.",
        timestamp: DateTime.now(),
      ));
    } finally {
      _isSending = false;
      notifyListeners();
    }
  }

  /// Handles the audio toggle action.
  void handleAudioToggle(bool enabled) {
    _isAudioEnabled = enabled;
    if (kDebugMode) {
      print("Controller: Audio toggled to $enabled");
    }
    // TODO: Implement actual audio playback/input logic here or in a dedicated service
    notifyListeners(); // Update UI if needed (e.g., button icon)
  }

  /// Saves the current adventure state (e.g., when leaving the screen).
  Future<void> saveAdventure() async {
    if (_currentAdventure != null) {
      try {
        await _adventureService.saveAdventure(_currentAdventure!);
         if (kDebugMode) {
          print("Adventure ${_currentAdventure!.id} saved on exit.");
        }
      } catch (e) {
         if (kDebugMode) {
          print("Error saving adventure on exit: $e");
        }
        // Handle error silently or show a message?
      }
    }
  }

  // TODO: Add method to handle adventure completion and navigation to RatingScreen
  // void handleAdventureComplete() { ... navigate ... }
}