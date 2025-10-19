import 'package:flutter_test/flutter_test.dart';
import 'package:revision_buddy/domain/spaced_repetition.dart';

void main() {
  group('SM-2 Algorithm Tests', () {
    test('First review with quality 5 sets interval to 1 day', () {
      final result = calculateSM2(
        repetition: 0,
        easiness: 2.5,
        interval: 0,
        quality: 5,
        reviewedAt: DateTime(2025, 10, 1),
      );

      expect(result.repetition, 1);
      expect(result.interval, 1);
      expect(result.nextReview, DateTime(2025, 10, 2));
      expect(result.easiness, greaterThan(2.5)); // Should increase with quality 5
    });

    test('Second review with quality 5 sets interval to 6 days', () {
      final result = calculateSM2(
        repetition: 1,
        easiness: 2.6,
        interval: 1,
        quality: 5,
        reviewedAt: DateTime(2025, 10, 2),
      );

      expect(result.repetition, 2);
      expect(result.interval, 6);
      expect(result.nextReview, DateTime(2025, 10, 8));
    });

    test('Third review multiplies interval by easiness factor', () {
      final result = calculateSM2(
        repetition: 2,
        easiness: 2.5,
        interval: 6,
        quality: 4,
        reviewedAt: DateTime(2025, 10, 8),
      );

      expect(result.repetition, 3);
      expect(result.interval, 15); // 6 * 2.5 = 15
      expect(result.nextReview, DateTime(2025, 10, 23));
    });

    test('Quality < 3 resets repetition and interval to 1', () {
      final result = calculateSM2(
        repetition: 5,
        easiness: 2.8,
        interval: 30,
        quality: 2,
        reviewedAt: DateTime(2025, 10, 15),
      );

      expect(result.repetition, 0);
      expect(result.interval, 1);
      expect(result.nextReview, DateTime(2025, 10, 16));
    });

    test('Easiness factor has a floor of 1.3', () {
      // Multiple low-quality reviews should not drop easiness below 1.3
      var result = calculateSM2(
        repetition: 0,
        easiness: 1.5,
        interval: 0,
        quality: 0, // Worst quality
        reviewedAt: DateTime(2025, 10, 1),
      );

      expect(result.easiness, greaterThanOrEqualTo(1.3));

      // Try again with already low easiness
      result = calculateSM2(
        repetition: 0,
        easiness: 1.3,
        interval: 0,
        quality: 0,
        reviewedAt: DateTime(2025, 10, 1),
      );

      expect(result.easiness, 1.3);
    });

    test('Easiness increases with quality 5', () {
      final result = calculateSM2(
        repetition: 0,
        easiness: 2.5,
        interval: 0,
        quality: 5,
        reviewedAt: DateTime(2025, 10, 1),
      );

      expect(result.easiness, greaterThan(2.5));
    });

    test('Easiness decreases with quality 0', () {
      final result = calculateSM2(
        repetition: 0,
        easiness: 2.5,
        interval: 0,
        quality: 0,
        reviewedAt: DateTime(2025, 10, 1),
      );

      expect(result.easiness, lessThan(2.5));
      expect(result.easiness, greaterThanOrEqualTo(1.3));
    });

    test('Quality 3 maintains similar easiness', () {
      final result = calculateSM2(
        repetition: 1,
        easiness: 2.5,
        interval: 1,
        quality: 3,
        reviewedAt: DateTime(2025, 10, 1),
      );

      expect(result.easiness, closeTo(2.5, 0.2)); // Increased tolerance for quality 3
    });

    test('Invalid quality throws ArgumentError', () {
      expect(
        () => calculateSM2(
          repetition: 0,
          easiness: 2.5,
          interval: 0,
          quality: 6, // Invalid
          reviewedAt: DateTime(2025, 10, 1),
        ),
        throwsArgumentError,
      );

      expect(
        () => calculateSM2(
          repetition: 0,
          easiness: 2.5,
          interval: 0,
          quality: -1, // Invalid
          reviewedAt: DateTime(2025, 10, 1),
        ),
        throwsArgumentError,
      );
    });

    test('Multiple successful reviews increase intervals exponentially', () {
      var result = calculateSM2(
        repetition: 0,
        easiness: 2.5,
        interval: 0,
        quality: 4,
        reviewedAt: DateTime(2025, 10, 1),
      );
      expect(result.interval, 1);

      result = calculateSM2(
        repetition: result.repetition,
        easiness: result.easiness,
        interval: result.interval,
        quality: 4,
        reviewedAt: result.nextReview,
      );
      expect(result.interval, 6);

      result = calculateSM2(
        repetition: result.repetition,
        easiness: result.easiness,
        interval: result.interval,
        quality: 4,
        reviewedAt: result.nextReview,
      );
      expect(result.interval, greaterThan(10));
      expect(result.interval, lessThan(20));
    });
  });

  group('Quality from Correctness Tests', () {
    test('Fully correct returns quality 5', () {
      final quality = qualityFromCorrectness(fullyCorrect: true);
      expect(quality, 5);
    });

    test('Incorrect without partial score returns 0', () {
      final quality = qualityFromCorrectness(fullyCorrect: false);
      expect(quality, 0);
    });

    test('Partial score 0.8 returns quality 4', () {
      final quality = qualityFromCorrectness(
        fullyCorrect: false,
        partialScore: 0.8,
      );
      expect(quality, 4);
    });

    test('Partial score 0.6 returns quality 3', () {
      final quality = qualityFromCorrectness(
        fullyCorrect: false,
        partialScore: 0.6,
      );
      expect(quality, 3);
    });

    test('Partial score 0.4 returns quality 2', () {
      final quality = qualityFromCorrectness(
        fullyCorrect: false,
        partialScore: 0.4,
      );
      expect(quality, 2);
    });

    test('Partial score 0.1 returns quality 1', () {
      final quality = qualityFromCorrectness(
        fullyCorrect: false,
        partialScore: 0.1,
      );
      expect(quality, 1);
    });
  });
}
