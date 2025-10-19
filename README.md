# Revision Buddy

A Flutter application for spaced repetition learning with support for MCQ (Multiple Choice Questions) and multi-select questions. Uses the SM-2 algorithm for optimal review scheduling.

## Features

- ✅ **Spaced Repetition**: SM-2 algorithm for intelligent review scheduling
- ✅ **Question Types**: Single-choice MCQ and multiple-select questions
- ✅ **Demo DB Import**: Import demo databases from bundled assets or URLs
- ✅ **Local Storage**: SQLite database with Drift ORM
- ✅ **Review Sessions**: Track progress with accuracy and statistics
- ✅ **Daily Notifications**: Schedule reminders to maintain your learning streak (Android)
- ✅ **Clean Architecture**: Separated presentation, domain, and data layers
- ✅ **Tests**: Unit and widget tests for core functionality

## Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)

### Installation

1. Clone the repository:
```bash
git clone <your-repo-url>
cd revision_app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Generate code (Drift, Freezed, JSON serialization):
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. Run the app:
```bash
flutter run
```

## Platform-Specific Setup

### Android

**Permissions**: The app requires INTERNET permission for importing demo databases from URLs. This is already configured in `android/app/src/main/AndroidManifest.xml`.

To build APK:
```bash
flutter build apk --release
```

To build App Bundle:
```bash
flutter build appbundle --release
```

### iOS

**Permissions**: Network access is configured in `ios/Runner/Info.plist` to allow HTTP/HTTPS requests for demo DB import.

To build for iOS (requires macOS):
```bash
flutter build ios --release
```

**Note**: You may need to configure code signing in Xcode before building.

### Web

The app supports web deployment with IndexedDB for local storage. No special permissions required.

To build for web:
```bash
flutter build web --release
```

To run in Chrome:
```bash
flutter run -d chrome
```

To run in Edge:
```bash
flutter run -d edge
```

Deployed web builds can be served from any static hosting (Firebase Hosting, GitHub Pages, Netlify, etc.).

### Windows/macOS/Linux Desktop

No special permissions required. SQLite database is stored in the app's documents directory.

To build:
```bash
flutter build windows  # Windows
flutter build macos    # macOS
flutter build linux    # Linux
```

## Running Tests

Run all tests:
```bash
flutter test
```

Run tests with coverage:
```bash
flutter test --coverage
```

Run specific test file:
```bash
flutter test test/spaced_repetition_test.dart
```

## Project Structure

```
lib/
├── data/
│   ├── database.dart          # Drift database schema and queries
│   └── importer.dart          # JSON import logic
├── domain/
│   ├── models.dart            # Domain models (Freezed)
│   ├── providers.dart         # Riverpod providers
│   └── spaced_repetition.dart # SM-2 algorithm implementation
├── presentation/
│   ├── home_screen.dart       # Main dashboard
│   ├── import_screen.dart     # Database import UI
│   ├── deck_screen.dart       # Deck details and questions
│   ├── review_screen.dart     # Review session flow
│   └── settings_screen.dart   # Settings and statistics
└── main.dart                  # App entry point

test/
├── spaced_repetition_test.dart # SM-2 algorithm tests
└── importer_test.dart          # Database import tests

