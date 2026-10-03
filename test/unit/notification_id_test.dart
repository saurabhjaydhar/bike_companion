import 'package:garajo/core/services/notification_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('notificationId', () {
    test('is fixed for a key — the same on every platform and version', () {
      // FNV-1a reference values, masked to 31 bits.
      expect(notificationId(''), 0x811c9dc5 & 0x7FFFFFFF);
      expect(notificationId('a'), 0xe40c292c & 0x7FFFFFFF);
      expect(notificationId('doc:abc:30'), notificationId('doc:abc:30'));
    });

    test('is a valid Android notification ID (non-negative 32-bit int)', () {
      for (final key in ['doc:x:1', 'doc:${'z' * 500}:30', 'émoji 🚲']) {
        final id = notificationId(key);
        expect(id, greaterThanOrEqualTo(0));
        expect(id, lessThanOrEqualTo(0x7FFFFFFF));
      }
    });

    test('rarely collides across many reminders', () {
      final ids = {
        for (var doc = 0; doc < 2000; doc++)
          for (final days in const [30, 7, 1]) notificationId('doc:$doc:$days'),
      };
      expect(ids, hasLength(6000));
    });
  });
}
