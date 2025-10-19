import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models.dart';
import '../domain/providers.dart';
import '../domain/spaced_repetition.dart';

class ReviewScreen extends ConsumerStatefulWidget {
  final List<QuestionModel> questions;

  const ReviewScreen({super.key, required this.questions});

  @override
  ConsumerState<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends ConsumerState<ReviewScreen> {
  int _currentIndex = 0;
  final Map<String, bool> _selectedChoices = {};
  bool _hasSubmitted = false;
  bool _isCorrect = false;
  double _partialScore = 0.0;
  
  final List<Map<String, dynamic>> _reviewHistory = [];

  QuestionModel get _currentQuestion => widget.questions[_currentIndex];
  bool get _isLastQuestion => _currentIndex == widget.questions.length - 1;

  void _toggleChoice(String choiceId) {
    if (_hasSubmitted) return;

    setState(() {
      if (_currentQuestion.type == QuestionType.mcq) {
        // For MCQ, clear all and select only this one
        _selectedChoices.clear();
        _selectedChoices[choiceId] = true;
      } else {
        // For multi-select, toggle
        _selectedChoices[choiceId] = !(_selectedChoices[choiceId] ?? false);
      }
    });
  }

  void _submitAnswer() {
    if (_selectedChoices.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an answer')),
      );
      return;
    }

    final correctChoices = _currentQuestion.choices
        .where((c) => c.isCorrect)
        .map((c) => c.id)
        .toSet();
    final selectedChoiceIds = _selectedChoices.entries
        .where((e) => e.value)
        .map((e) => e.key)
        .toSet();

    if (_currentQuestion.type == QuestionType.mcq) {
      _isCorrect = selectedChoiceIds.length == 1 &&
          correctChoices.contains(selectedChoiceIds.first);
      _partialScore = _isCorrect ? 1.0 : 0.0;
    } else {
      // Multi-select: calculate partial score
      final correctSelected = selectedChoiceIds.intersection(correctChoices).length;
      final incorrectSelected = selectedChoiceIds.difference(correctChoices).length;
      final missedCorrect = correctChoices.difference(selectedChoiceIds).length;

      if (selectedChoiceIds.isEmpty || correctSelected == 0) {
        _partialScore = 0.0;
      } else {
        _partialScore = correctSelected / (correctSelected + incorrectSelected + missedCorrect);
      }
      
      _isCorrect = _partialScore == 1.0;
    }

    setState(() {
      _hasSubmitted = true;
    });
  }

  Future<void> _nextQuestion() async {
    // Record the review
    final quality = qualityFromCorrectness(
      fullyCorrect: _isCorrect,
      partialScore: _partialScore,
    );

    final lastReview = _currentQuestion.lastReview;
    final controller = ref.read(reviewControllerProvider);

    await controller.recordReview(
      questionId: _currentQuestion.id,
      quality: quality,
      currentRepetition: lastReview?.repetition ?? 0,
      currentEasiness: lastReview?.easiness ?? 2.5,
      currentInterval: lastReview?.interval ?? 0,
    );

    _reviewHistory.add({
      'question': _currentQuestion.prompt,
      'correct': _isCorrect,
      'quality': quality,
      'partialScore': _partialScore,
    });

    if (_isLastQuestion) {
      // Show review summary
      _showReviewSummary();
    } else {
      // Move to next question
      setState(() {
        _currentIndex++;
        _selectedChoices.clear();
        _hasSubmitted = false;
        _isCorrect = false;
        _partialScore = 0.0;
      });
    }
  }

  void _showReviewSummary() {
    final totalQuestions = _reviewHistory.length;
    final correctAnswers = _reviewHistory.where((h) => h['correct'] as bool).length;
    final accuracy = (correctAnswers / totalQuestions * 100).toStringAsFixed(1);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Review Complete! 🎉'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total Questions: $totalQuestions'),
            Text('Correct: $correctAnswers'),
            Text('Accuracy: $accuracy%'),
            const SizedBox(height: 16),
            const Text(
              'Great job! Your spaced repetition schedule has been updated.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Return to home
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review (${_currentIndex + 1}/${widget.questions.length})'),
      ),
      body: Column(
        children: [
          // Progress indicator
          LinearProgressIndicator(
            value: (_currentIndex + 1) / widget.questions.length,
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Question type badge
                  Chip(
                    label: Text(_currentQuestion.type.displayName),
                    avatar: Icon(
                      _currentQuestion.type == QuestionType.mcq
                          ? Icons.radio_button_checked
                          : Icons.check_box,
                      size: 16,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Question prompt
                  Card(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        _currentQuestion.prompt,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Instruction text
                  if (!_hasSubmitted)
                    Text(
                      _currentQuestion.type == QuestionType.mcq
                          ? 'Select one answer:'
                          : 'Select all that apply:',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  const SizedBox(height: 12),

                  // Choices
                  ..._currentQuestion.choices.map((choice) {
                    final isSelected = _selectedChoices[choice.id] ?? false;
                    final showCorrectness = _hasSubmitted;
                    
                    Color? cardColor;
                    IconData? icon;
                    
                    if (showCorrectness) {
                      if (choice.isCorrect) {
                        cardColor = Colors.green.shade50;
                        icon = Icons.check_circle;
                      } else if (isSelected && !choice.isCorrect) {
                        cardColor = Colors.red.shade50;
                        icon = Icons.cancel;
                      }
                    }

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      color: cardColor,
                      child: InkWell(
                        onTap: () => _toggleChoice(choice.id),
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              // Selection indicator
                              if (!showCorrectness)
                                Icon(
                                  _currentQuestion.type == QuestionType.mcq
                                      ? (isSelected
                                          ? Icons.radio_button_checked
                                          : Icons.radio_button_unchecked)
                                      : (isSelected
                                          ? Icons.check_box
                                          : Icons.check_box_outline_blank),
                                  color: isSelected
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.grey,
                                )
                              else
                                Icon(
                                  icon ?? Icons.circle_outlined,
                                  color: choice.isCorrect
                                      ? Colors.green
                                      : (isSelected ? Colors.red : Colors.grey),
                                ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  choice.text,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: showCorrectness && choice.isCorrect
                                        ? FontWeight.bold
                                        : null,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),

                  // Feedback after submission
                  if (_hasSubmitted) ...[
                    const SizedBox(height: 24),
                    Card(
                      color: _isCorrect
                          ? Colors.green.shade50
                          : Colors.orange.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  _isCorrect
                                      ? Icons.check_circle
                                      : Icons.info_outline,
                                  color: _isCorrect ? Colors.green : Colors.orange,
                                  size: 32,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    _isCorrect
                                        ? 'Correct! 🎉'
                                        : 'Not quite right',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: _isCorrect
                                          ? Colors.green.shade900
                                          : Colors.orange.shade900,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (!_isCorrect && _partialScore > 0) ...[
                              const SizedBox(height: 8),
                              Text(
                                'Partial credit: ${(_partialScore * 100).toStringAsFixed(0)}%',
                                style: TextStyle(
                                  color: Colors.orange.shade900,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Action buttons
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: _hasSubmitted
                    ? ElevatedButton(
                        onPressed: _nextQuestion,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(_isLastQuestion ? 'Finish' : 'Next Question'),
                      )
                    : ElevatedButton(
                        onPressed: _submitAnswer,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Submit Answer'),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
