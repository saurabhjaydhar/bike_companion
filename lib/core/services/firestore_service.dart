import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore path structure:
///   users/{uid}/bikes/{bikeId}
///   users/{uid}/bikes/{bikeId}/fuel_logs/{logId}
///   users/{uid}/bikes/{bikeId}/service_records/{recordId}
///   users/{uid}/bikes/{bikeId}/expenses/{expenseId}
///   users/{uid}/bikes/{bikeId}/documents/{docId}
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

  CollectionReference<Map<String, dynamic>> _bikesRef(String uid) =>
      _db.collection('users').doc(uid).collection('bikes');

  CollectionReference<Map<String, dynamic>> _subRef(
          String uid, String bikeId, String collection) =>
      _db
          .collection('users')
          .doc(uid)
          .collection('bikes')
          .doc(bikeId)
          .collection(collection);

  // ---------------------------------------------------------------------------
  // Push (upsert) methods — called by SyncService
  // ---------------------------------------------------------------------------

  Future<void> pushBike(String uid, Map<String, dynamic> data) async {
    await _bikesRef(uid)
        .doc(data['id'] as String)
        .set(data, SetOptions(merge: true));
  }

  Future<void> pushRecord(
    String uid,
    String bikeId,
    String collection,
    Map<String, dynamic> data,
  ) async {
    await _subRef(uid, bikeId, collection)
        .doc(data['id'] as String)
        .set(data, SetOptions(merge: true));
  }

  Future<void> deleteBike(String uid, String bikeId) async {
    await _bikesRef(uid).doc(bikeId).delete();
  }

  Future<void> deleteRecord(
      String uid, String bikeId, String collection, String id) async {
    await _subRef(uid, bikeId, collection).doc(id).delete();
  }

  // ---------------------------------------------------------------------------
  // Restore — fetch all user data from Firestore
  // ---------------------------------------------------------------------------

  Future<List<Map<String, dynamic>>> fetchBikes(String uid) async {
    final snap = await _bikesRef(uid).get();
    return snap.docs.map((d) => d.data()).toList();
  }

  Future<List<Map<String, dynamic>>> fetchCollection(
      String uid, String bikeId, String collection) async {
    final snap = await _subRef(uid, bikeId, collection).get();
    return snap.docs.map((d) => d.data()).toList();
  }

  Future<bool> userHasData(String uid) async {
    final snap = await _bikesRef(uid).limit(1).get();
    return snap.docs.isNotEmpty;
  }
}
