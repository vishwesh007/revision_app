import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:confetti/confetti.dart';
import '../domain/providers.dart';
import 'import_screen.dart';
import 'deck_screen.dart';
import 'review_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final decksAsync = ref.watch(decksProvider);
    final statsAsync = ref.watch(statisticsProvider);

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Revision Buddy')
                .animate(onPlay: (controller) => controller.repeat())
                .shimmer(duration: 2000.ms, delay: 3000.ms),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SettingsScreen()),
                  );
                },
              )
                  .animate()
                  .scale(delay: 300.ms, duration: 300.ms)
                  .fadeIn(),
            ],
          ),
      body: decksAsync.when(
        data: (decks) {
          if (decks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.library_books, size: 80, color: Colors.grey)
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .scale(delay: 200.ms)
                      .shake(delay: 800.ms),
                  const SizedBox(height: 16),
                  const Text(
                    'No decks available',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )
                      .animate()
                      .fadeIn(delay: 400.ms)
                      .slideY(begin: 0.3, end: 0),
                  const SizedBox(height: 8),
                  const Text('Import a demo database to get started')
                      .animate()
                      .fadeIn(delay: 600.ms),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ImportScreen()),
                      );
                    },
                    icon: const Icon(Icons.download),
                    label: const Text('Import Demo DB'),
                  )
                      .animate()
                      .fadeIn(delay: 800.ms)
                      .scale(delay: 800.ms)
                      .then()
                      .shimmer(duration: 1500.ms, delay: 1000.ms),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(decksProvider);
              ref.invalidate(statisticsProvider);
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Statistics Card
                statsAsync.when(
                  data: (stats) => _StatisticsCard(stats: stats)
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: -0.2, end: 0),
                  loading: () => const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
                  error: (_, __) => const SizedBox.shrink(),
                ),
                const SizedBox(height: 16),

                // Review Button
                Consumer(
                  builder: (context, ref, _) {
                    final dueQuestionsAsync = ref.watch(dueQuestionsProvider);
                    return dueQuestionsAsync.when(
                      data: (dueQuestions) {
                        if (dueQuestions.isEmpty) {
                          // Trigger confetti when all done!
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (mounted) _confettiController.play();
                          });
                          
                          return Card(
                            color: Colors.green.shade50,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Icon(Icons.check_circle, 
                                    color: Colors.green.shade700, size: 32)
                                      .animate(onPlay: (controller) => controller.repeat())
                                      .scale(duration: 1000.ms, curve: Curves.easeInOut)
                                      .then()
                                      .scale(begin: const Offset(1.0, 1.0), end: const Offset(0.9, 0.9)),
                                  const SizedBox(width: 16),
                                  const Expanded(
                                    child: Text(
                                      'All caught up! No reviews due.',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                              .animate()
                              .fadeIn()
                              .slideX(begin: -0.2, end: 0);
                        }

                        return Card(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ReviewScreen(
                                    questions: dueQuestions,
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.school,
                                    color: Theme.of(context).colorScheme.primary,
                                    size: 32,
                                  )
                                      .animate(onPlay: (controller) => controller.repeat(reverse: true))
                                      .scale(duration: 800.ms, begin: const Offset(1.0, 1.0), end: const Offset(1.15, 1.15))
                                      .then()
                                      .shimmer(delay: 2000.ms, duration: 1500.ms),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Start Review Session',
                                          style: Theme.of(context).textTheme.titleLarge,
                                        ),
                                        Text(
                                          '${dueQuestions.length} questions due',
                                          style: Theme.of(context).textTheme.bodyMedium,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.arrow_forward),
                                ],
                              ),
                            ),
                          ),
                        )
                            .animate()
                            .fadeIn(delay: 100.ms)
                            .slideY(begin: 0.2, end: 0);
                      },
                      loading: () => const Card(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      ),
                      error: (_, __) => const SizedBox.shrink(),
                    );
                  },
                ),
                const SizedBox(height: 24),

                // Decks Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Your Decks',
                      style: Theme.of(context).textTheme.titleLarge,
                    )
                        .animate()
                        .fadeIn(delay: 200.ms)
                        .slideX(begin: -0.2, end: 0),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ImportScreen()),
                        );
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Import'),
                    )
                        .animate()
                        .fadeIn(delay: 300.ms)
                        .slideX(begin: 0.2, end: 0),
                  ],
                ),
                const SizedBox(height: 8),

                // Deck List
                ...AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 375),
                  childAnimationBuilder: (widget) => SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(child: widget),
                  ),
                  children: decks.map((deck) => Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: Hero(
                        tag: 'deck-${deck.id}',
                        child: CircleAvatar(
                          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                          child: Text(
                            deck.questionCount.toString(),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondaryContainer,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      title: Text(deck.title),
                      subtitle: Text(deck.description),
                      trailing: deck.dueCount > 0
                          ? Chip(
                              label: Text('${deck.dueCount} due'),
                              backgroundColor: Colors.orange.shade100,
                            )
                                .animate(onPlay: (controller) => controller.repeat())
                                .shimmer(duration: 2000.ms, delay: 1000.ms)
                          : null,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DeckScreen(deckId: deck.id),
                          ),
                        );
                      },
                    ),
                  )).toList(),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator())
            .animate()
            .fadeIn(),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red)
                  .animate()
                  .shake(),
              const SizedBox(height: 16),
              Text('Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(decksProvider),
                child: const Text('Retry'),
              )
                  .animate()
                  .fadeIn(delay: 300.ms)
                  .scale(delay: 300.ms),
            ],
          ),
        ),
      ),
    ),
        // Confetti overlay
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple
            ],
          ),
        ),
      ],
    );
  }
}

class _StatisticsCard extends StatelessWidget {
  final Map<String, dynamic> stats;

  const _StatisticsCard({required this.stats});

  @override
  Widget build(BuildContext context) {
    final totalReviews = stats['totalReviews'] as int;
    final accuracy = stats['accuracy'] as double;
    final dueCount = stats['dueCount'] as int;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Statistics',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(
                  label: 'Reviews',
                  value: totalReviews.toString(),
                  icon: Icons.history,
                ),
                _StatItem(
                  label: 'Accuracy',
                  value: '${accuracy.toStringAsFixed(1)}%',
                  icon: Icons.analytics,
                ),
                _StatItem(
                  label: 'Due',
                  value: dueCount.toString(),
                  icon: Icons.pending_actions,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary)
            .animate(onPlay: (controller) => controller.repeat())
            .scale(duration: 1500.ms, curve: Curves.easeInOut)
            .then()
            .scale(begin: const Offset(1.0, 1.0), end: const Offset(0.95, 0.95)),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        )
            .animate()
            .fadeIn(delay: 200.ms),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        )
            .animate()
            .fadeIn(delay: 300.ms),
      ],
    );
  }
}
