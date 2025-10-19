import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:revision_buddy/data/database.dart';
import 'package:revision_buddy/data/importer.dart';
import 'package:revision_buddy/domain/models.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' as drift;
import 'spaced_repetition.dart';

// Database provider
final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

// Importer provider
final importerProvider = Provider<DatabaseImporter>((ref) {
  final database = ref.watch(databaseProvider);
  return DatabaseImporter(database);
});

// Decks provider
final decksProvider = StreamProvider<List<DeckModel>>((ref) async* {
  final database = ref.watch(databaseProvider);
  
  await for (final decks in database.watchAllDecks()) {
    final List<DeckModel> deckModels = [];
    
    for (final deck in decks) {
      final questions = await database.getQuestionsByDeck(deck.id);
      int dueCount = 0;
      
      for (final question in questions) {
        final review = await database.getLatestReview(question.id);
        if (review == null || review.nextReview.isBefore(DateTime.now())) {
          dueCount++;
        }
      }
      
      deckModels.add(DeckModel(
        id: deck.id,
        title: deck.title,
        description: deck.description,
        createdAt: deck.createdAt,
        questionCount: questions.length,
        dueCount: dueCount,
      ));
    }
    
    yield deckModels;
  }
});

// Due questions provider
final dueQuestionsProvider = FutureProvider<List<QuestionModel>>((ref) async {
  final database = ref.watch(databaseProvider);
  final dueQuestions = await database.getDueQuestions();
  
  final List<QuestionModel> models = [];
  for (final question in dueQuestions) {
    final choices = await database.getChoicesByQuestion(question.id);
    final review = await database.getLatestReview(question.id);
    
    models.add(QuestionModel(
      id: question.id,
      deckId: question.deckId,
      type: question.type == 'mcq' ? QuestionType.mcq : QuestionType.multiSelect,
      prompt: question.prompt,
      metadata: question.metadata,
      choices: choices.map((c) => ChoiceModel(
        id: c.id,
        text: c.choiceText,
        isCorrect: c.isCorrect,
      )).toList(),
      lastReview: review != null ? ReviewModel(
        id: review.id,
        questionId: review.questionId,
        reviewedAt: review.reviewedAt,
        quality: review.quality,
        interval: review.interval,
        repetition: review.repetition,
        easiness: review.easiness,
        nextReview: review.nextReview,
      ) : null,
    ));
  }
  
  return models;
});

// Questions by deck provider
final questionsByDeckProvider = FutureProvider.family<List<QuestionModel>, String>((ref, deckId) async {
  final database = ref.watch(databaseProvider);
  final questions = await database.getQuestionsByDeck(deckId);
  
  final List<QuestionModel> models = [];
  for (final question in questions) {
    final choices = await database.getChoicesByQuestion(question.id);
    final review = await database.getLatestReview(question.id);
    
    models.add(QuestionModel(
      id: question.id,
      deckId: question.deckId,
      type: question.type == 'mcq' ? QuestionType.mcq : QuestionType.multiSelect,
      prompt: question.prompt,
      metadata: question.metadata,
      choices: choices.map((c) => ChoiceModel(
        id: c.id,
        text: c.choiceText,
        isCorrect: c.isCorrect,
      )).toList(),
      lastReview: review != null ? ReviewModel(
        id: review.id,
        questionId: review.questionId,
        reviewedAt: review.reviewedAt,
        quality: review.quality,
        interval: review.interval,
        repetition: review.repetition,
        easiness: review.easiness,
        nextReview: review.nextReview,
      ) : null,
    ));
  }
  
  return models;
});

// Statistics provider
final statisticsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final database = ref.watch(databaseProvider);
  return await database.getStatistics();
});

// Review controller
class ReviewController {
  final AppDatabase database;
  final Uuid uuid = const Uuid();

  ReviewController(this.database);

  Future<void> recordReview({
    required String questionId,
    required int quality,
    required int currentRepetition,
    required double currentEasiness,
    required int currentInterval,
  }) async {
    final reviewedAt = DateTime.now();
    
    final result = calculateSM2(
      repetition: currentRepetition,
      easiness: currentEasiness,
      interval: currentInterval,
      quality: quality,
      reviewedAt: reviewedAt,
    );

    await database.insertReview(
      ReviewsCompanion(
        id: drift.Value(uuid.v4()),
        questionId: drift.Value(questionId),
        reviewedAt: drift.Value(reviewedAt),
        quality: drift.Value(quality),
        interval: drift.Value(result.interval),
        repetition: drift.Value(result.repetition),
        easiness: drift.Value(result.easiness),
        nextReview: drift.Value(result.nextReview),
      ),
    );
  }
}

final reviewControllerProvider = Provider<ReviewController>((ref) {
  final database = ref.watch(databaseProvider);
  return ReviewController(database);
});
