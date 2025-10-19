import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'presentation/home_screen.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize notification service
  final notificationService = NotificationService();
  await notificationService.initialize();
  
  // Check if notifications are enabled and reschedule them
  final prefs = await SharedPreferences.getInstance();
  final notificationsEnabled = prefs.getBool('notifications_enabled') ?? false;
  
  if (notificationsEnabled) {
    final hour = prefs.getInt('notification_hour') ?? 9;
    final minute = prefs.getInt('notification_minute') ?? 0;
    
    // Reschedule notification (in case app was killed or device restarted)
    final hasPermission = await notificationService.hasPermission();
    if (hasPermission) {
      await notificationService.scheduleDailyNotification(
        hour: hour,
        minute: minute,
      );
    }
  }
  
  runApp(const ProviderScope(child: RevisionBuddyApp()));
}

class RevisionBuddyApp extends StatelessWidget {
  const RevisionBuddyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Revision Buddy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        cardTheme: const CardThemeData(
          elevation: 2,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
