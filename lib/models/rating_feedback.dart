/// Represents the feedback provided by a user after an adventure.
class RatingFeedback {
  final String? id; // Unique identifier (optional, might be assigned by backend)
  final String adventureId; // Identifier for the rated adventure
  final String? userId; // Identifier for the user (optional, depends on auth)
  int overallSatisfaction; // Overall satisfaction rating (1-5 stars) - mutable
  int storyEngagement; // Story engagement rating (1-5 stars) - mutable
  int aiHelpfulness; // AI helpfulness rating (1-5 stars) - mutable
  String? additionalComments; // Optional detailed feedback comments - mutable

  RatingFeedback({
    this.id,
    required this.adventureId,
    this.userId,
    this.overallSatisfaction = 0, // Default to 0 or handle unrated state
    this.storyEngagement = 0,
    this.aiHelpfulness = 0,
    this.additionalComments,
  });

  // Method to convert a RatingFeedback instance to a JSON map
  // Useful for sending feedback to the backend (simulated or real)
  Map<String, dynamic> toJson() {
    return {
      // 'id': id, // Only include if it exists
      'adventureId': adventureId,
      // 'userId': userId, // Only include if it exists and is needed
      'overallSatisfaction': overallSatisfaction,
      'storyEngagement': storyEngagement,
      'aiHelpfulness': aiHelpfulness,
      'additionalComments': additionalComments,
    };
  }

  // Factory constructor (optional, if fetching feedback is needed)
  /*
  factory RatingFeedback.fromJson(Map<String, dynamic> json) {
    return RatingFeedback(
      id: json['id'] as String?,
      adventureId: json['adventureId'] as String,
      userId: json['userId'] as String?,
      overallSatisfaction: json['overallSatisfaction'] as int? ?? 0,
      storyEngagement: json['storyEngagement'] as int? ?? 0,
      aiHelpfulness: json['aiHelpfulness'] as int? ?? 0,
      additionalComments: json['additionalComments'] as String?,
    );
  }
  */
}