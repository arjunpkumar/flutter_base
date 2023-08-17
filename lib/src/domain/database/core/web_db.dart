// web.dart
import 'package:drift/drift.dart';
import 'package:drift/web.dart';
import 'package:flutter_base/src/domain/database/core/app_database.dart';

AppDatabase constructDb() {
  final db = LazyDatabase(() async {
    final storage = await DriftWebStorage.indexedDbIfSupported('db');
    return WebDatabase.withStorage(storage);
  });
  return AppDatabase(db);
}
