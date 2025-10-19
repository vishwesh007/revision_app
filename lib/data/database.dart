// GENERATED CODE - DO NOT MODIFY BY HAND
// Run `flutter pub run build_runner build` to regenerate

import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

// Decks table
class Decks extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// Questions table
class Questions extends Table {
  TextColumn get id => text()();
  TextColumn get deckId => text().references(Decks, #id)();
  TextColumn get type => text()();
  TextColumn get prompt => text()();
  TextColumn get metadata => text().withDefault(const Constant('{}'))();

  @override
  Set<Column> get primaryKey => {id};
}

// Choices table
class Choices extends Table {
  TextColumn get id => text()();
  TextColumn get questionId => text().references(Questions, #id)();
  TextColumn get choiceText => text()();
  BoolColumn get isCorrect => boolean()();

  @override
  Set<Column> get primaryKey => {id};
}

// Reviews table
class Reviews extends Table {
  TextColumn get id => text()();
  TextColumn get questionId => text().references(Questions, #id)();
  DateTimeColumn get reviewedAt => dateTime()();
  IntColumn get quality => integer()();
  IntColumn get interval => integer()();
  IntColumn get repetition => integer()();
  RealColumn get easiness => real()();
  DateTimeColumn get nextReview => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Decks, Questions, Choices, Reviews])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  
  // Constructor for testing
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  // Deck operations
  Future<List<Deck>> getAllDecks() => select(decks).get();
  
  Future<Deck?> getDeckById(String id) =>
      (select(decks)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  Stream<List<Deck>> watchAllDecks() => select(decks).watch();

  Future<int> insertDeck(DecksCompanion deck) => into(decks).insert(deck);

  Future<void> deleteDeck(String id) =>
      (delete(decks)..where((tbl) => tbl.id.equals(id))).go();

  // Question operations
  Future<List<Question>> getQuestionsByDeck(String deckId) =>
      (select(questions)..where((tbl) => tbl.deckId.equals(deckId))).get();

  Future<Question?> getQuestionById(String id) =>
      (select(questions)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  Future<int> insertQuestion(QuestionsCompanion question) =>
      into(questions).insert(question);

  // Choice operations
  Future<List<Choice>> getChoicesByQuestion(String questionId) =>
      (select(choices)..where((tbl) => tbl.questionId.equals(questionId))).get();

  Future<int> insertChoice(ChoicesCompanion choice) => into(choices).insert(choice);

  // Review operations
  Future<List<Review>> getReviewsByQuestion(String questionId) =>
      (select(reviews)..where((tbl) => tbl.questionId.equals(questionId)))
          .get();

  Future<Review?> getLatestReview(String questionId) =>
      (select(reviews)
            ..where((tbl) => tbl.questionId.equals(questionId))
            ..orderBy([(t) => OrderingTerm.desc(t.reviewedAt)])
            ..limit(1))
          .getSingleOrNull();

  Future<int> insertReview(ReviewsCompanion review) => into(reviews).insert(review);

  // Get questions due for review
  Future<List<Question>> getDueQuestions() async {
    final now = DateTime.now();
    
    // Get all questions
    final allQuestions = await select(questions).get();
    final dueQuestions = <Question>[];

    for (final question in allQuestions) {
      final latestReview = await getLatestReview(question.id);
      
      // If never reviewed or due date has passed
      if (latestReview == null || latestReview.nextReview.isBefore(now)) {
        dueQuestions.add(question);
      }
    }

    return dueQuestions;
  }

  // Clear all data
  Future<void> clearAllData() async {
    await delete(reviews).go();
    await delete(choices).go();
    await delete(questions).go();
    await delete(decks).go();
  }

  // Get review statistics
  Future<Map<String, dynamic>> getStatistics() async {
    final allReviews = await select(reviews).get();
    final totalReviews = allReviews.length;
    
    final correctReviews = allReviews.where((r) => r.quality >= 3).length;
    final accuracy = totalReviews > 0 ? (correctReviews / totalReviews * 100) : 0.0;
    
    final dueQuestions = await getDueQuestions();
    final dueCount = dueQuestions.length;

    return {
      'totalReviews': totalReviews,
      'accuracy': accuracy,
      'dueCount': dueCount,
    };
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'revision_buddy.db'));
    return NativeDatabase(file);
  });
}
