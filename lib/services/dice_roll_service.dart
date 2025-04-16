/// Defines the contract for services that simulate dice rolls within the RPG application.
///
/// Implementations of this class provide methods for various dice types.
abstract class DiceRollService {
  /// Simulates rolling a 20-sided die (D20).
  ///
  /// Returns a pseudo-random integer result between 1 and 20, inclusive.
  int rollD20();

  // Consider adding other common dice roll methods if needed in the future,
  // for example:
  // int rollD6();
  // int rollDice(int numberOfDice, int sides);
}