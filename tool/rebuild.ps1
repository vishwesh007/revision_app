param(
  [switch]$SkipTests
)

Write-Host "==> Cleaning build artifacts" -ForegroundColor Cyan
flutter clean

Write-Host "==> Fetching dependencies" -ForegroundColor Cyan
flutter pub get

Write-Host "==> Regenerating code (build_runner)" -ForegroundColor Cyan
flutter pub run build_runner build --delete-conflicting-outputs

Write-Host "==> Analyzing project" -ForegroundColor Cyan
flutter analyze

if (-not $SkipTests) {
  Write-Host "==> Running tests" -ForegroundColor Cyan
  flutter test
}

Write-Host "==> Building release APK" -ForegroundColor Cyan
flutter build apk --release

Write-Host "==> Done. APK at build/app/outputs/flutter-apk/app-release.apk" -ForegroundColor Green
