import 'package:flutter_test/flutter_test.dart';

// Simple expense validation function for testing
bool isExpenseValid(String category, num amount, DateTime date) {
  return category.isNotEmpty &&
      amount > 0 &&
      date.isBefore(DateTime.now().add(Duration(days: 1)));
}

void main() {
  group('Expense Validation', () {
    test('Valid expense returns true', () {
      expect(isExpenseValid('Food', 20, DateTime.now()), true);
    });
    test('Empty category returns false', () {
      expect(isExpenseValid('', 20, DateTime.now()), false);
    });
    test('Zero amount returns false', () {
      expect(isExpenseValid('Food', 0, DateTime.now()), false);
    });
    test('Future date returns false', () {
      expect(isExpenseValid('Food', 20, DateTime.now().add(Duration(days: 2))),
          false);
    });
  });
}
