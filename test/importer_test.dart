import 'package:flutter_test/flutter_test.dart';
import 'package:revision_buddy/data/database.dart';
import 'package:revision_buddy/data/importer.dart';
import 'package:drift/native.dart';

void main() {
  late AppDatabase database;
  late DatabaseImporter importer;

  setUp(() {
    // Create in-memory database for testing
    database = AppDatabase.forTesting(NativeDatabase.memory());
    importer = DatabaseImporter(database);
  });

  tearDown(() async {
    await database.close();
  });

  group('JSON Import Tests', () {
    test('Import valid JSON successfully', () async {
      const jsonData = '''
      {
        "decks": [
          {
            "id": "deck-1",
            "title": "Test Deck",
            "description": "A test deck",
            "createdAt": "2025-10-01T00:00:00.000Z"
          }
        ],
        "questions": [
          {
            "id": "q1",
            "deckId": "deck-1",
            "type": "mcq",
            "prompt": "Test question?",
            "metadata": "{}",
            "choices": [
              {"id": "c1", "text": "Option A", "isCorrect": false},
              {"id": "c2", "text": "Option B", "isCorrect": true}
            ]
          }
        ]
      }
      ''';

      final result = await importer.importFromJson(jsonData);

      expect(result.success, true);
      expect(result.decksImported, 1);
      expect(result.questionsImported, 1);

      // Verify data was inserted
      final decks = await database.getAllDecks();
      expect(decks.length, 1);
      expect(decks.first.title, 'Test Deck');

      final questions = await database.getQuestionsByDeck('deck-1');
      expect(questions.length, 1);
      expect(questions.first.prompt, 'Test question?');

      final choices = await database.getChoicesByQuestion('q1');
      expect(choices.length, 2);
    });

    test('Import handles duplicate deck IDs', () async {
      const jsonData = '''
      {
        "decks": [
          {
            "id": "deck-1",
            "title": "First Import",
            "description": "First",
            "createdAt": "2025-10-01T00:00:00.000Z"
          }
        ],
        "questions": []
      }
      ''';

      // First import
      var result = await importer.importFromJson(jsonData);
      expect(result.success, true);
      expect(result.decksImported, 1);

      // Second import with same deck ID
      const jsonData2 = '''
      {
        "decks": [
          {
            "id": "deck-1",
            "title": "Second Import",
            "description": "Second",
            "createdAt": "2025-10-01T00:00:00.000Z"
          }
        ],
        "questions": []
      }
      ''';

      result = await importer.importFromJson(jsonData2);
      expect(result.success, true);
      expect(result.decksImported, 0); // Should skip duplicate

      // Verify only first deck remains
      final decks = await database.getAllDecks();
      expect(decks.length, 1);
      expect(decks.first.title, 'First Import');
    });

    test('Import handles multi-select questions', () async {
      const jsonData = '''
      {
        "decks": [
          {
            "id": "deck-1",
            "title": "Test Deck",
            "description": "Test",
            "createdAt": "2025-10-01T00:00:00.000Z"
          }
        ],
        "questions": [
          {
            "id": "q1",
            "deckId": "deck-1",
            "type": "multi-select",
            "prompt": "Select all correct",
            "metadata": "{}",
            "choices": [
              {"id": "c1", "text": "Correct 1", "isCorrect": true},
              {"id": "c2", "text": "Incorrect", "isCorrect": false},
              {"id": "c3", "text": "Correct 2", "isCorrect": true}
            ]
          }
        ]
      }
      ''';

      final result = await importer.importFromJson(jsonData);

      expect(result.success, true);
      expect(result.questionsImported, 1);

      final questions = await database.getQuestionsByDeck('deck-1');
      expect(questions.first.type, 'multi-select');

      final choices = await database.getChoicesByQuestion('q1');
      final correctChoices = choices.where((c) => c.isCorrect).toList();
      expect(correctChoices.length, 2);
    });

    test('Import fails with invalid JSON', () async {
      const invalidJson = '{ invalid json }';

      final result = await importer.importFromJson(invalidJson);

      expect(result.success, false);
      // Current implementation returns 'Invalid JSON format' for FormatException
      expect(result.message, anyOf(
        contains('Invalid JSON format'),
        contains('Failed to parse JSON'),
      ));
    });

    test('Import handles missing optional fields', () async {
      const jsonData = '''
      {
        "decks": [
          {
            "id": "deck-1",
            "title": "Test Deck",
            "description": "Test",
            "createdAt": "2025-10-01T00:00:00.000Z"
          }
        ],
        "questions": [
          {
            "id": "q1",
            "deckId": "deck-1",
            "type": "mcq",
            "prompt": "Test question?",
            "choices": [
              {"id": "c1", "text": "Option A", "isCorrect": true}
            ]
          }
        ]
      }
      ''';

      final result = await importer.importFromJson(jsonData);

      expect(result.success, true);
      
      final questions = await database.getQuestionsByDeck('deck-1');
      expect(questions.first.metadata, '{}'); // Default value
    });

    test('Import multiple decks and questions', () async {
      const jsonData = '''
      {
        "decks": [
          {
            "id": "deck-1",
            "title": "Deck 1",
            "description": "First deck",
            "createdAt": "2025-10-01T00:00:00.000Z"
          },
          {
            "id": "deck-2",
            "title": "Deck 2",
            "description": "Second deck",
            "createdAt": "2025-10-02T00:00:00.000Z"
          }
        ],
        "questions": [
          {
            "id": "q1",
            "deckId": "deck-1",
            "type": "mcq",
            "prompt": "Question 1",
            "metadata": "{}",
            "choices": [
              {"id": "c1", "text": "A", "isCorrect": true}
            ]
          },
          {
            "id": "q2",
            "deckId": "deck-2",
            "type": "mcq",
            "prompt": "Question 2",
            "metadata": "{}",
            "choices": [
              {"id": "c2", "text": "B", "isCorrect": true}
            ]
          }
        ]
      }
      ''';

      final result = await importer.importFromJson(jsonData);

      expect(result.success, true);
      expect(result.decksImported, 2);
      expect(result.questionsImported, 2);

      final decks = await database.getAllDecks();
      expect(decks.length, 2);

      final questions1 = await database.getQuestionsByDeck('deck-1');
      final questions2 = await database.getQuestionsByDeck('deck-2');
      expect(questions1.length, 1);
      expect(questions2.length, 1);
    });
  });
}

// test helper extension removed; using AppDatabase.forTesting directly
