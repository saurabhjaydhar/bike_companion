import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:garajo/features/dashboard/widgets/log_sheet.dart';
import 'package:garajo/l10n/app_localizations.dart';

void main() {
  // A small phone with large system text: the sheet must not overflow.
  testWidgets('LOG sheet fits a small screen with large text', (tester) async {
    tester.view.physicalSize = const Size(720, 1280); // 360x640 @2x
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(ProviderScope(
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.3)),
          child: child!,
        ),
        home: Consumer(
          builder: (context, ref, _) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => showLogSheet(context, ref, vehicleId: 'v1'),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    ));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('ADD DOCUMENT'), findsOneWidget);
  });
}
