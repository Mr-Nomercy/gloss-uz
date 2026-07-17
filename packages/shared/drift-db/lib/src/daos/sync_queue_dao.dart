import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/sync_queue.dart';

class SyncQueueDao {
  final AppDatabase _db;
  SyncQueueDao(this._db);

  Future<int> enqueue(SyncQueueCompanion entry) => _db.into(_db.syncQueue).insert(entry);

  Future<List<SyncQueueData>> getPending() => _db.select(_db.syncQueue)
    .where((t) => t.status.equals('pending'))
    .orderBy([(t) => OrderingTerm(expression: t.createdAt)])
    .get();

  Future<void> markSynced(int id) => _db.update(_db.syncQueue).replace(
    SyncQueueCompanion(id: Value(id), status: const Constant('synced')),
  );

  Future<void> markFailed(int id) => _db.update(_db.syncQueue).replace(
    SyncQueueCompanion(id: Value(id), status: const Constant('failed')),
  );

  Future<void> incrementRetry(int id) => _db.customUpdate(
    'UPDATE sync_queue SET retry_count = retry_count + 1 WHERE id = ?',
    variables: [Variable.withInt(id)],
  );

  Future<int> pendingCount() => _db.select(_db.syncQueue)
    .where((t) => t.status.equals('pending'))
    .map((_) => 1)
    .get()
    .then((r) => r.length);
}
