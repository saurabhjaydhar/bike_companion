import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:garajo/core/constants/app_constants.dart';
import 'package:garajo/core/services/account_data_service.dart';
import 'package:garajo/core/services/auth_service.dart';
import 'package:garajo/core/services/firestore_service.dart';
import 'package:garajo/core/services/reminder_service.dart';
import 'package:garajo/core/services/restore_service.dart';
import 'package:garajo/core/services/storage_service.dart';
import 'package:garajo/core/services/sync_service.dart';
import 'package:garajo/data/database/app_database.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class _User implements User {
  @override
  final String uid;
  @override
  final bool isAnonymous;
  _User(this.uid, {this.isAnonymous = false});
  @override
  dynamic noSuchMethod(Invocation i) => super.noSuchMethod(i);
}

class _Auth implements AuthService {
  @override
  User? currentUser;
  bool deleted = false;

  @override
  bool get isAnonymous => currentUser?.isAnonymous ?? false;

  @override
  Stream<User?> get authStateChanges => Stream.value(currentUser);

  @override
  Future<void> signOut() async => currentUser = null;

  @override
  Future<void> deleteAccount({
    required Future<void> Function(String uid) eraseCloud,
  }) async {
    await eraseCloud(currentUser!.uid);
    deleted = true;
    currentUser = null;
  }

  @override
  dynamic noSuchMethod(Invocation i) => super.noSuchMethod(i);
}

class _Sync implements SyncService {
  int pending = 0;
  int queuedAll = 0;

  @override
  Future<void> pushPending() async {}
  @override
  Future<int> pendingCount() async => pending;
  @override
  Future<void> queueAll() async => queuedAll++;
  @override
  Future<void> clearQueue() async => pending = 0;
  @override
  dynamic noSuchMethod(Invocation i) => super.noSuchMethod(i);
}

/// Restores one vehicle for every uid in [backups].
class _Restore implements RestoreService {
  final Database db;
  final Set<String> backups = {};
  _Restore(this.db);

  @override
  Future<bool> restoreIfNeeded(String uid) async {
    if (!backups.contains(uid)) return false;
    await _insertVehicle(db, 'cloud-$uid');
    return true;
  }

  @override
  dynamic noSuchMethod(Invocation i) => super.noSuchMethod(i);
}

class _Firestore implements FirestoreService {
  final deletedFor = <String>[];
  bool offline = false;

  @override
  Future<void> deleteUserData(String uid) async {
    if (offline) throw Exception('offline');
    deletedFor.add(uid);
  }

  @override
  dynamic noSuchMethod(Invocation i) => super.noSuchMethod(i);
}

class _Storage implements StorageService {
  @override
  Future<void> deleteUserFiles(String uid) async {}
  @override
  dynamic noSuchMethod(Invocation i) => super.noSuchMethod(i);
}

class _Reminders implements ReminderService {
  int forgotten = 0;
  @override
  Future<void> forgetAll() async => forgotten++;
  @override
  dynamic noSuchMethod(Invocation i) => super.noSuchMethod(i);
}

Future<void> _insertVehicle(Database db, String id) => db.insert('vehicles', {
      'id': id,
      'name': 'Bullet',
      'brand': 'Royal Enfield',
      'model': 'Classic 350',
      'reg_number': 'MH12DE1234',
      'created_at': 0,
    });

