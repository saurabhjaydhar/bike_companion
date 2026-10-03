import 'package:bike_companion/features/dashboard/widgets/spending_card.dart';
import 'package:bike_companion/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pump(
  WidgetTester tester, {
  required double spent,
  double? budget,
  VoidCallback? onSetBudget,
}) =>
    tester.pumpWidget(MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: SpendingCard(
          spent: spent,
          budget: budget,
          onOpen: () {},
          onSetBudget: onSetBudget ?? () {},
        ),
      ),
    ));

void main() {
  testWidgets('without a budget, offers to set one', (tester) async {
    var asked = false;
    await _pump(tester, spent: 4200, onSetBudget: () => asked = true);
    expect(find.text('₹4,200'), findsOneWidget);
    await tester.tap(find.text('Set budget'));
    expect(asked, isTrue);
  });

  testWidgets('shows how much of the budget is left', (tester) async {
    await _pump(tester, spent: 4200, budget: 6000);
    await tester.pumpAndSettle();
    expect(find.text('70%'), findsOneWidget);
    expect(find.text('₹1,800 left of ₹6,000'), findsOneWidget);
  });

  testWidgets('shows the overspend once over budget', (tester) async {
    await _pump(tester, spent: 6500, budget: 6000);
    await tester.pumpAndSettle();
    expect(find.text('₹500 over budget'), findsOneWidget);
  });
}
