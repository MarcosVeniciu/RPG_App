import '../models/subscription_models.dart';

/// Abstract class defining the contract for managing subscription plans,
/// individual purchases, and user subscription status.
abstract class SubscriptionService {
  /// Retrieves the list of available subscription plans.
  Future<List<SubscriptionPlan>> getSubscriptionPlans();

  /// Retrieves the details for the individual adventure purchase option.
  Future<IndividualPurchase> getIndividualPurchaseOption();

  /// Retrieves the current subscription status for the user.
  /// This might involve checking local state or a backend.
  Future<SubscriptionStatus> getSubscriptionStatus();

  /// Processes a subscription purchase for the given plan ID.
  /// In a real app, this would interact with the Play Store/App Store API.
  /// Returns true if the purchase process was initiated successfully, false otherwise.
  Future<bool> processSubscription(String planId);

  /// Processes an individual adventure purchase.
  /// In a real app, this would interact with the in-app purchase API.
  /// Returns true if the purchase process was initiated successfully, false otherwise.
  Future<bool> processIndividualPurchase();

  // TODO: Add methods for restoring purchases, handling updates, etc. if needed.
}