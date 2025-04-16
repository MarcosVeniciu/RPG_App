import 'dart:math'; // For Random class

import 'dice_roll_service.dart';

/// Default implementation of [DiceRollService] that uses Dart's [Random] class.
///
/// This implementation provides a pseudo-random number generator for dice rolls.
/// It's suitable for most game scenarios where true randomness isn't required.
class DiceRollServiceImpl implements DiceRollService {
  /// Internal random number generator instance.
  ///
  /// Initialized once when the service is created and reused for all rolls.
  final Random _random = Random();

  @override
  int rollD20() {
    // Generate a random integer between 1 (inclusive) and 21 (exclusive).
    // This effectively gives us numbers from 1 to 20.
    return _random.nextInt(20) + 1;
  }
}