import 'package:bike_companion/data/models/health_score.dart';
import 'package:bike_companion/shared/widgets/empty_state.dart';
import 'package:bike_companion/shared/widgets/health_ring.dart';
import 'package:bike_companion/shared/widgets/shimmer_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) => MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(body: Center(child: child)),
    );

void main() {
  // ---------------------------------------------------------------------------
  // ShimmerBox
  // ---------------------------------------------------------------------------
  group('ShimmerBox', () {
    testWidgets('renders with given dimensions', (tester) async {
      await tester.pumpWidget(_wrap(
        const ShimmerBox(width: 200, height: 48),
      ));
      final box = tester.getSize(find.byType(ShimmerBox));
      expect(box.height, equals(48));
    });

    testWidgets('animates — widget survives multiple pump calls', (tester) async {
      await tester.pumpWidget(_wrap(
        const ShimmerBox(height: 40),
      ));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 600));
      expect(find.byType(ShimmerBox), findsOneWidget);
    });

    testWidgets('uses custom borderRadius', (tester) async {
      await tester.pumpWidget(_wrap(
        const ShimmerBox(height: 32, borderRadius: 16),
      ));
      expect(find.byType(ShimmerBox), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  // EmptyState
  // ---------------------------------------------------------------------------
  group('EmptyState', () {
    testWidgets('displays heading and body text', (tester) async {
      await tester.pumpWidget(_wrap(
        const EmptyState(
          icon: Icons.two_wheeler_rounded,
          heading: 'No vehicles yet',
          body: 'Add your first vehicle.',
        ),
      ));
      expect(find.text('No vehicles yet'), findsOneWidget);
      expect(find.text('Add your first vehicle.'), findsOneWidget);
    });

    testWidgets('shows CTA button when provided', (tester) async {
      var tapped = false;
      await tester.pumpWidget(_wrap(
        EmptyState(
          icon: Icons.two_wheeler_rounded,
          heading: 'No vehicles',
          body: 'Add one.',
          ctaLabel: 'Add my vehicle',
          onCta: () => tapped = true,
        ),
      ));
      await tester.tap(find.text('Add my vehicle'));
      expect(tapped, isTrue);
    });

    testWidgets('no CTA button when label is null', (tester) async {
      await tester.pumpWidget(_wrap(
        const EmptyState(
          icon: Icons.two_wheeler_rounded,
          heading: 'No vehicles',
          body: 'Empty.',
        ),
      ));
      expect(find.byType(ElevatedButton), findsNothing);
      expect(find.byType(FilledButton), findsNothing);
    });
  });

  // ---------------------------------------------------------------------------
  // HealthRing
  // ---------------------------------------------------------------------------
  group('HealthRing', () {
    testWidgets('renders at requested size', (tester) async {
      await tester.pumpWidget(_wrap(
        const HealthRing(
          score: 78,
          grade: HealthGrade.good,
          size: 88,
        ),
      ));
      final size = tester.getSize(find.byType(HealthRing));
      expect(size.width, equals(88));
      expect(size.height, equals(88));
    });

    testWidgets('shows score text', (tester) async {
      await tester.pumpWidget(_wrap(
        const HealthRing(
          score: 85,
          grade: HealthGrade.excellent,
          size: 100,
        ),
      ));
      await tester.pump(const Duration(milliseconds: 1300));
      expect(find.text('85'), findsOneWidget);
    });

    testWidgets('animates without errors', (tester) async {
      await tester.pumpWidget(_wrap(
        const HealthRing(score: 50, grade: HealthGrade.fair, size: 88),
      ));
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pump(const Duration(milliseconds: 1200));
      expect(find.byType(HealthRing), findsOneWidget);
    });

    testWidgets('score 0 → critical grade renders without crash', (tester) async {
      await tester.pumpWidget(_wrap(
        const HealthRing(score: 0, grade: HealthGrade.critical, size: 88),
      ));
      await tester.pump(const Duration(milliseconds: 1300));
      expect(find.byType(HealthRing), findsOneWidget);
    });
  });
}
