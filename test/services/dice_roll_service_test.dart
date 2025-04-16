import 'package:flutter_test/flutter_test.dart';
import 'package:rpg_app/services/dice_roll_service.dart';
import 'package:rpg_app/services/dice_roll_service_impl.dart';

void main() {
  group('DiceRollServiceImpl', () {
    late DiceRollService diceRollService;

    setUp(() {
      diceRollService = DiceRollServiceImpl();
    });

    test('rollD20 returns a value between 1 and 20', () {
      // Run the test multiple times to increase confidence
      for (int i = 0; i < 100; i++) {
        final result = diceRollService.rollD20();
        expect(result, greaterThanOrEqualTo(1), reason: 'Roll $i: Result $result was less than 1');
        expect(result, lessThanOrEqualTo(20), reason: 'Roll $i: Result $result was greater than 20');
      }
    });
  });
}