import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore path structure:
///   users/{uid}/vehicles/{vehicleId}
///   users/{uid}/vehicles/{vehicleId}/fuel_logs/{logId}
///   users/{uid}/vehicles/{vehicleId}/service_records/{recordId}
///   users/{uid}/vehicles/{vehicleId}/expenses/{expenseId}
///   users/{uid}/vehicles/{vehicleId}/documents/{docId}
///
/// Security rules (paste in Firebase Console → Firestore → Rules):
/// ---
/// rules_version = '2';
/// service cloud.firestore {
///   match /databases/{database}/documents {
///     match /users/{userId}/{document=**} {
///       allow read, write: if request.auth != null && request.auth.uid == userId;
///     }
///   }
/// }
class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _vehiclesRef(String uid) =>
      _db.collection('users').doc(uid).collection('vehicles');

  CollectionReference<Map<String, dynamic>> _subRef(
          String uid, String vehicleId, String collection) =>
      _db
          .collection('users')
          .doc(uid)
          .collection('vehicles')
          .doc(vehicleId)
          .collection(collection);

  // ---------------------------------------------------------------------------
  // Push (upsert) methods — called by SyncService
  // ---------------------------------------------------------------------------

  Future<void> pushVehicle(String uid, Map<String, dynamic> data) async {
    await _vehiclesRef(uid)
        .doc(data['id'] as String)
        .set(data, SetOptions(merge: true));
  }

  Future<void> pushRecord(
    String uid,
    String vehicleId,
    String collection,
    Map<String, dynamic> data,
  ) async {
    await _subRef(uid, vehicleId, collection)
        .doc(data['id'] as String)
        .set(data, SetOptions(merge: true));
  }

  Future<void> deleteVehicle(String uid, String vehicleId) async {
    await _vehiclesRef(uid).doc(vehicleId).delete();
  }

  Future<void> deleteRecord(
      String uid, String vehicleId, String collection, String id) async {
    await _subRef(uid, vehicleId, collection).doc(id).delete();
  }

  // ---------------------------------------------------------------------------
  // Restore — fetch all user data from Firestore
  // ---------------------------------------------------------------------------

  Future<List<Map<String, dynamic>>> fetchVehicles(String uid) async {
    final snap = await _vehiclesRef(uid).get();
    return snap.docs.map((d) => d.data()).toList();
  }

  Future<List<Map<String, dynamic>>> fetchCollection(
      String uid, String vehicleId, String collection) async {
    final snap = await _subRef(uid, vehicleId, collection).get();
    return snap.docs.map((d) => d.data()).toList();
  }

  Future<bool> userHasData(String uid) async {
    final snap = await _vehiclesRef(uid).limit(1).get();
    return snap.docs.isNotEmpty;
  }

  Future<void> saveUserProfile(
      String uid, {String? name, String? email}) async {
    await _db.collection('users').doc(uid).set({
      'name': name ?? '',
      'email': email ?? '',
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
