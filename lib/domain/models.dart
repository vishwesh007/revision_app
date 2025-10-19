import 'package:freezed_annotation/freezed_annotation.dart';

part 'models.freezed.dart';
part 'models.g.dart';

@freezed
class DeckModel with _$DeckModel {
  const factory DeckModel({
    required String id,
    required String title,
    required String description,
    required DateTime createdAt,
    @Default(0) int questionCount,
    @Default(0) int dueCount,
  }) = _DeckModel;

  factory DeckModel.fromJson(Map<String, dynamic> json) =>
      _$DeckModelFromJson(json);
}

@freezed
class QuestionModel with _$QuestionModel {
  const factory QuestionModel({
    required String id,
    required String deckId,
    required QuestionType type,
    required String prompt,
    required List<ChoiceModel> choices,
    @Default('{}') String metadata,
    ReviewModel? lastReview,
  }) = _QuestionModel;

  factory QuestionModel.fromJson(Map<String, dynamic> json) =>
      _$QuestionModelFromJson(json);
}

@freezed
class ChoiceModel with _$ChoiceModel {
  const factory ChoiceModel({
    required String id,
    required String text,
    required bool isCorrect,
    @Default(false) bool isSelected,
  }) = _ChoiceModel;

  factory ChoiceModel.fromJson(Map<String, dynamic> json) =>
      _$ChoiceModelFromJson(json);
}

@freezed
class ReviewModel with _$ReviewModel {
  const factory ReviewModel({
    required String id,
    required String questionId,
    required DateTime reviewedAt,
    required int quality,
    required int interval,
    required int repetition,
    required double easiness,
    required DateTime nextReview,
  }) = _ReviewModel;

  factory ReviewModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewModelFromJson(json);
}

enum QuestionType {
  @JsonValue('mcq')
  mcq,
  @JsonValue('multi-select')
  multiSelect,
}

extension QuestionTypeX on QuestionType {
  String get displayName {
    switch (this) {
      case QuestionType.mcq:
        return 'Multiple Choice';
      case QuestionType.multiSelect:
        return 'Multiple Select';
    }
  }
}

@freezed
class ReviewSessionStats with _$ReviewSessionStats {
  const factory ReviewSessionStats({
    @Default(0) int totalQuestions,
    @Default(0) int correctAnswers,
    @Default(0) int partialCorrect,
    @Default(0) int incorrectAnswers,
    @Default(0.0) double averageQuality,
    required DateTime startedAt,
    DateTime? completedAt,
  }) = _ReviewSessionStats;

  factory ReviewSessionStats.fromJson(Map<String, dynamic> json) =>
      _$ReviewSessionStatsFromJson(json);
}
