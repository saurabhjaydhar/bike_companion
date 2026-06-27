import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/auth_service.dart';
import '../../main.dart';

/// Streams the Firebase auth state — null means signed out.
final authStateProvider = StreamProvider<User?>((ref) {
  return getIt<AuthService>().authStateChanges;
});

/// True when the user is authenticated.
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authStateProvider).valueOrNull != null;
});
