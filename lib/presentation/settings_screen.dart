import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationSettings = ref.watch(notificationSettingsProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          const _SectionHeader(title: 'Notifications'),
          
          // Notification settings
          notificationSettings.when(
            data: (settings) => Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.notifications_active),
                  title: const Text('Daily Reminders'),
                  subtitle: Text(
                    settings.enabled
                        ? 'Enabled at ${_formatTime(settings.hour, settings.minute)}'
                        : 'Get reminded to review your flashcards',
                  ),
                  value: settings.enabled,
                  onChanged: (value) async {
                    if (value) {
                      // Request permission when enabling
                      final notificationService = ref.read(notificationServiceProvider);
                      final hasPermission = await notificationService.requestPermission();
                      
                      if (hasPermission) {
                        await ref.read(notificationSettingsProvider.notifier).updateSettings(
                          enabled: true,
                        );
                        
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Daily reminders enabled!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      } else {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Notification permission denied'),
                              backgroundColor: Colors.orange,
                            ),
                          );
                        }
                      }
                    } else {
                      await ref.read(notificationSettingsProvider.notifier).updateSettings(
                        enabled: false,
                      );
                      
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Daily reminders disabled'),
                          ),
                        );
                      }
                    }
                  },
                ),
                
                if (settings.enabled)
                  ListTile(
                    leading: const Icon(Icons.access_time),
                    title: const Text('Reminder Time'),
                    subtitle: Text(_formatTime(settings.hour, settings.minute)),
                    trailing: const Icon(Icons.edit),
                    onTap: () => _showTimePicker(context, ref, settings),
                  ),
                  
                ListTile(
                  leading: const Icon(Icons.send),
                  title: const Text('Test Notification'),
                  subtitle: const Text('Send a test notification now'),
                  onTap: () async {
                    final notificationService = ref.read(notificationServiceProvider);
                    final hasPermission = await notificationService.hasPermission();
                    
                    if (hasPermission) {
                      await notificationService.sendTestNotification();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Test notification sent!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    } else {
                      if (context.mounted) {
                        _showPermissionDialog(context, ref);
                      }
                    }
                  },
                ),
              ],
            ),
            loading: () => const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (_, __) => const ListTile(
              leading: Icon(Icons.error_outline),
              title: Text('Failed to load notification settings'),
            ),
          ),
          
          const Divider(),
          
          const _SectionHeader(title: 'Database'),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            subtitle: const Text('Revision Buddy v1.0.0'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Revision Buddy',
                applicationVersion: '1.0.0',
                applicationIcon: const Icon(Icons.school, size: 48),
                children: [
                  const Text(
                    'A spaced repetition flashcard app with support for '
                    'MCQ and multi-select questions, using the SM-2 algorithm '
                    'for optimal learning.',
                  ),
                ],
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline, color: Colors.red),
            title: const Text('Clear All Data'),
            subtitle: const Text('Delete all decks, questions, and reviews'),
            onTap: () => _showClearDataDialog(context, ref),
          ),
          const Divider(),
          
          const _SectionHeader(title: 'Statistics'),
          Consumer(
            builder: (context, ref, _) {
              final statsAsync = ref.watch(statisticsProvider);
              return statsAsync.when(
                data: (stats) => Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.analytics, size: 20),
                      title: const Text('Total Reviews'),
                      trailing: Text(
                        stats['totalReviews'].toString(),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.pie_chart, size: 20),
                      title: const Text('Accuracy'),
                      trailing: Text(
                        '${(stats['accuracy'] as double).toStringAsFixed(1)}%',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.pending_actions, size: 20),
                      title: const Text('Questions Due'),
                      trailing: Text(
                        stats['dueCount'].toString(),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ],
                ),
                loading: () => const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (_, __) => const ListTile(
                  leading: Icon(Icons.error_outline),
                  title: Text('Failed to load statistics'),
                ),
              );
            },
          ),
          const Divider(),

          const _SectionHeader(title: 'Algorithm'),
          const ListTile(
            leading: Icon(Icons.memory),
            title: Text('Spaced Repetition'),
            subtitle: Text('Using SM-2 algorithm for optimal scheduling'),
          ),
          const ListTile(
            leading: Icon(Icons.schedule),
            title: Text('Review Intervals'),
            subtitle: Text('Automatically adjusted based on your performance'),
          ),
        ],
      ),
    );
  }
  
  static String _formatTime(int hour, int minute) {
    final period = hour >= 12 ? 'PM' : 'AM';
    final hour12 = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '${hour12.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
  }
  
  void _showTimePicker(BuildContext context, WidgetRef ref, NotificationSettings settings) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: settings.hour, minute: settings.minute),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      await ref.read(notificationSettingsProvider.notifier).updateSettings(
        hour: picked.hour,
        minute: picked.minute,
      );
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Reminder time updated to ${_formatTime(picked.hour, picked.minute)}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }
  
  void _showPermissionDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notification Permission Required'),
        content: const Text(
          'To send test notifications, please enable notification permissions. '
          'You can enable them from the "Daily Reminders" toggle above.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showClearDataDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data?'),
        content: const Text(
          'This will permanently delete all your decks, questions, and review history. '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final database = ref.read(databaseProvider);
              await database.clearAllData();
              
              // Refresh providers
              ref.invalidate(decksProvider);
              ref.invalidate(dueQuestionsProvider);
              ref.invalidate(statisticsProvider);

              if (context.mounted) {
                Navigator.pop(context); // Close dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('All data cleared'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
