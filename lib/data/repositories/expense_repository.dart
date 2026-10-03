import '../database/app_database.dart';
import '../models/expense.dart';
import '../../core/services/sync_service.dart';

class ExpenseRepository {
  final AppDatabase _db;

  ExpenseRepository(this._db);

  Future<String> insertExpense(Expense expense) async {
    final db = await _db.db;
    await db.insert('expenses', expense.toMap());
    await SyncService.queueUpsert(db, 'expenses', expense.toMap());
    return expense.id;
  }

  Future<void> deleteExpense(String id) async {
    final db = await _db.db;
    await SyncService.queueDelete(db, 'expenses', id);
    await db.delete('expenses', where: 'id = ?', whereArgs: [id]);
  }
}
