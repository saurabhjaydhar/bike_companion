import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'core/providers/connectivity_provider.dart';
import 'core/services/auth_service.dart';
import 'core/services/rc_lookup_service.dart';
import 'core/services/fcm_service.dart';
import 'core/services/firestore_service.dart';
import 'core/services/health_score_service.dart';
import 'core/services/notification_service.dart';
import 'core/services/reminder_planner.dart';
import 'core/services/reminder_service.dart';
import 'core/services/restore_service.dart';
import 'core/services/storage_service.dart';
import 'core/services/sync_service.dart';
import 'core/theme/app_theme.dart';
import 'data/database/app_database.dart';
import 'data/repositories/vehicle_repository.dart';
import 'data/repositories/document_repository.dart';
import 'data/repositories/expense_repository.dart';
import 'data/repositories/fuel_repository.dart';
import 'data/repositories/ledger_repository.dart';
import 'data/repositories/service_repository.dart';
import 'features/settings/settings_screen.dart';
import 'l10n/l10n.dart';
import 'router/app_router.dart';

final getIt = GetIt.instance;

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<void> _setupDependencies() async {
  final db = AppDatabase.instance;
  getIt
    ..registerSingleton<AppDatabase>(db)
    ..registerSingleton<VehicleRepository>(VehicleRepository(db))
    ..registerSingleton<FuelRepository>(FuelRepository(db))
    ..registerSingleton<ServiceRepository>(ServiceRepository(db))
    ..registerSingleton<ExpenseRepository>(ExpenseRepository(db))
    ..registerSingleton<DocumentRepository>(DocumentRepository(db))
    ..registerSingleton<LedgerRepository>(LedgerRepository(db))
    ..registerSingleton<HealthScoreService>(HealthScoreService())
    ..registerSingleton<AuthService>(AuthService())
    ..registerSingleton<RcLookupService>(RcLookupService())
    ..registerSingleton<StorageService>(StorageService())
    ..registerSingleton<FirestoreService>(FirestoreService());

  final fs = getIt<FirestoreService>();
  getIt
    ..registerSingleton<SyncService>(SyncService(db, fs))
    ..registerSingleton<RestoreService>(RestoreService(db, fs));

  final reminders = ReminderService(
    getIt<VehicleRepository>(),
    getIt<DocumentRepository>(),
    getIt<ServiceRepository>(),
    getIt<FuelRepository>(),
    getIt<HealthScoreService>(),
    getIt<LedgerRepository>(),
  );
  getIt.registerSingleton<ReminderService>(reminders);

  // Every local change is uploaded right away and re-plans reminders.
  final sync = getIt<SyncService>();
  SyncService.onEnqueued = () {
    sync.pushPending();
    reminders.scheduleRefresh();
  };
  sync.start();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await _setupDependencies();
  await NotificationService.initialize();
  await FcmService.initialize();
  // Covers reinstalls, restores and anything scheduled by older versions.
  getIt<ReminderService>().refresh();
  runApp(const ProviderScope(child: BikeCompanionApp()));
}

class BikeCompanionApp extends ConsumerStatefulWidget {
  const BikeCompanionApp({super.key});

  @override
  ConsumerState<BikeCompanionApp> createState() => _BikeCompanionAppState();
}

class _BikeCompanionAppState extends ConsumerState<BikeCompanionApp> {
  StreamSubscription<String>? _taps;

  @override
  void initState() {
    super.initState();
    // Tapping a reminder opens the place to act on it.
    _taps = NotificationService.taps.listen(_openReminder);
    final launch = NotificationService.takeLaunchPayload();
    if (launch != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _openReminder(launch));
    }
  }

  @override
  void dispose() {
    _taps?.cancel();
    super.dispose();
  }

  void _openReminder(String payload) {
    final reminder = ReminderPayload.decode(payload);
    if (reminder != null) ref.read(appRouterProvider).go(reminder.route);
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(syncOnReconnectProvider); // triggers Firestore sync on reconnect
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    return MaterialApp.router(
      onGenerateTitle: (context) => context.l10n.appTitle,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
