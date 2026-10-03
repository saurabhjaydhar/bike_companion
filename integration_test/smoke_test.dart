import 'package:bike_companion/core/services/health_score_service.dart';
import 'package:bike_companion/data/database/app_database.dart';
import 'package:bike_companion/data/repositories/vehicle_repository.dart';
import 'package:bike_companion/data/repositories/document_repository.dart';
import 'package:bike_companion/data/repositories/expense_repository.dart';
import 'package:bike_companion/data/repositories/fuel_repository.dart';
import 'package:bike_companion/data/repositories/service_repository.dart';
import 'package:bike_companion/features/settings/settings_screen.dart';
import 'package:bike_companion/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _setupDeps() async {
  if (getIt.isRegistered<AppDatabase>()) return;
  final db = AppDatabase.instance;
  getIt
    ..registerSingleton<AppDatabase>(db)
    ..registerSingleton<VehicleRepository>(VehicleRepository(db))
    ..registerSingleton<FuelRepository>(FuelRepository(db))
    ..registerSingleton<ServiceRepository>(ServiceRepository(db))
    ..registerSingleton<ExpenseRepository>(ExpenseRepository(db))
    ..registerSingleton<DocumentRepository>(DocumentRepository(db))
    ..registerSingleton<HealthScoreService>(HealthScoreService());
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await _setupDeps();
  });

  tearDownAll(() => getIt.reset());

  testWidgets('App renders a MaterialApp without crashing', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: BikeCompanionApp()),
    );
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('ThemeModeNotifier — persists mode changes', (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(container.read(themeModeProvider), ThemeMode.system);

    await container.read(themeModeProvider.notifier).setMode(ThemeMode.dark);
    expect(container.read(themeModeProvider), ThemeMode.dark);

    await container.read(themeModeProvider.notifier).setMode(ThemeMode.light);
    expect(container.read(themeModeProvider), ThemeMode.light);

    await container.read(themeModeProvider.notifier).setMode(ThemeMode.system);
    expect(container.read(themeModeProvider), ThemeMode.system);
  });
}
