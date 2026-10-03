import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

/// Document photos in Firebase Storage, kept under `users/{uid}/` so
/// Storage rules can limit each user to their own files.
class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Uploads a document photo; returns its download URL.
  Future<String> uploadDocument(
    String uid,
    String vehicleId,
    String docId,
    String filePath,
  ) async {
    final ref = _storage
        .ref('users/$uid/documents/$vehicleId/$docId${_ext(filePath)}');
    final task = await ref.putFile(File(filePath));
    return task.ref.getDownloadURL();
  }

  /// Deletes the photo at [url] (a download URL from [uploadDocument]).
  /// Local file paths and missing files are ignored.
  Future<void> deleteDocumentFile(String url) async {
    if (!url.startsWith('http')) return;
    try {
      await _storage.refFromURL(url).delete();
    } catch (_) {}
  }

  /// Deletes every file stored for [uid] — part of deleting an account.
  Future<void> deleteUserFiles(String uid) => _deleteAll(_storage.ref('users/$uid'));

  Future<void> _deleteAll(Reference ref) async {
    final listing = await ref.listAll();
    for (final item in listing.items) {
      await item.delete();
    }
    for (final folder in listing.prefixes) {
      await _deleteAll(folder);
    }
  }

  String _ext(String path) {
    final dot = path.lastIndexOf('.');
    return dot >= 0 ? path.substring(dot) : '';
  }
}
