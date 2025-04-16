import 'package:flutter/foundation.dart'; // For kDebugMode

import '../models/subscription_models.dart';
import 'subscription_service.dart';

/// Simulated implementation of [SubscriptionService] using hardcoded data.
/// Purchase processing is simulated by printing messages.
class SimulatedSubscriptionService implements SubscriptionService {
  // --- Hardcoded Data ---
  final List<SubscriptionPlan> _plans = [
    SubscriptionPlan(
      id: 'basic_monthly_20', // Example ID (matches Play Store/App Store ID)
      name: 'Basic',
      adventureLimit: 20,
      price: 'R\$ 9,99/mês', // Example price
      details: 'Acesso a 20 aventuras por mês.',
    ),
    SubscriptionPlan(
      id: 'premium_monthly_50',
      name: 'Premium',
      adventureLimit: 50,
      price: 'R\$ 19,99/mês',
      details: 'Acesso a 50 aventuras por mês e conteúdo exclusivo.',
    ),
    // Add more plans if needed
  ];

  final IndividualPurchase _individualOption = IndividualPurchase(
    id: 'extra_adventure_1', // Example ID
    adventuresCount: 1,
    price: 'R\$ 1,99', // Example price
  );

  // Simulate a user status (can be made more dynamic later if needed)
  SubscriptionStatus _currentUserStatus = SubscriptionStatus(
    currentPlan: null, // Start with no plan
    remainingAdventures: 5, // Give some free adventures initially?
  );

  // --- Interface Implementation ---

  @override
  Future<List<SubscriptionPlan>> getSubscriptionPlans() async {
    await Future.delayed(const Duration(milliseconds: 100)); // Simulate delay
    return _plans;
  }

  @override
  Future<IndividualPurchase> getIndividualPurchaseOption() async {
    await Future.delayed(const Duration(milliseconds: 50)); // Simulate delay
    return _individualOption;
  }

  @override
  Future<SubscriptionStatus> getSubscriptionStatus() async {
    await Future.delayed(const Duration(milliseconds: 80)); // Simulate delay
    // In a real app, fetch this from a backend or secure local storage
    return _currentUserStatus;
  }

  @override
  Future<bool> processSubscription(String planId) async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate purchase flow
    final plan = _plans.firstWhere((p) => p.id == planId, orElse: () => _plans.first); // Find plan

    if (kDebugMode) {
      print("--- Simulating Subscription Purchase ---");
      print("Initiating purchase for Plan ID: $planId (${plan.name})");
      print("Redirecting to Play Store/App Store (Simulated)...");
      // Simulate successful purchase and update status
      _currentUserStatus = SubscriptionStatus(
        currentPlan: plan,
        remainingAdventures: plan.adventureLimit, // Reset remaining on new sub
      );
      print("Subscription successful! Status updated.");
      print("--------------------------------------");
    }
    return true; // Simulate successful initiation
  }

  @override
  Future<bool> processIndividualPurchase() async {
    await Future.delayed(const Duration(milliseconds: 400)); // Simulate purchase flow
    if (kDebugMode) {
      print("--- Simulating Individual Purchase ---");
      print("Initiating purchase for: ${_individualOption.adventuresCount} extra adventure(s)");
      print("Processing In-App Purchase (Simulated)...");
      // Simulate successful purchase and update status
      _currentUserStatus = SubscriptionStatus(
        currentPlan: _currentUserStatus.currentPlan, // Keep current plan
        remainingAdventures: _currentUserStatus.remainingAdventures + _individualOption.adventuresCount,
      );
      print("Purchase successful! Status updated.");
      print("------------------------------------");
    }
    return true; // Simulate successful initiation
  }
}