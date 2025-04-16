import '../models/rating_feedback.dart';

/// Abstract class defining the contract for saving user feedback.
abstract class RatingService {
  /// Saves the rating feedback provided by the user.
  ///
  /// Takes a [RatingFeedback] object.
  /// In a real implementation, this would send the data to a backend server.
  Future<void> saveFeedback(RatingFeedback feedback);
}