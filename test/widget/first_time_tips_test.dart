import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:garajo/l10n/app_localizations.dart';
import 'package:garajo/shared/widgets/first_time_tips.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget _app(Widget child) => MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    );

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('a tip shows once and stays gone after dismissing',
      (tester) async {
    await tester.pumpWidget(_app(const TipCard(id: 'x', text: 'Hello tip')));
    await tester.pumpAndSettle();
    expect(find.text('Hello tip'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Hello tip'), findsNothing);
    expect(await Tips.isSeen('x'), isTrue);

    // Next visit: not shown.
    await tester.pumpWidget(_app(const SizedBox()));
    await tester.pumpWidget(_app(const TipCard(id: 'x', text: 'Hello tip')));
    await tester.pumpAndSettle();
    expect(find.text('Hello tip'), findsNothing);
  });

  test('resetAll brings tips and the tour back', () async {
    await Tips.markSeen(Tips.service);
    await Tips.markSeen(Tips.homeTour);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('active_vehicle_id', 'v1');

    await Tips.resetAll();

    expect(await Tips.isSeen(Tips.service), isFalse);
    expect(await Tips.isSeen(Tips.homeTour), isFalse);
    expect(prefs.getString('active_vehicle_id'), 'v1');
  });

  testWidgets('the tour walks through each step and can be skipped',
      (tester) async {
    final a = GlobalKey(), b = GlobalKey();
    await tester.pumpWidget(_app(Builder(
      builder: (context) => Column(children: [
        SizedBox(key: a, width: 100, height: 50),
        SizedBox(key: b, width: 100, height: 50),
        ElevatedButton(
          onPressed: () => showSpotlightTour(context, [
            TourStep(target: a, title: 'First', body: 'one'),
            TourStep(target: b, title: 'Second', body: 'two'),
          ]),
          child: const Text('go'),
        ),
      ]),
    )));
    await tester.tap(find.text('go'));
    await tester.pumpAndSettle();
    expect(find.text('FIRST'), findsOneWidget);
    expect(find.text('1/2'), findsOneWidget);

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('SECOND'), findsOneWidget);
    expect(find.text('Skip'), findsNothing); // last step

    await tester.tap(find.text('Got it'));
    await tester.pumpAndSettle();
    expect(find.text('SECOND'), findsNothing);
  });
}
