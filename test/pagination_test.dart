import 'package:flutter_test/flutter_test.dart';

// Simple pagination logic for testing
List<int> paginate(List<int> items, int page, int pageSize) {
  final start = (page - 1) * pageSize;
  if (start >= items.length) return []; // out of range → empty
  final end = start + pageSize;
  return items.sublist(start, end > items.length ? items.length : end);
}

void main() {
  group('Pagination Logic', () {
    test('Returns correct items for page 1', () {
      final items = List.generate(25, (i) => i + 1);
      expect(paginate(items, 1, 10), List.generate(10, (i) => i + 1));
    });
    test('Returns correct items for last page', () {
      final items = List.generate(25, (i) => i + 1);
      expect(paginate(items, 3, 10), [21, 22, 23, 24, 25]);
    });
    test('Returns empty list for out-of-range page', () {
      final items = List.generate(25, (i) => i + 1);
      expect(paginate(items, 4, 10), []);
    });
  });
}
