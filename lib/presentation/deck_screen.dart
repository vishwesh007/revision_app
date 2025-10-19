import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/providers.dart';
import '../domain/models.dart';

class DeckScreen extends ConsumerWidget {
  final String deckId;

  const DeckScreen({super.key, required this.deckId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questionsAsync = ref.watch(questionsByDeckProvider(deckId));
    final decksAsync = ref.watch(decksProvider);

    return Scaffold(
      appBar: AppBar(
        title: decksAsync.when(
          data: (decks) {
            final deck = decks.firstWhere((d) => d.id == deckId);
            return Text(deck.title);
          },
          loading: () => const Text('Loading...'),
          error: (_, __) => const Text('Deck'),
        ),
      ),
      body: questionsAsync.when(
        data: (questions) {
          if (questions.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.question_answer, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No questions in this deck'),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: questions.length,
            itemBuilder: (context, index) {
              final question = questions[index];
              final isDue = question.lastReview == null ||
                  question.lastReview!.nextReview.isBefore(DateTime.now());

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ExpansionTile(
                  leading: CircleAvatar(
                    backgroundColor: isDue
                        ? Colors.orange.shade100
                        : Colors.green.shade100,
                    child: Icon(
                      question.type == QuestionType.mcq
                          ? Icons.radio_button_checked
                          : Icons.check_box,
                      color: isDue ? Colors.orange : Colors.green,
                    ),
                  ),
                  title: Text(
                    question.prompt,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    question.type.displayName,
                    style: const TextStyle(fontSize: 12),
                  ),
                  trailing: isDue
                      ? const Chip(
                          label: Text('Due', style: TextStyle(fontSize: 12)),
                          backgroundColor: Colors.orange,
                        )
                      : null,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Choices:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          ...question.choices.map((choice) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Icon(
                                  choice.isCorrect
                                      ? Icons.check_circle
                                      : Icons.radio_button_unchecked,
                                  size: 16,
                                  color: choice.isCorrect
                                      ? Colors.green
                                      : Colors.grey,
                                ),
                                const SizedBox(width: 8),
                                Expanded(child: Text(choice.text)),
                              ],
                            ),
                          )),
                          if (question.lastReview != null) ...[
                            const SizedBox(height: 16),
                            const Divider(),
                            const SizedBox(height: 8),
                            const Text(
                              'Review Stats:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Repetitions: ${question.lastReview!.repetition}',
                            ),
                            Text(
                              'Interval: ${question.lastReview!.interval} days',
                            ),
                            Text(
                              'Easiness: ${question.lastReview!.easiness.toStringAsFixed(2)}',
                            ),
                            Text(
                              'Next review: ${_formatDate(question.lastReview!.nextReview)}',
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = date.difference(now);

    if (diff.isNegative) {
      return 'Overdue';
    } else if (diff.inDays == 0) {
      return 'Today';
    } else if (diff.inDays == 1) {
      return 'Tomorrow';
    } else {
      return 'In ${diff.inDays} days';
    }
  }
}
