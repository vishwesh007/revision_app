/// SM-2 (SuperMemo 2) algorithm for spaced repetition scheduling
/// 
/// This implements the canonical SM-2 algorithm for calculating
/// the next review interval based on the quality of recall.
library;

class SM2Result {
  final int repetition;
  final double easiness;
  final int interval;
  final DateTime nextReview;

  SM2Result({
    required this.repetition,
    required this.easiness,
    required this.interval,
    required this.nextReview,
  });

  @override
  String toString() =>
      'SM2Result(repetition: $repetition, easiness: $easiness, interval: $interval, nextReview: $nextReview)';
}

/// Calculate next review parameters using SM-2 algorithm
/// 
/// Parameters:
/// - [repetition]: Current repetition count (starts at 0 for new cards)
/// - [easiness]: Current easiness factor (default 2.5 for new cards, min 1.3)
/// - [interval]: Current interval in days
/// - [quality]: Quality of recall (0-5, where 0=complete blackout, 5=perfect recall)
/// - [reviewedAt]: The timestamp of the current review
/// 
/// Returns: [SM2Result] containing updated scheduling parameters
SM2Result calculateSM2({
  required int repetition,
  required double easiness,
  required int interval,
  required int quality,
  required DateTime reviewedAt,
}) {
  // Validate inputs
  if (quality < 0 || quality > 5) {
    throw ArgumentError('Quality must be between 0 and 5, got $quality');
  }
  if (easiness < 1.3) {
    easiness = 1.3;
  }

  int newRepetition = repetition;
  int newInterval = interval;
  double newEasiness = easiness;

  // If quality < 3, reset repetition and set interval to 1 day (failed recall)
  if (quality < 3) {
    newRepetition = 0;
    newInterval = 1;
  } else {
    // Successful recall
    if (newRepetition == 0) {
      newInterval = 1;
    } else if (newRepetition == 1) {
      newInterval = 6;
    } else {
      newInterval = (interval * easiness).round();
    }
    newRepetition += 1;
  }

  // Update easiness factor
  // EF' = EF + (0.1 - (5 - q) * (0.08 + (5 - q) * 0.02))
  newEasiness = easiness + 0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02);
  
  // Easiness factor should not fall below 1.3
  if (newEasiness < 1.3) {
    newEasiness = 1.3;
  }

  // Calculate next review date
  final nextReview = reviewedAt.add(Duration(days: newInterval));

  return SM2Result(
    repetition: newRepetition,
    easiness: newEasiness,
    interval: newInterval,
    nextReview: nextReview,
  );
}

/// Helper to determine quality score from answer correctness
/// 
/// For MCQ: 5=correct, 0=incorrect
/// For multi-select: calculated based on partial correctness
int qualityFromCorrectness({
  required bool fullyCorrect,
  double? partialScore,
}) {
  if (fullyCorrect) {
    return 5; // Perfect recall
  }
  
  if (partialScore != null) {
    if (partialScore >= 0.8) return 4; // Correct after hesitation
    if (partialScore >= 0.6) return 3; // Correct with serious difficulty
    if (partialScore >= 0.4) return 2; // Incorrect with familiar feeling
    if (partialScore > 0) return 1; // Incorrect with vague recall
  }
  
  return 0; // Complete blackout
}
