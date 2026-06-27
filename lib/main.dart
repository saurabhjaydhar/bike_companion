import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'core/providers/connectivity_provider.dart';
import 'core/services/auth_service.dart';
import 'core/services/fcm_service.dart';
import 'core/services/firestore_service.dart';
import 'core/services/health_score_service.dart';
import 'core/services/notification_service.dart';
import 'core/services/restore_service.dart';
import 'core/services/storage_service.dart';
import 'core/services/sync_service.dart';
import 'core/theme/app_theme.dart';
import 'data/database/app_database.dart';
import 'data/repositories/bike_repository.dart';
import 'data/repositories/document_repository.dart';
import 'data/repositories/expense_repository.dart';
import 'data/repositories/fuel_repository.dart';
import 'data/repositories/service_repository.dart';
import 'features/settings/settings_screen.dart';
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
    ..registerSingleton<BikeRepository>(BikeRepository(db))
    ..registerSingleton<FuelRepository>(FuelRepository(db))
    ..registerSingleton<ServiceRepository>(ServiceRepository(db))
    ..registerSingleton<ExpenseRepository>(ExpenseRepository(db))
    ..registerSingleton<DocumentRepository>(DocumentRepository(db))
    ..registerSingleton<HealthScoreService>(HealthScoreService())
    ..registerSingleton<AuthService>(AuthService())
    ..registerSingleton<StorageService>(StorageService())
    ..registerSingleton<FirestoreService>(FirestoreService());

  final fs = getIt<FirestoreService>();
  getIt
    ..registerSingleton<SyncService>(SyncService(db, fs))
    ..registerSingleton<RestoreService>(RestoreService(db, fs));
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await _setupDependencies();
  await NotificationService.initialize();
  await FcmService.initialize();
  runApp(const ProviderScope(child: BikeCompanionApp()));
}

class BikeCompanionApp extends ConsumerWidget {
  const BikeCompanionApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(syncOnReconnectProvider); // triggers Firestore sync on reconnect
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp.router(
      title: 'Bike Companion',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
