import 'package:flutter/foundation.dart'; // For kDebugMode

import '../models/rating_feedback.dart';
import 'rating_service.dart';

/// Simulated implementation of [RatingService] that prints feedback
/// to the console instead of saving it to a backend.
class SimulatedRatingService implements RatingService {
  @override
  Future<void> saveFeedback(RatingFeedback feedback) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 150));

    // Print feedback details to the console for debugging/simulation purposes.
    if (kDebugMode) {
      print("--- Simulated Feedback Submission ---");
      print("Adventure ID: ${feedback.adventureId}");
      print("User ID: ${feedback.userId ?? 'N/A'}");
      print("Overall Satisfaction: ${feedback.overallSatisfaction} stars");
      print("Story Engagement: ${feedback.storyEngagement} stars");
      print("AI Helpfulness: ${feedback.aiHelpfulness} stars");
      print("Additional Comments: ${feedback.additionalComments ?? 'None'}");
      print("------------------------------------");
    }
    // In a real implementation, this would involve an HTTP POST request
    // to a backend endpoint, sending feedback.toJson().
  }
}