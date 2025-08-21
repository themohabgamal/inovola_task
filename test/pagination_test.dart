import 'package:flutter_test/flutter_test.dart';

class PaginationHelper {
  static List<T> getPage<T>(List<T> items, int pageNumber, int itemsPerPage) {
    final startIndex = pageNumber * itemsPerPage;
    final endIndex = startIndex + itemsPerPage;

    if (startIndex >= items.length) return [];

    return items.sublist(
        startIndex, endIndex > items.length ? items.length : endIndex);
  }

  static bool hasNextPage(List items, int currentPage, int itemsPerPage) {
    final nextPageStart = (currentPage + 1) * itemsPerPage;
    return nextPageStart < items.length;
  }

  static int getTotalPages(int totalItems, int itemsPerPage) {
    if (totalItems == 0) return 0;
    return (totalItems / itemsPerPage).ceil();
  }
}

void main() {
  group('Pagination Logic Tests', () {
    final testItems = List.generate(25, (index) => 'Item $index');

    test('should get correct first page', () {
      final page = PaginationHelper.getPage(testItems, 0, 10);

      expect(page.length, 10);
      expect(page.first, 'Item 0');
      expect(page.last, 'Item 9');
    });

    test('should get correct middle page', () {
      final page = PaginationHelper.getPage(testItems, 1, 10);

      expect(page.length, 10);
      expect(page.first, 'Item 10');
      expect(page.last, 'Item 19');
    });

    test('should get correct last page', () {
      final page = PaginationHelper.getPage(testItems, 2, 10);

      expect(page.length, 5); // Only 5 items left
      expect(page.first, 'Item 20');
      expect(page.last, 'Item 24');
    });

    test('should return empty list for page beyond range', () {
      final page = PaginationHelper.getPage(testItems, 10, 10);
      expect(page.isEmpty, true);
    });

    test('should correctly detect if there is a next page', () {
      expect(PaginationHelper.hasNextPage(testItems, 0, 10), true);
      expect(PaginationHelper.hasNextPage(testItems, 1, 10), true);
      expect(PaginationHelper.hasNextPage(testItems, 2, 10), false);
    });

    test('should calculate total pages correctly', () {
      expect(PaginationHelper.getTotalPages(25, 10), 3);
      expect(PaginationHelper.getTotalPages(20, 10), 2);
      expect(PaginationHelper.getTotalPages(10, 10), 1);
      expect(PaginationHelper.getTotalPages(0, 10), 0);
    });
  });
}
