import 'package:flutter/foundation.dart';

import '../models/subscription_models.dart';
import '../services/subscription_service.dart';

// TODO: Import navigation service or context access mechanism

class SubscriptionScreenController with ChangeNotifier {
  final SubscriptionService _subscriptionService;

  SubscriptionScreenController({required SubscriptionService subscriptionService})
      : _subscriptionService = subscriptionService {
    // Load data when controller is created
    loadSubscriptionScreen();
  }

  // --- State ---
  List<SubscriptionPlan> _plans = [];
  IndividualPurchase? _individualOption;
  SubscriptionStatus? _status;
  bool _isLoading = false;
  bool _isProcessingPurchase = false; // For purchase actions
  String? _errorMessage;
  String? _successMessage; // For purchase confirmation

  // --- Getters for View ---
  List<SubscriptionPlan> get plans => _plans;
  IndividualPurchase? get individualOption => _individualOption;
  SubscriptionStatus? get status => _status;
  bool get isLoading => _isLoading;
  bool get isProcessingPurchase => _isProcessingPurchase;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  // --- Actions ---

  /// Loads the subscription screen data.
  Future<void> loadSubscriptionScreen() async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null; // Clear previous messages
    notifyListeners();

    try {
      // Fetch all data in parallel
      final results = await Future.wait([
        _subscriptionService.getSubscriptionPlans(),
        _subscriptionService.getIndividualPurchaseOption(),
        _subscriptionService.getSubscriptionStatus(),
      ]);

      _plans = results[0] as List<SubscriptionPlan>;
      _individualOption = results[1] as IndividualPurchase;
      _status = results[2] as SubscriptionStatus;

    } catch (e) {
      if (kDebugMode) {
        print("Error loading subscription screen data: $e");
      }
      _errorMessage = "Failed to load subscription details.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Handles tapping the "Subscribe" button for a plan.
  Future<void> handleSubscribe(String planId) async {
    if (_isProcessingPurchase) return;

    _isProcessingPurchase = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      bool initiated = await _subscriptionService.processSubscription(planId);
      if (initiated) {
        // Purchase flow initiated (might involve redirecting to Play Store).
        // The actual status update might happen later via callbacks or listeners
        // from the purchase library. For simulation, we update status immediately.
        _successMessage = "Subscription process started..."; // Temporary message
        // Reload status after a delay to simulate update
        Future.delayed(const Duration(seconds: 1), loadSubscriptionScreen);
      } else {
        throw Exception("Subscription initiation failed.");
      }
    } catch (e) {
       if (kDebugMode) {
        print("Error processing subscription for $planId: $e");
      }
      _errorMessage = "Failed to start subscription process.";
    } finally {
      _isProcessingPurchase = false;
      notifyListeners();
    }
  }

  /// Handles tapping the "Buy Now" button for individual purchase.
  Future<void> handleBuyNow() async {
     if (_isProcessingPurchase) return;

    _isProcessingPurchase = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

     try {
      bool initiated = await _subscriptionService.processIndividualPurchase();
      if (initiated) {
        _successMessage = "Purchase process started..."; // Temporary message
        // Reload status after a delay to simulate update
        Future.delayed(const Duration(seconds: 1), loadSubscriptionScreen);
      } else {
        throw Exception("Individual purchase initiation failed.");
      }
    } catch (e) {
       if (kDebugMode) {
        print("Error processing individual purchase: $e");
      }
      _errorMessage = "Failed to start purchase process.";
    } finally {
      _isProcessingPurchase = false;
      notifyListeners();
    }
  }

  /// Handles back navigation (if needed by controller logic).
  void handleBackNavigation() {
     if (kDebugMode) {
        print("Controller: Back navigation triggered.");
      }
     // Navigation itself is usually handled by Navigator in the View.
     // This method is here if the controller needs to perform actions before/during back navigation.
  }
}