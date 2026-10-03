import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadDocument(
      String vehicleId, String docId, String filePath) async {
    final file = File(filePath);
    final ext = _ext(filePath);
    final ref = _storage.ref('documents/$vehicleId/$docId$ext');
    final task = await ref.putFile(file);
    return task.ref.getDownloadURL();
  }

  Future<void> deleteDocument(String vehicleId, String docId) async {
    try {
      await _storage.ref('documents/$vehicleId/$docId').delete();
    } catch (_) {}
  }

  String _ext(String path) {
    final dot = path.lastIndexOf('.');
    return dot >= 0 ? path.substring(dot) : '';
  }
}