void main() {
  late Directory dir;
  late Database db;
  late _Auth auth;
  late _Sync sync;
  late _Restore restore;
  late _Firestore firestore;
  late _Reminders reminders;
  late AccountDataService account;

  Future<List<String>> vehicleIds() async =>
      [for (final r in await db.query('vehicles')) r['id'] as String];
  Future<String?> owner() async => (await SharedPreferences.getInstance())
      .getString(SharedPrefKeys.localDataOwner);

  setUpAll(sqfliteFfiInit);
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    dir = Directory.systemTemp.createTempSync('account');
    db = await AppDatabase.openAt(databaseFactoryFfi, join(dir.path, 'a.db'));
    auth = _Auth();
    sync = _Sync();
    restore = _Restore(db);
    firestore = _Firestore();
    reminders = _Reminders();
    account = AccountDataService(AppDatabase.wrap(db), auth, sync, restore,
        firestore, _Storage(), reminders);
  });
  tearDown(() async {
    await db.close();
    dir.deleteSync(recursive: true);
  });

  group('claim', () {
    test('a first sign-in keeps what is on the phone', () async {
      await _insertVehicle(db, 'mine');
      await account.claim('alice');
      expect(await vehicleIds(), ['mine']);
      expect(await owner(), 'alice');
    });

    test('the same account signing in again keeps its garage', () async {
      await account.claim('alice');
      await _insertVehicle(db, 'mine');
      await account.claim('alice');
      expect(await vehicleIds(), ['mine']);
    });

    test('another account starts from its own garage', () async {
      await account.claim('alice');
      await _insertVehicle(db, 'alice-bike');
      restore.backups.add('bob');
      final changes = AccountDataService.changes.value;

      final restored = await account.claim('bob', restore: true);

      expect(restored, isTrue);
      expect(await vehicleIds(), ['cloud-bob']);
      expect(await owner(), 'bob');
      expect(reminders.forgotten, 1);
      expect(AccountDataService.changes.value, greaterThan(changes));
    });

    test('a restore marks onboarding done', () async {
      restore.backups.add('alice');
      await account.claim('alice', restore: true);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool(SharedPrefKeys.isOnboardingDone), isTrue);
    });
  });

  test('adopt keeps the guest garage and queues it for the new account',
      () async {
    await account.claim('guest');
    await _insertVehicle(db, 'guest-bike');
    restore.backups.add('alice');

    await account.adopt('alice');

    expect(await vehicleIds(), unorderedEquals(['guest-bike', 'cloud-alice']));
    expect(await owner(), 'alice');
    expect(sync.queuedAll, 1);
  });

  group('reconcileOnLaunch', () {
    test('wipes a garage nobody is signed in to', () async {
      await _insertVehicle(db, 'leftover');
      await account.reconcileOnLaunch();
      expect(await vehicleIds(), isEmpty);
    });

    test('hands an ownerless garage to the signed-in user', () async {
      auth.currentUser = _User('alice');
      await _insertVehicle(db, 'mine');
      await account.reconcileOnLaunch();
      expect(await vehicleIds(), ['mine']);
      expect(await owner(), 'alice');
    });
  });

  group('sign out', () {
    test('an account with everything uploaded signs out and wipes', () async {
      auth.currentUser = _User('alice');
      await account.claim('alice');
      await _insertVehicle(db, 'mine');
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(SharedPrefKeys.isOnboardingDone, true);

      expect(await account.prepareSignOut(), isTrue);
      await account.signOut();

      expect(auth.currentUser, isNull);
      expect(await vehicleIds(), isEmpty);
      expect(await owner(), isNull);
      expect(prefs.getBool(SharedPrefKeys.isOnboardingDone), isNull);
    });

    test('unuploaded changes hold the sign-out back', () async {
      auth.currentUser = _User('alice');
      sync.pending = 2;
      expect(await account.prepareSignOut(), isFalse);
      expect(auth.currentUser, isNotNull);
    });

    test('a guest is deleted along with its cloud copy', () async {
      auth.currentUser = _User('guest', isAnonymous: true);
      await account.claim('guest');
      await _insertVehicle(db, 'guest-bike');

      expect(await account.prepareSignOut(), isTrue);
      await account.signOut();

      expect(firestore.deletedFor, ['guest']);
      expect(auth.deleted, isTrue);
      expect(await vehicleIds(), isEmpty);
    });
  });

  group('clear all data', () {
    test('empties the phone and the backup, staying signed in', () async {
      auth.currentUser = _User('alice');
      await account.claim('alice');
      await _insertVehicle(db, 'mine');

      await account.clearAll();

      expect(firestore.deletedFor, ['alice']);
      expect(await vehicleIds(), isEmpty);
      expect(await owner(), 'alice');
    });

    test('offline, keeps the phone copy and re-queues it', () async {
      auth.currentUser = _User('alice');
      await account.claim('alice');
      await _insertVehicle(db, 'mine');
      firestore.offline = true;

      await expectLater(account.clearAll(), throwsException);

      expect(await vehicleIds(), ['mine']);
      expect(sync.queuedAll, 1);
    });
  });
}
