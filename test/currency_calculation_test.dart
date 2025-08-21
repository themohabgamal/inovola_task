import 'package:flutter_test/flutter_test.dart';

// Simple currency calculation function for testing
num convertToUSD(num amount, num rate) => amount * rate;

void main() {
  group('Currency Calculation Tests', () {
    test('Converts amount to USD correctly', () {
      expect(convertToUSD(100, 0.3), 30);
      expect(convertToUSD(50, 1.5), 75);
      expect(convertToUSD(0, 1.2), 0);
    });

    test('Handles edge cases', () {
      expect(convertToUSD(100, 0), 0);
      expect(convertToUSD(0, 0), 0);
      expect(convertToUSD(100, 1), 100);
    });
  });
}
