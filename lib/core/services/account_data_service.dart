import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';
import '../../data/database/app_database.dart';
import 'auth_service.dart';
import 'firestore_service.dart';
import 'reminder_service.dart';
import 'restore_service.dart';
import 'storage_service.dart';
import 'sync_service.dart';

/// One account per phone: the local garage belongs to whoever is signed in.
///
/// SQLite is the app's source of truth and isn't split by user, so this
/// records the owning uid ([SharedPrefKeys.localDataOwner]) and keeps it
/// honest — signing out wipes the garage, signing into a different account
/// starts from empty and restores that account's backup, and the sync queue
/// only uploads for the owner.
class AccountDataService {
  final AppDatabase _db;
  final AuthService _auth;
  final SyncService _sync;
  final RestoreService _restore;
  final FirestoreService _firestore;
  final StorageService _storage;
  final ReminderService _reminders;

  AccountDataService(
    this._db,
    this._auth,
    this._sync,
    this._restore,
    this._firestore,
    this._storage,
    this._reminders,
  );

  /// Bumped whenever the local garage is wiped or replaced, so screens
  /// holding loaded data reload (see `localDataEpochProvider`).
  static final changes = ValueNotifier<int>(0);

  /// True while a sign-in is still setting up the garage (wipe, restore).
  /// The router holds the sign-in screen until it's false, so a returning
  /// user isn't sent to "add your first vehicle" before their backup lands.
  static final settingUp = ValueNotifier<bool>(false);

  static const _cloudTimeout = Duration(seconds: 20);

  /// Squares the local garage with whoever is signed in at launch: covers a
  /// sign-out that was cut short and installs from before ownership existed.
  Future<void> reconcileOnLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final owner = prefs.getString(SharedPrefKeys.localDataOwner);
    // The first auth event is the restored session — don't mistake a
    // session still loading for a signed-out phone.
    final user = await _auth.authStateChanges.first.timeout(
      const Duration(seconds: 5),
      onTimeout: () => _auth.currentUser,
    );
    final uid = user?.uid;
    if (uid != null) {
      await claim(uid);
    } else if (owner != null || await _hasLocalData()) {
      // Nobody is signed in, so nothing here belongs to anyone.
      await _wipeLocal();
    }
  }

  /// Call right after every sign-in. Makes the local garage [uid]'s: if it
  /// belonged to another account it's wiped first. With [restore], brings
  /// in [uid]'s backup; returns whether there was one.
  Future<bool> claim(String uid, {bool restore = false}) async {
    final prefs = await SharedPreferences.getInstance();
    final owner = prefs.getString(SharedPrefKeys.localDataOwner);
    var changed = false;
    if (owner != null && owner != uid) {
      await _wipeLocal();
      changed = true;
    }
    await prefs.setString(SharedPrefKeys.localDataOwner, uid);

    var restored = false;
    if (restore) {
      restored = await _restore.restoreIfNeeded(uid);
      if (restored) {
        await prefs.setBool(SharedPrefKeys.isOnboardingDone, true);
        changed = true;
      }
    }
    if (changed) _changed();
    _sync.pushPending();
    return restored;
  }

  /// A guest backed up into a Google account that already existed: the
  /// guest's garage moves into it (all of it is queued for upload) and the
  /// account's own backup is brought in alongside.
  Future<void> adopt(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(SharedPrefKeys.localDataOwner, uid);
    await _sync.queueAll();
    await _restore.restoreIfNeeded(uid);
    _changed();
    _sync.pushPending();
  }

  /// The slow, network part of signing out — run it behind a progress
  /// indicator, then call [signOut]. An account uploads what's pending and
  /// returns false if some of it couldn't be (offline). A guest's garage
  /// can't be recovered once wiped, so its cloud copy is deleted instead.
  Future<bool> prepareSignOut() async {
    final user = _auth.currentUser;
    if (user == null) return true;
    if (user.isAnonymous) {
      try {
        await _sync.clearQueue();
        await _firestore.deleteUserData(user.uid).timeout(_cloudTimeout);
        await _storage.deleteUserFiles(user.uid).timeout(_cloudTimeout);
      } catch (e) {
        // Offline: what's left is unreachable without the guest session.
        debugPrint('Sign out: guest cloud cleanup failed: $e');
      }
      return true;
    }
    try {
      await _sync.pushPending().timeout(_cloudTimeout);
    } catch (e) {
      debugPrint('Sign out: upload failed: $e');
    }
    return await _sync.pendingCount() == 0;
  }

  /// Signs out (a guest's anonymous account is deleted) and removes the
  /// garage from this phone. Call [prepareSignOut] first.
  Future<void> signOut() async {
    final user = _auth.currentUser;
    if (user != null && user.isAnonymous) {
      try {
        await _auth.deleteAccount(eraseCloud: (_) async {});
      } catch (e) {
        debugPrint('Sign out: guest delete failed: $e');
        await _auth.signOut();
      }
    } else {
      await _auth.signOut();
    }
    await _wipeLocal();
  }

  /// "Clear all data": deletes the garage from this phone and the backup,
  /// staying signed in. Throws if the backup couldn't be deleted (offline),
  /// leaving the phone's copy untouched.
  Future<void> clearAll() async {
    final uid = _auth.currentUser?.uid;
    // Stop queued uploads re-creating what's being deleted.
    await _sync.clearQueue();
    if (uid != null) {
      try {
        await _firestore.deleteUserData(uid).timeout(_cloudTimeout);
        await _storage.deleteUserFiles(uid).timeout(_cloudTimeout);
      } catch (_) {
        await _sync.queueAll(); // the phone's copy stays backed up
        rethrow;
      }
    }
    await _wipeLocal(signedOut: false);
  }

  /// Deletes the account and its backup, then the phone's copy.
  Future<void> deleteAccount() async {
    await _auth.deleteAccount(eraseCloud: (uid) async {
      await _sync.clearQueue();
      await _firestore.deleteUserData(uid);
      await _storage.deleteUserFiles(uid);
    });
    await _wipeLocal();
  }

  Future<bool> _hasLocalData() async {
    final db = await _db.db;
    return (await db.query('vehicles', limit: 1)).isNotEmpty;
  }

  /// Empties the phone's garage. When [signedOut] it belongs to no one any
  /// more and onboarding starts over; Clear all data keeps both.
  Future<void> _wipeLocal({bool signedOut = true}) async {
    await _db.wipeAll();
    await _reminders.forgetAll();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(SharedPrefKeys.activeVehicleId);
    await prefs.remove(SharedPrefKeys.backupNudgeDismissedAt);
    if (signedOut) {
      await prefs.remove(SharedPrefKeys.isOnboardingDone);
      await prefs.remove(SharedPrefKeys.localDataOwner);
    }
    _changed();
  }

  void _changed() => changes.value++;
}