assets/
└── demo_db.json                # Bundled demo database
```

## Importing Demo Database

### Option 1: Bundled Demo (Quick Start)

1. Open the app
2. Tap **"Import Demo DB"** button
3. Select **"Import Bundled Demo"**
4. Done! Sample questions are now available

### Option 2: From URL

1. Open the app
2. Tap **"Import Demo DB"**
3. Enter a JSON file URL (or use the prefilled demo URL)
4. Tap **"Import from URL"**

### Demo DB JSON Format

```json
{
  "decks": [
    {
      "id": "deck-1",
      "title": "Biology Basics",
      "description": "Fundamental concepts",
      "createdAt": "2025-10-01T00:00:00.000Z"
    }
  ],
  "questions": [
    {
      "id": "q1",
      "deckId": "deck-1",
      "type": "mcq",
      "prompt": "Which organelle is the powerhouse of the cell?",
      "metadata": "{}",
      "choices": [
        {"id": "c1", "text": "Nucleus", "isCorrect": false},
        {"id": "c2", "text": "Mitochondria", "isCorrect": true}
      ]
    }
  ]
}
```

**Supported question types:**
- `"mcq"` - Single-choice multiple choice question
- `"multi-select"` - Multiple correct answers allowed

## SM-2 Algorithm

The app uses the SuperMemo 2 (SM-2) algorithm for spaced repetition:

- **First review**: 1 day
- **Second review**: 6 days
- **Subsequent reviews**: interval × easiness factor
- **Quality < 3**: Reset to day 1 (failed recall)
- **Easiness factor**: Adjusted based on recall quality (min 1.3)

Quality scores (0-5):
- **5**: Perfect recall
- **4**: Correct after hesitation
- **3**: Correct with difficulty
- **2**: Incorrect but familiar
- **1**: Vague recall
- **0**: Complete blackout

## Configuration

### Replacing the Demo URL

Edit `lib/presentation/import_screen.dart`:

```dart
final _urlController = TextEditingController(
  text: 'https://your-server.com/your-database.json', // Change this
);
```

### Customizing the Bundled Demo

Replace `assets/demo_db.json` with your own JSON file following the format above.

## Notifications

### Android

The app supports **daily reminder notifications** on Android to help you maintain your learning streak!

#### Setup:
1. Open the app and go to **Settings**
2. Toggle **"Daily Reminders"** ON
3. Grant notification permission when prompted
4. Tap **"Reminder Time"** to choose your preferred time
5. Optionally, tap **"Test Notification"** to verify it works

#### Features:
- ✅ Schedule daily reminders at any time
- ✅ Persistent across app restarts
- ✅ Works after device reboot
- ✅ Android 13+ permission handling
- ✅ Test notification feature

#### Requirements:
- Android 5.0+ (API 21+)
- Notification permission (Android 13+, automatically requested)
- For some devices (Xiaomi, Oppo, etc.), enable "Autostart" permission

For detailed troubleshooting, see `NOTIFICATIONS_GUIDE.md`.

### iOS

iOS notification support coming soon! The app currently works great on iOS, just without daily reminders.

## CI/CD

GitHub Actions workflow runs on every push and PR:
- Linting with `flutter analyze`
- Unit and widget tests
- Build verification

See `.github/workflows/flutter.yml` for details.

## Dependencies

### Production
- `flutter_riverpod` - State management
- `drift` + `sqlite3_flutter_libs` - Local database
- `freezed` + `json_annotation` - Immutable models and JSON serialization
- `http` - Network requests
- `path_provider` - File system paths
- `uuid` - UUID generation

### Development
- `build_runner` - Code generation
- `drift_dev` - Drift code generator
- `freezed` + `json_serializable` - Model code generators
- `flutter_test` - Testing framework
- `mocktail` - Mocking library

## Troubleshooting

### Build errors after cloning

Run code generation:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Database issues

Clear app data and reimport:
1. Open Settings
2. Tap "Clear All Data"
3. Reimport the demo database

### Tests failing

Ensure code generation is complete:
```bash
flutter pub run build_runner build
flutter test
```

## License

MIT License - feel free to use this project as a template for your own spaced repetition apps!

## Contributing

Contributions welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Add tests for new functionality
4. Run `flutter analyze` and `flutter test`
5. Submit a pull request

## Roadmap

- [x] Notifications for daily reviews (Android) ✨ **NEW!**
- [ ] iOS notification support
- [ ] Cloud sync (Firebase/REST API)
- [ ] Anki deck import (.apkg)
- [ ] Export sessions to CSV
- [ ] Dark mode
- [ ] Statistics graphs and charts
- [ ] Rich notifications with review actions

---

Built with ❤️ using Flutter and the SM-2 algorithm
