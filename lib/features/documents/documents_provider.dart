import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/notification_service.dart';
import '../../data/models/document.dart';
import '../../data/repositories/document_repository.dart';
import '../../main.dart';

class DocumentsNotifier
    extends FamilyAsyncNotifier<List<BikeDocument>, String> {
  @override
  Future<List<BikeDocument>> build(String arg) async {
    final docs = await getIt<DocumentRepository>().getDocuments(arg);
    NotificationService.scheduleDocumentReminders(docs);
    return docs;
  }

  Future<void> addDocument(BikeDocument doc) async {
    await getIt<DocumentRepository>().insertDocument(doc);
    await _reload();
  }

  Future<void> updateDocument(BikeDocument doc) async {
    await getIt<DocumentRepository>().updateDocument(doc);
    await _reload();
  }

  Future<void> deleteDocument(String id) async {
    await NotificationService.cancelDocumentReminders(id);
    await getIt<DocumentRepository>().deleteDocument(id);
    await _reload();
  }

  Future<void> _reload() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final docs = await getIt<DocumentRepository>().getDocuments(arg);
      NotificationService.scheduleDocumentReminders(docs);
      return docs;
    });
  }
}

final documentsProvider =
    AsyncNotifierProvider.family<DocumentsNotifier, List<BikeDocument>, String>(
  DocumentsNotifier.new,
);
