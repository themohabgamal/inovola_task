import 'package:flutter_test/flutter_test.dart';

class ExpenseValidator {
  static String? validateTitle(String? title) {
    if (title == null || title.trim().isEmpty) {
      return 'Title is required';
    }
    if (title.length > 50) {
      return 'Title must be 50 characters or less';
    }
    return null;
  }

  static String? validateAmount(String? amountText) {
    if (amountText == null || amountText.trim().isEmpty) {
      return 'Amount is required';
    }

    final amount = double.tryParse(amountText);
    if (amount == null) {
      return 'Please enter a valid number';
    }

    if (amount <= 0) {
      return 'Amount must be greater than 0';
    }

    if (amount > 999999) {
      return 'Amount too large';
    }

    return null;
  }

  static String? validateCategory(String? category) {
    final allowedCategories = [
      'Food',
      'Transport',
      'Shopping',
      'Bills',
      'Entertainment'
    ];

    if (category == null || category.isEmpty) {
      return 'Category is required';
    }

    if (!allowedCategories.contains(category)) {
      return 'Invalid category selected';
    }

    return null;
  }
}

void main() {
  group('Expense Validation Tests', () {
    group('Title validation', () {
      test('should accept valid titles', () {
        expect(ExpenseValidator.validateTitle('Coffee'), null);
        expect(ExpenseValidator.validateTitle('Grocery Shopping'), null);
        expect(ExpenseValidator.validateTitle('A'), null);
      });

      test('should reject invalid titles', () {
        expect(ExpenseValidator.validateTitle(null), 'Title is required');
        expect(ExpenseValidator.validateTitle(''), 'Title is required');
        expect(ExpenseValidator.validateTitle('   '), 'Title is required');
        expect(ExpenseValidator.validateTitle('A' * 51),
            'Title must be 50 characters or less');
      });
    });

    group('Amount validation', () {
      test('should accept valid amounts', () {
        expect(ExpenseValidator.validateAmount('10'), null);
        expect(ExpenseValidator.validateAmount('25.50'), null);
        expect(ExpenseValidator.validateAmount('999999'), null);
      });

      test('should reject invalid amounts', () {
        expect(ExpenseValidator.validateAmount(null), 'Amount is required');
        expect(ExpenseValidator.validateAmount(''), 'Amount is required');
        expect(ExpenseValidator.validateAmount('abc'),
            'Please enter a valid number');
        expect(ExpenseValidator.validateAmount('0'),
            'Amount must be greater than 0');
        expect(ExpenseValidator.validateAmount('-10'),
            'Amount must be greater than 0');
        expect(ExpenseValidator.validateAmount('1000000'), 'Amount too large');
      });
    });

    group('Category validation', () {
      test('should accept valid categories', () {
        expect(ExpenseValidator.validateCategory('Food'), null);
        expect(ExpenseValidator.validateCategory('Transport'), null);
        expect(ExpenseValidator.validateCategory('Shopping'), null);
      });

      test('should reject invalid categories', () {
        expect(ExpenseValidator.validateCategory(null), 'Category is required');
        expect(ExpenseValidator.validateCategory(''), 'Category is required');
        expect(ExpenseValidator.validateCategory('Invalid'),
            'Invalid category selected');
      });
    });
  });
}
