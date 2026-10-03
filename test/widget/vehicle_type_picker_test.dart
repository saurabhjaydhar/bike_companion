import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:garajo/data/models/vehicle_type.dart';
import 'package:garajo/l10n/l10n.dart';
import 'package:garajo/shared/widgets/vehicle_type_picker.dart';

void main() {
  testWidgets('shows bike, scooter and car, and reports the pick',
      (tester) async {
    VehicleType? picked;
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: VehicleTypePicker(
          selected: VehicleType.bike,
          onChanged: (t) => picked = t,
        ),
      ),
    ));

    expect(find.text('Bike'), findsOneWidget);
    expect(find.text('Scooter'), findsOneWidget);
    expect(find.text('Car'), findsOneWidget);
    expect(find.byIcon(Icons.directions_car_rounded), findsOneWidget);

    await tester.tap(find.text('Car'));
    expect(picked, VehicleType.car);
  });
}
