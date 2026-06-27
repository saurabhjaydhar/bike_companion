import 'package:flutter_test/flutter_test.dart';
import 'package:bike_companion/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('App renders without crashing', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: BikeCompanionApp()),
    );
  });
}
