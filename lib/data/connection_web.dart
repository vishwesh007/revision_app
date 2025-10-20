import 'package:drift/drift.dart';
// ignore: deprecated_member_use
import 'package:drift/web.dart';

LazyDatabase openConnection() {
  // Use IndexedDB-backed Drift web database
  final webDb = WebDatabase('revision_buddy');
  return LazyDatabase(() async => webDb);
}
