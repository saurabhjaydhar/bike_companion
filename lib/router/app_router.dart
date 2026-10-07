import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';
import '../core/providers/active_vehicle_provider.dart';
import '../core/services/auth_service.dart';
import '../l10n/l10n.dart';
import '../main.dart';
import '../shared/widgets/aurora_backdrop.dart';
import '../shared/widgets/livery_nav_bar.dart';
import '../shared/widgets/offline_banner.dart';
import '../features/auth/auth_screen.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../features/documents/documents_screen.dart';
import '../features/expenses/expenses_screen.dart';
import '../features/fuel/fuel_history_screen.dart';
import '../features/fuel/fuel_log_screen.dart';
import '../features/garage/garage_screen.dart';
import '../features/onboarding/add_vehicle_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/onboarding/rc_scan_screen.dart';
import '../features/onboarding/vehicle_details_screen.dart';
import '../features/service/service_screen.dart';
import '../data/models/rc_details.dart';
import '../data/repositories/vehicle_repository.dart';
import '../features/settings/settings_screen.dart';

// Bridges Firebase auth stream → GoRouter refreshListenable.
class _AuthRefreshNotifier extends ChangeNotifier {
  late final StreamSubscription<User?> _sub;
  _AuthRefreshNotifier(Stream<User?> stream) {
    _sub = stream.listen((_) => notifyListeners());
  }
  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

// ---------------------------------------------------------------------------
// No-vehicle selected placeholder (shown when tab tapped before any vehicle is active)
// ---------------------------------------------------------------------------
class _NoVehiclePlaceholder extends StatelessWidget {
  const _NoVehiclePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(context.l10n.noVehicleSelected,
            style: const TextStyle(color: Colors.grey)),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Bottom nav shell — reads activeVehicleIdProvider to navigate tabs with vehicleId
// ---------------------------------------------------------------------------
class _NavShell extends ConsumerWidget {
  final StatefulNavigationShell shell;
  const _NavShell({required this.shell});

  static List<String> _tabs(AppLocalizations l) =>
      [l.navHome, l.expensesTitle, l.expenseService, l.navDocs];

