/// Represents a subscription plan available for purchase.
class SubscriptionPlan {
  final String id; // Unique identifier for the subscription plan (e.g., from Play Store)
  final String name; // Name of the subscription plan (e.g., "Basic", "Premium")
  final int adventureLimit; // Number of adventures allowed per month
  final String price; // Price string (e.g., "$4.99")
  final String details; // Additional details or description

  SubscriptionPlan({
    required this.id,
    required this.name,
    required this.adventureLimit,
    required this.price,
    required this.details,
  });

  // TODO: Add fromJson/toJson if needed (e.g., fetching plans from a backend)
}

/// Represents an option to purchase individual adventures.
class IndividualPurchase {
  final String id; // Unique identifier for the purchase option (e.g., from Play Store)
  final int adventuresCount; // Number of adventures provided (typically 1)
  final String price; // Price string (e.g., "$0.99")

  IndividualPurchase({
    required this.id,
    required this.adventuresCount,
    required this.price,
  });

  // TODO: Add fromJson/toJson if needed
}

/// Represents the user's current subscription status.
class SubscriptionStatus {
  final SubscriptionPlan? currentPlan; // Current active plan (null if none)
  final int remainingAdventures; // Remaining adventures for the month/period

  SubscriptionStatus({
    this.currentPlan,
    required this.remainingAdventures,
  });

  // TODO: Add fromJson/toJson if needed (e.g., fetching status from a backend)
}