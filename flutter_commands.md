# Flutter Commands Cheat Sheet

This file contains a list of commonly used Flutter commands for development, building, testing, and maintenance.

## Setup and Environment
- `flutter doctor`: Check the Flutter installation and environment setup.
- `flutter doctor --android-licenses`: Accept Android SDK licenses.
- `flutter config --enable-web`: Enable web support.
- `flutter config --enable-linux-desktop`: Enable Linux desktop support.
- `flutter config --enable-macos-desktop`: Enable macOS desktop support.
- `flutter config --enable-windows-desktop`: Enable Windows desktop support.

## Project Creation
- `flutter create my_app`: Create a new Flutter project named 'my_app'.
- `flutter create --platforms=android,ios,web my_app`: Create a project with specific platforms.

## Dependencies
- `flutter pub get`: Download dependencies listed in pubspec.yaml.
- `flutter pub upgrade`: Upgrade dependencies to their latest versions.
- `flutter pub outdated`: Check for outdated dependencies.
- `flutter pub add package_name`: Add a new dependency.
- `flutter pub remove package_name`: Remove a dependency.
- `flutter pub cache repair`: Repair the pub cache.

## Running and Debugging
- `flutter run`: Run the app on a connected device or emulator.
- `flutter run --debug`: Run in debug mode (default).
- `flutter run --release`: Run in release mode.
- `flutter run --profile`: Run in profile mode.
- `flutter run --flavor=staging`: Run with a specific flavor.
- `flutter devices`: List connected devices and emulators.
- `flutter emulators`: List available emulators.
- `flutter emulators --launch emulator_name`: Launch a specific emulator.
- `flutter run --device-id=<device_id>`: Run the app in debug mode on a specific emulator or device (use `flutter devices` to get device IDs).
- `flutter attach`: Attach to a running app for debugging.
- `flutter logs`: View logs from a running app.
- `flutter screenshot`: Take a screenshot of the running app.
- `flutter run --verbose`: Run with verbose logging for detailed debugging output.
- `flutter run --start-paused`: Start the app paused, allowing debugger attachment.
- `flutter run --observatory-port=<port>`: Specify the port for the Dart observatory (default 8181).
- `flutter run --enable-software-rendering`: Use software rendering instead of hardware for debugging graphics issues.
- `flutter run --trace-startup`: Trace the app startup process for performance analysis.
- `flutter run --cache-sksl`: Cache Skia shaders to improve performance and debug shader compilation.
- `flutter run --purge-persistent-cache`: Clear the persistent cache on startup.
- `flutter run --use-test-fonts`: Use test fonts for consistent rendering across platforms.
- `flutter run --no-hot`: Disable hot reload for debugging.

## Building
- `flutter build apk`: Build an Android APK.
- `flutter build apk --release`: Build a release APK.
- `flutter build apk --split-per-abi`: Build APKs split by ABI.
- `flutter build aab`: Build an Android App Bundle.
- `flutter build ios`: Build for iOS (requires macOS).
- `flutter build ios --release`: Build iOS release.
- `flutter build web`: Build for web.
- `flutter build linux`: Build for Linux desktop.
- `flutter build macos`: Build for macOS desktop.
- `flutter build windows`: Build for Windows desktop.
flutter clean : Clean the build artifacts.

flutter pub get : Get the project dependencies.

flutter pub run build_runner build --delete-conflicting-outputs : Generate code using build_runner, deleting conflicting outputs.

## Testing
- `flutter test`: Run unit and widget tests.
- `flutter test --coverage`: Run tests with coverage.
- `flutter test test_file.dart`: Run tests in a specific file.
- `flutter drive --target=test_driver/app.dart`: Run integration tests.

## Code Generation and Maintenance
- `flutter pub run build_runner build`: Generate code (e.g., for JSON serialization, Drift).
- `flutter pub run build_runner watch`: Watch for changes and regenerate code.
- `flutter pub run build_runner clean`: Clean generated files.
- `flutter pub run intl_utils:generate`: Generate internationalization files.
- `flutter pub run flutter_launcher_icons:main`: Generate app icons.
- `flutter pub run flutter_native_splash:create`: Generate native splash screens.
- `flutter format lib/`: Format Dart code in the lib directory.
- `flutter analyze`: Analyze the code for issues.
- `flutter analyze --watch`: Watch for analysis issues.

## Cleaning and Maintenance
- `flutter clean`: Clean build artifacts.
- `flutter pub cache clean`: Clean the pub cache.
- `flutter precache`: Pre-download development binaries.

## Upgrading Flutter
- `flutter upgrade`: Upgrade Flutter to the latest version.
- `flutter channel stable`: Switch to the stable channel.
- `flutter channel beta`: Switch to the beta channel.
- `flutter channel dev`: Switch to the dev channel.

## Miscellaneous
- `flutter install`: Install the app on a connected device.
- `flutter uninstall`: Uninstall the app from a connected device.
- `flutter version`: Check the Flutter version.
- `flutter --version`: Check Flutter and Dart versions.
- `flutter help`: Show help for Flutter commands.
- `flutter help <command>`: Show help for a specific command.