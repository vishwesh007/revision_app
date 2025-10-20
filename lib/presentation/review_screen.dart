import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:confetti/confetti.dart';
import 'dart:math' as math;
import '../domain/models.dart';
import '../domain/providers.dart';
import '../domain/spaced_repetition.dart';

class ReviewScreen extends ConsumerStatefulWidget {
  final List<QuestionModel> questions;

  const ReviewScreen({super.key, required this.questions});

  @override
  ConsumerState<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends ConsumerState<ReviewScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  final Map<String, bool> _selectedChoices = {};
  bool _hasSubmitted = false;
  bool _isCorrect = false;
  double _partialScore = 0.0;
  int _streak = 0;
  double _animatedProgress = 0.0;
  bool _showWin = false;
  int _summaryTotal = 0;
  int _summaryCorrect = 0;
  late ConfettiController _cornerConfetti;
  late ConfettiController _winConfetti;
  // Flip animation target: 0.0 (front/question) -> 1.0 (back/answer)
  double _flipTarget = 0.0;
  AnimationController? _progressController;
  Animation<double>? _progressAnimation;
  
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
      _flipTarget = 1.0; // flip to show answer side
      if (_isCorrect) {
        _streak += 1;
        _cornerConfetti.play();
        HapticFeedback.lightImpact();
      } else {
        _streak = 0;
        // light shake haptic if available
        HapticFeedback.selectionClick();
      }
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
      // Show review summary overlay
      _showReviewSummary();
    } else {
      // Move to next question
      setState(() {
        _currentIndex++;
        _selectedChoices.clear();
        _hasSubmitted = false;
        _isCorrect = false;
        _partialScore = 0.0;
        _flipTarget = 0.0;
        _animateProgress();
      });
    }
  }

  void _showReviewSummary() {
    final totalQuestions = _reviewHistory.length;
    final correctAnswers = _reviewHistory.where((h) => h['correct'] as bool).length;
    setState(() {
      _summaryTotal = totalQuestions;
      _summaryCorrect = correctAnswers;
      _showWin = true;
    });
    _winConfetti.play();
  }

  @override
  void initState() {
    super.initState();
    _animatedProgress = widget.questions.isEmpty ? 0 : 1 / widget.questions.length;
    _cornerConfetti = ConfettiController(duration: const Duration(milliseconds: 800));
    _winConfetti = ConfettiController(duration: const Duration(seconds: 3));
    _progressController = AnimationController(vsync: this, duration: 300.ms);
  }

  @override
  void dispose() {
    _cornerConfetti.dispose();
    _winConfetti.dispose();
    _progressController?.dispose();
    super.dispose();
  }

  void _animateProgress() {
    final target = (_currentIndex + 1) / widget.questions.length;
    final begin = _animatedProgress;
    _progressController?.stop();
    _progressController?.reset();
    _progressAnimation = Tween<double>(begin: begin, end: target)
        .animate(CurvedAnimation(parent: _progressController!, curve: Curves.easeOutCubic))
      ..addListener(() {
        setState(() {
          _animatedProgress = _progressAnimation!.value;
        });
      });
    _progressController?.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review (${_currentIndex + 1}/${widget.questions.length})'),
        actions: [
          // Streak badge
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.local_fire_department, size: 18, color: Colors.orange),
                const SizedBox(width: 6),
                Text('$_streak', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
      ).animate(target: _streak.toDouble()) // retrigger on change
              .scale(duration: 220.ms, begin: const Offset(1,1), end: const Offset(1.1,1.1))
              .then()
              .scale(begin: const Offset(1.1,1.1), end: const Offset(1,1)),
        ],
      ),
      body: Stack(
        children: [
          Column(
        children: [
          // Progress indicator
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: _animatedProgress),
            duration: 300.ms,
            builder: (context, value, _) => LinearProgressIndicator(value: value),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _buildFlipCard(context),
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
                      ).animate().scale(duration: 120.ms)
                    : ElevatedButton(
                        onPressed: _submitAnswer,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Submit Answer'),
                      ).animate().scale(duration: 120.ms),
              ),
            ),
          ),
        ],
          ),
          // Mini corner confetti for streak increments
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, right: 8.0),
              child: ConfettiWidget(
                confettiController: _cornerConfetti,
                blastDirectionality: BlastDirectionality.explosive,
                emissionFrequency: 0.9,
                numberOfParticles: 8,
                gravity: 0.8,
                colors: const [Colors.orange, Colors.red, Colors.yellow],
              ),
            ),
          ),

          // Win overlay
          if (_showWin) _buildWinOverlay(context),
        ],
      ),
    );
  }

  Widget _buildFlipCard(BuildContext context) {
    // Height adaptive card with flip between question (front) and feedback (back)
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth;
        final cardHeight = math.min(520.0, constraints.maxHeight - 32);

        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: _flipTarget),
          duration: 300.ms,
          curve: Curves.fastOutSlowIn,
          builder: (context, value, child) {
            final angle = value * math.pi; // 0..pi
            final isBack = angle > math.pi / 2;
            final displayAngle = isBack ? angle - math.pi : angle;

            return Center(
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.0015) // perspective
                  ..rotateY(displayAngle),
                child: SizedBox(
                  width: cardWidth,
                  height: cardHeight.isFinite ? cardHeight : null,
                  child: isBack ? _buildBackCard(context) : _buildFrontCard(context),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFrontCard(BuildContext context) {
    return SingleChildScrollView(
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
          ).animate().fadeIn(duration: 200.ms).slideY(begin: 0.1, end: 0),
          const SizedBox(height: 24),

          // Instruction text
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
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: () => _toggleChoice(choice.id),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
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
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          choice.text,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ).animate().fadeIn(duration: 200.ms).slideY(begin: 0.1, end: 0);
          }),
        ],
      ),
    );
  }

  Widget _buildBackCard(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Keep the question visible on the answer/feedback side
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
          Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                _currentQuestion.prompt,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ).animate().fadeIn(duration: 150.ms),
          const SizedBox(height: 16),

          Card(
            color: _isCorrect ? Colors.green.shade50 : Colors.orange.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    _isCorrect ? Icons.check_circle : Icons.info_outline,
                    color: _isCorrect ? Colors.green : Colors.orange,
                    size: 32,
                  ).animate().scale(duration: 220.ms),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isCorrect ? 'Correct! 🎉' : 'Not quite right',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: _isCorrect
                                ? Colors.green.shade900
                                : Colors.orange.shade900,
                          ),
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
                ],
              ),
            ),
          ).animate().fadeIn(duration: 200.ms).slideY(begin: 0.1, end: 0),

          const SizedBox(height: 16),

          // Show correctness per choice
          ..._currentQuestion.choices.map((choice) {
            final wasSelected = _selectedChoices[choice.id] ?? false;
            final isCorrectChoice = choice.isCorrect;
            final cardColor = isCorrectChoice
                ? Colors.green.shade50
                : (wasSelected ? Colors.red.shade50 : null);
            final icon = isCorrectChoice
                ? Icons.check_circle
                : (wasSelected ? Icons.cancel : Icons.circle_outlined);

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              color: cardColor,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      icon,
                      color: isCorrectChoice
                          ? Colors.green
                          : (wasSelected ? Colors.red : Colors.grey),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        choice.text,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: isCorrectChoice ? FontWeight.bold : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(duration: 200.ms).slideY(begin: 0.1, end: 0);
          }),
        ],
      ),
    );
  }

  Widget _buildWinOverlay(BuildContext context) {
    final accuracy = _summaryTotal == 0
        ? 0
        : ((_summaryCorrect / _summaryTotal) * 100).round();
    return Stack(
      children: [
        // Scrim
        Positioned.fill(
          child: Container(color: Colors.black.withValues(alpha: 0.4)).animate().fadeIn(),
        ),
        // Confetti
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _winConfetti,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            numberOfParticles: 30,
            gravity: 0.7,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple,
            ],
          ),
        ),
        // Pop score card
        Center(
          child: Card(
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Great job!', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green),
                      const SizedBox(width: 8),
                      _CountUp(from: 0, to: _summaryCorrect),
                      Text(' / $_summaryTotal correct'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.analytics, color: Colors.indigo),
                      const SizedBox(width: 8),
                      _CountUp(from: 0, to: accuracy, suffix: '%'),
                      const Text(' accuracy'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _showWin = false;
                          });
                          Navigator.pop(context); // back to previous
                        },
                        child: const Text('Back to Decks'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ).animate()
              .scale(begin: const Offset(0.9, 0.9), end: const Offset(1.05, 1.05), duration: 260.ms, curve: Curves.easeOutBack)
              .then()
              .scale(begin: const Offset(1.05, 1.05), end: const Offset(1.0, 1.0), duration: 160.ms),
        ),
      ],
    );
  }
}

class _CountUp extends StatefulWidget {
  final int from;
  final int to;
  final String suffix;

  const _CountUp({required this.from, required this.to, this.suffix = ''});

  @override
  State<_CountUp> createState() => _CountUpState();
}

class _CountUpState extends State<_CountUp> {
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: widget.from.toDouble(), end: widget.to.toDouble()),
      duration: 600.ms,
      builder: (context, value, _) => Text(
        '${value.round()}${widget.suffix} ',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
