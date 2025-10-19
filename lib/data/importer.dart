import 'dart:convert';
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'database.dart';

class ImportResult {
  final bool success;
  final String message;
  final int decksImported;
  final int questionsImported;

  ImportResult({
    required this.success,
    required this.message,
    this.decksImported = 0,
    this.questionsImported = 0,
  });
}

class DatabaseImporter {
  final AppDatabase database;

  DatabaseImporter(this.database);

  /// Import from bundled asset
  Future<ImportResult> importFromAsset(String assetPath) async {
    try {
      final jsonString = await rootBundle.loadString(assetPath);
      return await _importFromJson(jsonString);
    } catch (e) {
      return ImportResult(
        success: false,
        message: 'Failed to load asset: $e',
      );
    }
  }

  /// Import from URL (downloads JSON)
  Future<ImportResult> importFromUrl(String url) async {
    try {
      final response = await http.get(Uri.parse(url)).timeout(
        const Duration(seconds: 30),
      );

      if (response.statusCode != 200) {
        return ImportResult(
          success: false,
          message: 'Failed to download: HTTP ${response.statusCode}',
        );
      }

      final contentType = response.headers['content-type'] ?? '';
      
      if (contentType.contains('application/json')) {
        return await _importFromJson(response.body);
      } else {
        // Assume SQLite file - save and try to import
        return await _importFromSqliteBytes(response.bodyBytes);
      }
    } on SocketException {
      return ImportResult(
        success: false,
        message: 'Network error: Please check your internet connection',
      );
    } on http.ClientException catch (e) {
      return ImportResult(
        success: false,
        message: 'Network error: $e',
      );
    } catch (e) {
      return ImportResult(
        success: false,
        message: 'Import failed: $e',
      );
    }
  }

  /// Import from local file path
  Future<ImportResult> importFromFile(String filePath) async {
    try {
      final file = File(filePath);
      
      if (!await file.exists()) {
        return ImportResult(
          success: false,
          message: 'File not found: $filePath',
        );
      }

      final extension = p.extension(filePath).toLowerCase();
      
      if (extension == '.json') {
        final jsonString = await file.readAsString();
        return await _importFromJson(jsonString);
      } else if (extension == '.db' || extension == '.sqlite') {
        final bytes = await file.readAsBytes();
        return await _importFromSqliteBytes(bytes);
      } else {
        return ImportResult(
          success: false,
          message: 'Unsupported file type: $extension',
        );
      }
    } catch (e) {
      return ImportResult(
        success: false,
        message: 'Failed to import file: $e',
      );
    }
  }

  /// Import from JSON string (exposed for testing)
  Future<ImportResult> importFromJson(String jsonString) async {
    return _importFromJson(jsonString);
  }

