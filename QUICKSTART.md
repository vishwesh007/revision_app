# Revision Buddy - Quick Start Guide

## 🚀 Get Running in 3 Steps

### Step 1: Install Dependencies
```powershell
cd c:\Users\vishwesh\revision_app
flutter pub get
```

### Step 2: Generate Code
```powershell
flutter pub run build_runner build --delete-conflicting-outputs
```

### Step 3: Run the App
```powershell
flutter run
```

That's it! 🎉

---

## 📱 Using the App

### Import Demo Database
1. Open the app (it will show "No decks available")
2. Tap the **"Import Demo DB"** button
3. Select **"Import Bundled Demo"**
4. Wait for success message

### Start a Review Session
1. From home screen, tap **"Start Review Session"**
2. Read the question carefully
3. Select your answer(s)
4. Tap **"Submit Answer"**
5. Review feedback and tap **"Next Question"**
6. Complete all questions to see summary

### View Decks
1. From home screen, tap any deck card
2. Browse questions and their review history
3. Expand a question to see choices and stats

### Check Statistics
1. Tap the settings icon (⚙️) in the app bar
2. View:
   - Total reviews completed
   - Overall accuracy percentage
   - Questions currently due

---

## 🧪 Run Tests

```powershell
# Run all tests
flutter test

# Run specific test file
flutter test test/spaced_repetition_test.dart

# Run with coverage
flutter test --coverage
```

---

## 🔧 Common Commands

```powershell
# Check for issues
flutter analyze

# Format code
flutter format lib/ test/

# Clean build
flutter clean
flutter pub get

# Build APK
flutter build apk --release
```

---

## 💡 Tips

### Faster Development
- Use hot reload: Press `r` in terminal while app is running
- Use hot restart: Press `R` in terminal
- Keep the app running and edit code - changes apply instantly!

### Debug Mode
- Tap the debug banner to hide it
- Use Flutter DevTools for debugging
- Check console for error messages

### Custom Demo URL
Edit `lib/presentation/import_screen.dart` line 24 to change the default URL:
```dart
final _urlController = TextEditingController(
  text: 'https://your-url.com/database.json',
);
```

---

## 📚 Sample Questions Included

The bundled demo includes:

**Biology Basics** (3 questions)
- Mitochondria (MCQ)
- Eukaryotic cell parts (Multi-select)
- Ribosome function (MCQ)

**Programming Concepts** (2 questions)
- Binary search complexity (MCQ)
- Programming paradigms (Multi-select)

---

## ❓ Troubleshooting

### "No devices found"
```powershell
# For Windows (Chrome)
flutter run -d chrome

# For Android emulator
# Open Android Studio and start an emulator first
flutter devices
flutter run
```

### Build errors
```powershell
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Import fails
- Check internet connection (for URL imports)
- Verify JSON format matches the example in README
- Use bundled demo first to test

---

## 🎯 Next Actions

1. ✅ **App is running** - Import demo and try a review session
2. 📚 **Read README.md** - Full documentation and features
3. 🧪 **Run tests** - See SM-2 algorithm in action
4. 🎨 **Customize** - Replace demo data with your own questions
5. 🚀 **Deploy** - Build APK and share with others

---

**You're ready to go!** 🎉

The app is fully functional with spaced repetition, statistics, and a beautiful UI.

Happy learning! 📖✨