  void _onTap(BuildContext context, WidgetRef ref, int index) {
    HapticFeedback.selectionClick();
    final vehicleId = ref.read(activeVehicleIdProvider);
    switch (index) {
      case 0:
        // Home is the active vehicle's dashboard; the garage list is one
        // step back from there.
        if (vehicleId != null) {
          context.go('/garage/dashboard/$vehicleId');
        } else {
          shell.goBranch(0, initialLocation: index == shell.currentIndex);
        }
      case 1:
        if (vehicleId != null) {
          context.go('/expenses/$vehicleId');
        } else {
          shell.goBranch(1, initialLocation: index == shell.currentIndex);
        }
      case 2:
        if (vehicleId != null) {
          context.go('/service/$vehicleId');
        } else {
          shell.goBranch(2, initialLocation: index == shell.currentIndex);
        }
      case 3:
        if (vehicleId != null) {
          context.go('/documents/$vehicleId');
        } else {
          shell.goBranch(3, initialLocation: index == shell.currentIndex);
        }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AuroraBackdrop(
      child: Scaffold(
        body: Column(
          children: [
            const OfflineBanner(),
            Expanded(child: shell),
          ],
        ),
        bottomNavigationBar: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, AppSpacing.xs, AppSpacing.lg, AppSpacing.md),
            child: LiveryNavBar(
              labels: _tabs(context.l10n),
              selectedIndex: shell.currentIndex,
              onSelected: (i) => _onTap(context, ref, i),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Router provider
// ---------------------------------------------------------------------------
final appRouterProvider = Provider<GoRouter>((ref) {
  final authService = getIt<AuthService>();
  final refreshNotifier = _AuthRefreshNotifier(authService.authStateChanges);
  ref.onDispose(refreshNotifier.dispose);

  return GoRouter(
    initialLocation: '/home',
    refreshListenable: refreshNotifier,
    redirect: (context, state) async {
      final isAuthed = authService.currentUser != null;
      final loc = state.matchedLocation;
      final isOnAuth = loc == '/auth';
      final isOnOnboarding = loc.startsWith('/onboarding');

      // Auth gate — redirect unauthenticated users to /auth.
      if (!isAuthed && !isOnAuth && !isOnOnboarding) return '/auth';
      if (isAuthed && isOnAuth) return '/home';

      // Onboarding gate — shown once after first sign-in.
      final prefs = await SharedPreferences.getInstance();
      final done = prefs.getBool(SharedPrefKeys.isOnboardingDone) ?? false;
      if (!done && !isOnOnboarding) return '/onboarding';

      return null;
    },
    routes: [
      // Launch target: open straight on the vehicle the rider last used.
      GoRoute(
        path: '/home',
        redirect: (context, state) async {
          final prefs = await SharedPreferences.getInstance();
          final vehicles = await getIt<VehicleRepository>().getAllVehicles();
          final id = pickHomeVehicle(
            [for (final v in vehicles) v.id],
            prefs.getString(SharedPrefKeys.activeVehicleId),
          );
          if (id == null) return '/garage';
          ref.read(activeVehicleIdProvider.notifier).state = id;
          return '/garage/dashboard/$id';
        },
      ),

      // Auth (sign in with phone OTP)
      GoRoute(
        path: '/auth',
        pageBuilder: (context, state) =>
            _fade(state, const AuthScreen()),
      ),

      // Onboarding (shown once)
      GoRoute(
        path: '/onboarding',
        pageBuilder: (context, state) =>
            _fade(state, const OnboardingScreen()),
      ),

      // Add vehicle: scan RC, look up by number, or enter manually
      GoRoute(
        path: '/onboarding/add-vehicle',
        pageBuilder: (context, state) =>
            _slide(state, const AddVehicleScreen()),
      ),
      GoRoute(
        path: '/onboarding/scan-rc',
        pageBuilder: (context, state) =>
            _slide(state, const RcScanScreen()),
      ),
      GoRoute(
        path: '/onboarding/vehicle-details',
        pageBuilder: (context, state) {
          final extra = state.extra! as Map<String, dynamic>;
          return _slide(
            state,
            VehicleDetailsScreen(
              details: extra['details'] as RcDetails,
              source: extra['source'] as RcPrefill? ??
                  RcPrefill.lookup,
              prefillSuccess: extra['prefillSuccess'] as bool,
              failureReason: extra['failureReason'] as String?,
            ),
          );
        },
      ),

      // Main tabbed shell
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => _NavShell(shell: shell),
        branches: [
          // Home tab: garage → dashboard → fuel
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/garage',
              pageBuilder: (context, state) =>
                  _fade(state, const GarageScreen()),
              routes: [
                GoRoute(
                  path: 'dashboard/:vehicleId',
                  pageBuilder: (context, state) => _slide(
                    state,
                    DashboardScreen(
                      vehicleId: state.pathParameters['vehicleId']!,
                      // From a reminder: open that date's editor.
                      edit: state.uri.queryParameters['edit'],
                    ),
                  ),
                  routes: [
                    GoRoute(
                      path: 'fuel/log',
                      pageBuilder: (context, state) => _slide(
                        state,
                        FuelLogScreen(
                            vehicleId: state.pathParameters['vehicleId']!),
                      ),
                    ),
                    GoRoute(
                      path: 'fuel/history',
                      pageBuilder: (context, state) => _slide(
                        state,
                        FuelHistoryScreen(
                            vehicleId: state.pathParameters['vehicleId']!),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ]),

          // Expenses tab
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/expenses',
              pageBuilder: (context, state) =>
                  _fade(state, const _NoVehiclePlaceholder()),
            ),
            GoRoute(
              path: '/expenses/:vehicleId',
              pageBuilder: (context, state) => _fade(
                state,
                ExpensesScreen(vehicleId: state.pathParameters['vehicleId']!),
              ),
            ),
          ]),

          // Service tab
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/service',
              pageBuilder: (context, state) =>
                  _fade(state, const _NoVehiclePlaceholder()),
            ),
            GoRoute(
              path: '/service/:vehicleId',
              pageBuilder: (context, state) => _fade(
                state,
                ServiceScreen(vehicleId: state.pathParameters['vehicleId']!),
              ),
            ),
          ]),

          // Documents tab
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/documents',
              pageBuilder: (context, state) =>
                  _fade(state, const _NoVehiclePlaceholder()),
            ),
            GoRoute(
              path: '/documents/:vehicleId',
              pageBuilder: (context, state) => _fade(
                state,
                DocumentsScreen(
                    vehicleId: state.pathParameters['vehicleId']!),
              ),
            ),
          ]),
        ],
      ),

      // Settings (full-screen push, outside tab shell)
      GoRoute(
        path: '/settings',
        pageBuilder: (context, state) =>
            _slide(state, const SettingsScreen()),
      ),
    ],
  );
});

// ---------------------------------------------------------------------------
// Page transition helpers
// ---------------------------------------------------------------------------
// Every page sits on its own aurora backdrop, so pages never show through
// each other mid-transition.

/// Tab switches and top-level screens: fade in while settling from a hair
/// smaller.
CustomTransitionPage<void> _fade(GoRouterState state, Widget child) =>
    CustomTransitionPage<void>(
      key: state.pageKey,
      child: AuroraBackdrop(child: child),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved =
            CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.985, end: 1).animate(curved),
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 260),
    );

/// Drill-down screens: slide in from the side while the page underneath
/// eases away in parallax.
CustomTransitionPage<void> _slide(GoRouterState state, Widget child) =>
    CustomTransitionPage<void>(
      key: state.pageKey,
      child: AuroraBackdrop(child: child),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final dir = Directionality.of(context) == TextDirection.rtl ? -1.0 : 1.0;
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(dir, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          )),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: Offset.zero,
              end: Offset(-0.25 * dir, 0),
            ).animate(CurvedAnimation(
              parent: secondaryAnimation,
              curve: Curves.easeOutCubic,
            )),
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 320),
      reverseTransitionDuration: const Duration(milliseconds: 260),
    );
