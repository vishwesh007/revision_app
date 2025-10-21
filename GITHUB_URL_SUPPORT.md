# GitHub URL Support - Import Feature

## Overview
The app now supports **both GitHub URL formats** when importing question databases! You can paste either the regular GitHub page URL or the raw content URL, and the app will automatically handle the conversion.

## Supported URL Formats

### ✅ GitHub UI URL (Regular Page)
```
https://github.com/vishwesh007/revision_app/blob/main/qna_library/java_interview_questions.json
```

### ✅ Raw GitHub URL (Direct Content)
```
https://raw.githubusercontent.com/vishwesh007/revision_app/main/qna_library/java_interview_questions.json
```

Both formats work! The app automatically detects GitHub URLs and converts them to the raw format for you.

## How It Works

When you paste a GitHub URL like:
```
https://github.com/[owner]/[repo]/blob/[branch]/[path]
```

The app automatically converts it to:
```
https://raw.githubusercontent.com/[owner]/[repo]/[branch]/[path]
```

This conversion happens transparently in the background, so you don't need to manually change the URL format.

## Usage

1. Open the app's **Import screen**
2. Tap **"Import from URL"**
3. Paste **either** URL format:
   - The GitHub page URL (what you see in your browser)
   - The raw URL (from clicking "Raw" button on GitHub)
4. Tap **Import**
5. Done! ✅

## Examples

### Java Interview Questions
**Regular URL:**
```
https://github.com/vishwesh007/revision_app/blob/main/qna_library/java_interview_questions.json
```

**Raw URL (also works):**
```
https://raw.githubusercontent.com/vishwesh007/revision_app/main/qna_library/java_interview_questions.json
```

### Other Files
Works with any JSON file on GitHub:
```
https://github.com/user/repo/blob/main/data/questions.json
https://github.com/user/repo/blob/develop/assets/demo.json
```

## Benefits

✅ **User-friendly**: No need to click "Raw" button on GitHub  
✅ **Flexible**: Accept URLs in any format  
✅ **Automatic**: Conversion happens in the background  
✅ **Error-free**: Reduces import failures from incorrect URLs  

## Technical Details

The conversion is handled by the `_convertToRawGitHubUrl()` method in `lib/data/importer.dart`:

```dart
String _convertToRawGitHubUrl(String url) {
  // Detects pattern: github.com/[owner]/[repo]/blob/[branch]/[path]
  // Converts to: raw.githubusercontent.com/[owner]/[repo]/[branch]/[path]
}
```

The method:
- Uses regex to detect GitHub blob URLs
- Extracts owner, repo, branch, and file path
- Constructs the corresponding raw URL
- Returns the original URL if it's not a GitHub blob URL

## Limitations

- Only works with **public** GitHub repositories (private repos require authentication)
- Must be a direct link to a file (not a folder or commit)
- Supports `github.com` domain (not GitHub Enterprise URLs)

## Troubleshooting

**Issue**: "Failed to download" error  
**Solution**: Ensure the repository is public and the file exists

**Issue**: "Invalid JSON format" error  
**Solution**: Verify the file is actually a valid JSON file on GitHub

**Issue**: Network timeout  
**Solution**: Check your internet connection and try again

## Related Files

- `lib/data/importer.dart` - Import logic with URL conversion
- `lib/presentation/import_screen.dart` - UI for importing from URLs
- `test/github_url_converter_test.dart` - Unit tests for URL conversion
