import 'package:flutter/foundation.dart';

import '../models/rating_feedback.dart';
import '../services/rating_service.dart';
// import '../services/adventure_service.dart'; // Optional: To delete adventure after rating

// TODO: Import navigation service or context access mechanism

class RatingScreenController with ChangeNotifier {
  final RatingService _ratingService;
  // final AdventureService _adventureService; // Optional

  RatingScreenController({
    required RatingService ratingService,
    // required AdventureService adventureService, // Optional
  }) : _ratingService = ratingService;
       // _adventureService = adventureService; // Optional

  // --- State ---
  RatingFeedback? _currentFeedback;
  bool _isSubmitting = false;
  String? _errorMessage;
  String? _successMessage; // To show confirmation

  // --- Getters for View ---
  // View might manage local rating state, but controller holds the model
  bool get isSubmitting => _isSubmitting;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  // --- Actions ---

  /// Initializes the controller for a specific adventure rating.
  void loadRatingScreen(String adventureId, String adventureTitle) {
    // Create a new feedback object to store ratings
    _currentFeedback = RatingFeedback(
      adventureId: adventureId,
      // userId: null, // TODO: Get user ID if authentication is implemented
    );
    _isSubmitting = false;
    _errorMessage = null;
    _successMessage = null;
     if (kDebugMode) {
        print("RatingScreenController loaded for adventure: $adventureTitle ($adventureId)");
      }
    // No need to notifyListeners unless there's initial loading state
  }

  /// Updates the rating for a specific category.
  void handleStarSelection(String category, int stars) {
    if (_currentFeedback == null) return;

    switch (category.toLowerCase()) {
      case 'overall':
        _currentFeedback!.overallSatisfaction = stars;
        break;
      case 'story':
        _currentFeedback!.storyEngagement = stars;
        break;
      case 'ai':
        _currentFeedback!.aiHelpfulness = stars;
        break;
      default:
         if (kDebugMode) {
            print("Warning: Unknown rating category '$category'");
          }
    }
     if (kDebugMode) {
        print("Rating updated - $category: $stars");
      }
    // No need to notifyListeners if the view manages its own star display state
  }

  /// Updates the additional comments.
  void handleCommentInput(String text) {
    if (_currentFeedback != null) {
      _currentFeedback!.additionalComments = text.trim().isEmpty ? null : text.trim();
       if (kDebugMode) {
          // Avoid printing potentially long comments frequently
          // print("Comment updated: ${_currentFeedback!.additionalComments}");
        }
    }
  }

  /// Submits the collected feedback.
  Future<void> handleSubmitFeedback() async {
    if (_currentFeedback == null || _isSubmitting) return;

    // Basic validation: ensure at least one rating is given? (Optional)
    if (_currentFeedback!.overallSatisfaction == 0 &&
        _currentFeedback!.storyEngagement == 0 &&
        _currentFeedback!.aiHelpfulness == 0 &&
        (_currentFeedback!.additionalComments ?? '').isEmpty) {
      _errorMessage = "Please provide at least one rating or comment.";
      notifyListeners();
      return;
    }


    _isSubmitting = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      // Ensure comment is updated from text field before submitting
      // (Assuming view calls handleCommentInput or controller reads directly)
      await _ratingService.saveFeedback(_currentFeedback!);

      // Optional: Delete the adventure locally after successful rating
      // try {
      //   await _adventureService.deleteAdventure(_currentFeedback!.adventureId);
      //   if (kDebugMode) print("Adventure ${_currentFeedback!.adventureId} deleted after rating.");
      // } catch (e) {
      //   if (kDebugMode) print("Warning: Failed to delete adventure ${_currentFeedback!.adventureId} after rating: $e");
      // }

      _successMessage = "Thank you for your feedback!";
       if (kDebugMode) {
          print("Feedback submitted successfully for adventure: ${_currentFeedback!.adventureId}");
        }
      // TODO: Trigger navigation back to MainScreen after a short delay
      // Future.delayed(const Duration(seconds: 2), () {
      //   navigatorKey.currentState?.popUntil((route) => route.isFirst); // Example: Pop back to root
      // });

    } catch (e) {
       if (kDebugMode) {
          print("Error submitting feedback: $e");
        }
      _errorMessage = "Failed to submit feedback. Please try again.";
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }
}