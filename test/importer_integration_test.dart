import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:path/path.dart' as p;
import 'package:revision_buddy/data/database.dart';
import 'package:revision_buddy/data/importer.dart';

void main() {
  late AppDatabase db;
  late Directory tempRoot;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    tempRoot = await Directory.systemTemp.createTemp('rev_app_test_');
  });

  tearDown(() async {
    await db.close();
    if (await tempRoot.exists()) {
      await tempRoot.delete(recursive: true);
    }
  });

  Future<Directory> tempProvider() async => tempRoot;

  group('Importer robust behavior', () {
    test('Imports valid JSON file from disk', () async {
  final importer = DatabaseImporter(db, tempDirProvider: tempProvider);

      final file = File(p.join(tempRoot.path, 'data.json'));
      await file.writeAsString(jsonEncode({
        'decks': [
          {
            'id': 'd1',
            'title': 'Deck 1',
            'description': 'Desc',
            'createdAt': '2025-10-01T00:00:00.000Z'
          }
        ],
        'questions': [
          {
            'id': 'q1',
            'deckId': 'd1',
            'type': 'mcq',
            'prompt': 'P?',
            'metadata': '{}',
            'choices': [
              {'id': 'c1', 'text': 'A', 'isCorrect': true}
            ]
          }
        ]
      }));

      final res = await importer.importFromFile(file.path);
      expect(res.success, isTrue);
      expect(res.decksImported, 1);
      expect(res.questionsImported, 1);
    });

    test('Detects SQLite by magic number even if .json extension', () async {
  final importer = DatabaseImporter(db, tempDirProvider: tempProvider);

      // Create a dummy SQLite-like header file
      final sqliteHeader = utf8.encode('SQLite format 3');
      final bytes = <int>[...sqliteHeader, 0]; // trailing \0 to make 16 bytes
      final file = File(p.join(tempRoot.path, 'wrong.json'));
      await file.writeAsBytes(bytes);

      final res = await importer.importFromFile(file.path);
      // It will try to import as SQLite and fail with invalid format
      // but should NOT try to parse JSON first
      expect(res.success, isFalse);
      expect(res.message, contains('Invalid SQLite'));
    });

    test('Falls back from JSON to SQLite when extension unknown', () async {
  final importer = DatabaseImporter(db, tempDirProvider: tempProvider);

      // Build a minimal valid SQLite database file using drift
      final sqliteFile = File(p.join(tempRoot.path, 'source.db'));
      final srcDb = AppDatabase.forTesting(NativeDatabase(sqliteFile));
      // Seed one deck
      await srcDb.insertDeck(DecksCompanion.insert(
        id: 'dX',
        title: 'DeckX',
        description: 'Desc',
        createdAt: DateTime.utc(2025, 10, 1),
      ));
      await srcDb.close();

      final unknown = File(p.join(tempRoot.path, 'payload.bin'));
      await unknown.writeAsBytes(await sqliteFile.readAsBytes());

      final res = await importer.importFromFile(unknown.path);
      expect(res.success, isTrue);
      expect(res.decksImported, 1);
    });

    test('URL import respects content-type and extension', () async {
      final mock = MockClient((req) async {
        if (req.url.path.endsWith('.json')) {
          return http.Response(jsonEncode({
            'decks': [
              {'id': 'd2', 'title': 'Deck2', 'description': '', 'createdAt': '2025-10-02T00:00:00.000Z'}
            ],
            'questions': []
          }), 200, headers: {'content-type': 'application/json'});
        }
        // SQLite path
        final sqliteFile = File(p.join(tempRoot.path, 'remote.db'));
        final srcDb = AppDatabase.forTesting(NativeDatabase(sqliteFile));
        await srcDb.insertDeck(DecksCompanion.insert(
          id: 'd3',
          title: 'Deck3',
          description: '',
          createdAt: DateTime.utc(2025, 10, 3),
        ));
        await srcDb.close();
        final bytes = await sqliteFile.readAsBytes();
        return http.Response.bytes(bytes, 200, headers: {'content-type': 'application/octet-stream'});
      });

  final importer = DatabaseImporter(db, httpClient: mock, tempDirProvider: tempProvider);

      final r1 = await importer.importFromUrl('https://example.com/data.json');
      expect(r1.success, isTrue);
      expect(r1.decksImported, 1);

      final r2 = await importer.importFromUrl('https://example.com/file.sqlite');
      expect(r2.success, isTrue);
      expect(r2.decksImported, 1);
    });

    test('Graceful error for corrupt files', () async {
  final importer = DatabaseImporter(db, tempDirProvider: tempProvider);
      final bad = File(p.join(tempRoot.path, 'bad.db'));
      await bad.writeAsBytes(List<int>.filled(8, 0));

      final res = await importer.importFromFile(bad.path);
      expect(res.success, isFalse);
      expect(res.message, anyOf(contains('Invalid SQLite'), contains('Failed to import SQLite')));
    });
  });
}
