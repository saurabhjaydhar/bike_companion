import 'package:flutter_test/flutter_test.dart';
import 'package:garajo/core/providers/active_vehicle_provider.dart';

void main() {
  group('pickHomeVehicle', () {
    test('reopens the vehicle used last', () {
      expect(pickHomeVehicle(['a', 'b', 'c'], 'b'), 'b');
    });

    test('falls back to the first vehicle when none was saved', () {
      expect(pickHomeVehicle(['a', 'b'], null), 'a');
    });

    test('falls back to the first vehicle when the saved one was deleted', () {
      expect(pickHomeVehicle(['a', 'b'], 'gone'), 'a');
    });

    test('is null with an empty garage', () {
      expect(pickHomeVehicle([], 'a'), isNull);
      expect(pickHomeVehicle([], null), isNull);
    });
  });
}
