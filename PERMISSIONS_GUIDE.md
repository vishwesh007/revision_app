# Permissions & Platform Configuration Guide

This document explains the permissions required by Revision Buddy and how they're configured for each platform.

## Why Permissions Are Needed

Revision Buddy requires specific permissions to enable key features:

1. **Internet Access**: Required to download demo databases from URLs
2. **Local Storage**: Required to store questions, reviews, and user progress in SQLite database

## Platform-Specific Permissions

### Android

**Location**: `android/app/src/main/AndroidManifest.xml`

**Configured Permissions**:
```xml
<uses-permission android:name="android.permission.INTERNET" />
```

**Why Needed**:
- `INTERNET`: Allows the app to fetch demo databases from URLs via HTTP/HTTPS

**Optional Permissions** (not yet implemented):
- `POST_NOTIFICATIONS` (Android 13+): For daily review reminders
- `SCHEDULE_EXACT_ALARM` (Android 12+): For precise notification scheduling

**User Experience**:
- INTERNET permission is granted automatically (no runtime prompt)
- Notification permissions would require runtime request if implemented

### iOS

**Location**: `ios/Runner/Info.plist`

**Configured Settings**:
```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

**Why Needed**:
- `NSAppTransportSecurity`: Allows HTTP and HTTPS network requests for demo DB import
- Note: For production apps, prefer HTTPS-only by using `NSExceptionDomains` instead

**Optional Keys** (not yet implemented):
- `NSUserNotificationsUsageDescription`: Required for local notifications
  - Example: "Enable notifications to receive daily reminders for your review sessions"

**User Experience**:
- Network access is granted automatically
- Notification permissions would require runtime request with usage description

### Web

**No special permissions required!**

**Built-in Browser Capabilities**:
- Network requests: Handled by browser's fetch API (CORS must be configured on server)
- Local storage: Uses IndexedDB via Drift's web implementation
- Notifications: Would use browser's Notification API (requires user permission)

**Important Considerations**:
- Demo DB server must have proper CORS headers configured
- IndexedDB storage quotas vary by browser
- Service workers can enable offline functionality (optional)

### Windows/macOS/Linux Desktop

**No special permissions required!**

**Platform Capabilities**:
- Network access: Unrestricted by OS
- File system: SQLite database stored in app documents directory
- Notifications: Would use OS-native notification system

## Testing Permissions

### Android Testing
```bash
# Build and install APK
flutter build apk --debug
flutter install

# Verify permissions in logcat
adb logcat | grep -i permission
```

### iOS Testing (macOS required)
```bash
# Build and run on simulator
flutter run -d ios

# Check Info.plist in Xcode
open ios/Runner.xcworkspace
```

### Web Testing
```bash
# Run in Chrome with network inspector
flutter run -d chrome

# Check CORS errors in browser console (F12)
```

## Permission Best Practices

### Request Strategy
- ✅ Request permissions just-in-time (when feature is used)
- ✅ Explain why permission is needed before requesting
- ✅ Provide fallback functionality if permission is denied
- ❌ Don't request all permissions on app launch

### User Communication
When implementing notifications (future feature):
1. Show explanation dialog: "Get daily reminders to review your flashcards and maintain your learning streak"
2. Show benefit: "Users who enable reminders complete 3x more reviews"
3. Request permission only if user taps "Enable Reminders"
4. If denied, show "You can enable notifications later in Settings"

### Error Handling
```dart
// Example: Graceful handling of network permission
try {
  await importFromUrl(url);
} catch (e) {
  if (e is SocketException) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Network Error'),
        content: Text('Unable to connect. Please check your internet connection.'),
      ),
    );
  }
}
```

## Future Enhancements

### Notifications (Optional)

**Android** - Add to `AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" />
```

**iOS** - Add to `Info.plist`:
```xml
<key>NSUserNotificationsUsageDescription</key>
<string>Receive daily reminders to review your flashcards and maintain your learning streak</string>
```

**Implementation**:
```dart
// Request notification permission at runtime
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final notificationsPlugin = FlutterLocalNotificationsPlugin();
final granted = await notificationsPlugin
    .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
    ?.requestNotificationsPermission();

if (granted == true) {
  // Schedule daily review reminders
}
```

### Background Sync (Optional)

**iOS** - Add to `Info.plist`:
```xml
<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>
    <string>processing</string>
</array>
```

### Storage Access (Optional - Android 10 and below)

**Android** - If external storage is needed:
```xml
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"
                 android:maxSdkVersion="29" />
```

**Note**: Not needed for current implementation as Drift uses internal app storage.

## Troubleshooting

### "Unable to import from URL" on Android
- ✅ Verify INTERNET permission is in AndroidManifest.xml
- ✅ Check that URL is correct and accessible
- ✅ Ensure device/emulator has network connectivity
- ✅ Check for CORS errors if using web API

### "Network request failed" on iOS
- ✅ Verify NSAppTransportSecurity is configured in Info.plist
- ✅ For production, use HTTPS or configure exception domains
- ✅ Check iOS simulator has network access

### IndexedDB quota exceeded on Web
- ✅ Clear browser data and retry
- ✅ Implement database cleanup for old reviews
- ✅ Consider user notification when approaching quota

## Security Considerations

1. **Network Security**:
   - Prefer HTTPS over HTTP for demo DB URLs
   - Validate and sanitize imported JSON data
   - Implement rate limiting for URL imports

2. **Data Privacy**:
   - User review data is stored locally only
   - No analytics or tracking (privacy-first)
   - Clear data option available in Settings

3. **Input Validation**:
   - Validate JSON structure before import
   - Sanitize user-provided URLs
   - Limit file size for imports (prevent memory issues)

## References

- [Flutter Permissions Documentation](https://docs.flutter.dev/development/data-and-backend/permissions)
- [Android Permissions Guide](https://developer.android.com/guide/topics/permissions/overview)
- [iOS Info.plist Keys](https://developer.apple.com/documentation/bundleresources/information_property_list)
- [Web Permissions API](https://developer.mozilla.org/en-US/docs/Web/API/Permissions_API)

---

**Last Updated**: 2025-06-06  
**Version**: 1.0.0
