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
      theme: _buildTheme(),
      home: const HomeScreen(),
    );
  }
}

ThemeData _buildTheme() {
  // Visual language from DESIGN_PROMPT.md
  const seed = Color(0xFF4F46E5); // Indigo 600
  final scheme = ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.light);

  final base = ThemeData(useMaterial3: true, colorScheme: scheme);

  return base.copyWith(
    appBarTheme: AppBarTheme(
      backgroundColor: scheme.surface,
      foregroundColor: scheme.onSurface,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: base.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
      ),
    ),
    cardTheme: const CardThemeData(
      elevation: 1,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(44),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: scheme.inverseSurface,
      contentTextStyle: TextStyle(color: scheme.onInverseSurface),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
  );
}
