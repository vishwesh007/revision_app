import 'package:drift/drift.dart';
import 'package:drift/web.dart';

LazyDatabase openConnection() {
  // Use IndexedDB-backed Drift web database
  final webDb = WebDatabase('revision_buddy');
  return LazyDatabase(() async => webDb);
}
