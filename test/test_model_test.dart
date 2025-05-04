import 'package:flutter_test/flutter_test.dart';
import 'package:takmed/database/test_db/test.dart';

void main() {
  group('Test model logic', () {
    test('Route must start with a slash', () {
      final testItem = Test(id: 1, title: 'Опіки', route: '/burns');
      expect(testItem.route.startsWith('/'), isTrue);
    });

    test('Title should not be empty', () {
      final testItem = Test(id: 2, title: '', route: '/empty-title');
      expect(testItem.title.trim().isNotEmpty, isFalse);
    });

    test('ID should be positive', () {
      final testItem = Test(id: -1, title: 'CPR', route: '/cpr');
      expect(testItem.id > 0, isFalse);
    });
  });
}
