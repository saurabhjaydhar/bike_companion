import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/local_data_provider.dart';
import '../../data/models/document.dart';
import '../../core/services/storage_service.dart';
import '../../data/repositories/document_repository.dart';
import '../../main.dart';

class DocumentsNotifier
    extends FamilyAsyncNotifier<List<VehicleDocument>, String> {
  @override
  Future<List<VehicleDocument>> build(String arg) async {
    ref.watch(localDataEpochProvider);
    // Reminders are re-planned by ReminderService after every write.
    return getIt<DocumentRepository>().getDocuments(arg);
  }

  Future<void> addDocument(VehicleDocument doc) async {
    await getIt<DocumentRepository>().insertDocument(doc);
    await _reload();
  }

  Future<void> updateDocument(VehicleDocument doc) async {
    await getIt<DocumentRepository>().updateDocument(doc);
    await _reload();
  }

  Future<void> deleteDocument(String id) async {
    final doc = state.valueOrNull?.where((d) => d.id == id).firstOrNull;
    await getIt<DocumentRepository>().deleteDocument(id);
    // Its photo goes too, if it was uploaded.
    final file = doc?.filePath;
    if (file != null) await getIt<StorageService>().deleteDocumentFile(file);
    await _reload();
  }

  Future<void> _reload() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => getIt<DocumentRepository>().getDocuments(arg));
  }
}

final documentsProvider =
    AsyncNotifierProvider.family<DocumentsNotifier, List<VehicleDocument>, String>(
  DocumentsNotifier.new,
);