  /// Import from JSON string (internal)
  Future<ImportResult> _importFromJson(String jsonString) async {
    try {
      final data = json.decode(jsonString) as Map<String, dynamic>;
      
      int decksCount = 0;
      int questionsCount = 0;

      // Import decks
      final decks = data['decks'] as List<dynamic>?;
      if (decks != null) {
        for (final deckData in decks) {
          final deck = deckData as Map<String, dynamic>;
          
          // Check for duplicates
          final existing = await database.getDeckById(deck['id'] as String);
          if (existing != null) continue; // Skip duplicates

          await database.insertDeck(
            DecksCompanion(
              id: Value(deck['id'] as String),
              title: Value(deck['title'] as String),
              description: Value(deck['description'] as String? ?? ''),
              createdAt: Value(
                deck['createdAt'] != null
                    ? DateTime.parse(deck['createdAt'] as String)
                    : DateTime.now(),
              ),
            ),
          );
          decksCount++;
        }
      }

      // Import questions and choices
      final questions = data['questions'] as List<dynamic>?;
      if (questions != null) {
        for (final questionData in questions) {
          final question = questionData as Map<String, dynamic>;
          
          // Check for duplicates
          final existing = await database.getQuestionById(question['id'] as String);
          if (existing != null) continue;

          await database.insertQuestion(
            QuestionsCompanion(
              id: Value(question['id'] as String),
              deckId: Value(question['deckId'] as String),
              type: Value(question['type'] as String),
              prompt: Value(question['prompt'] as String),
              metadata: Value(question['metadata'] as String? ?? '{}'),
            ),
          );
          questionsCount++;

          // Import choices
          final choices = question['choices'] as List<dynamic>?;
          if (choices != null) {
            for (final choiceData in choices) {
              final choice = choiceData as Map<String, dynamic>;
              await database.insertChoice(
                ChoicesCompanion(
                  id: Value(choice['id'] as String),
                  questionId: Value(question['id'] as String),
                  choiceText: Value(choice['text'] as String),
                  isCorrect: Value(choice['isCorrect'] as bool),
                ),
              );
            }
          }
        }
      }

      return ImportResult(
        success: true,
        message: 'Successfully imported $decksCount decks and $questionsCount questions',
        decksImported: decksCount,
        questionsImported: questionsCount,
      );
    } catch (e) {
      return ImportResult(
        success: false,
        message: 'Failed to parse JSON: $e',
      );
    }
  }

  /// Import from SQLite file bytes
  Future<ImportResult> _importFromSqliteBytes(List<int> bytes) async {
    try {
      // Save the SQLite file temporarily
      final tempDir = await getTemporaryDirectory();
      final tempFile = File(p.join(tempDir.path, 'temp_import_${DateTime.now().millisecondsSinceEpoch}.db'));
      await tempFile.writeAsBytes(bytes);

      // Import data from the SQLite file
      int decksCount = 0;
      int questionsCount = 0;

      try {
        // Open the imported database
        final importDb = AppDatabase.fromFile(tempFile);
        
        // Import decks
        final decks = await importDb.select(importDb.decks).get();
        for (final deck in decks) {
          // Check for duplicates
          final existing = await database.getDeckById(deck.id);
          if (existing != null) continue;

          await database.insertDeck(
            DecksCompanion(
              id: Value(deck.id),
              title: Value(deck.title),
              description: Value(deck.description),
              createdAt: Value(deck.createdAt),
            ),
          );
          decksCount++;
        }

        // Import questions
        final questions = await importDb.select(importDb.questions).get();
        for (final question in questions) {
          // Check for duplicates
          final existing = await database.getQuestionById(question.id);
          if (existing != null) continue;

          await database.insertQuestion(
            QuestionsCompanion(
              id: Value(question.id),
              deckId: Value(question.deckId),
              type: Value(question.type),
              prompt: Value(question.prompt),
              metadata: Value(question.metadata),
            ),
          );
          questionsCount++;

          // Import choices for this question
          final choices = await (importDb.select(importDb.choices)
                ..where((c) => c.questionId.equals(question.id)))
              .get();
          
          for (final choice in choices) {
            await database.insertChoice(
              ChoicesCompanion(
                id: Value(choice.id),
                questionId: Value(choice.questionId),
                choiceText: Value(choice.choiceText),
                isCorrect: Value(choice.isCorrect),
              ),
            );
          }
        }

        // Close and clean up
        await importDb.close();
        await tempFile.delete();

        return ImportResult(
          success: true,
          message: 'Successfully imported $decksCount decks and $questionsCount questions from SQLite file',
          decksImported: decksCount,
          questionsImported: questionsCount,
        );
      } catch (e) {
        // Clean up on error
        if (await tempFile.exists()) {
          await tempFile.delete();
        }
        return ImportResult(
          success: false,
          message: 'Invalid SQLite database format: $e',
        );
      }
    } catch (e) {
      return ImportResult(
        success: false,
        message: 'Failed to import SQLite file: $e',
      );
    }
  }
}
