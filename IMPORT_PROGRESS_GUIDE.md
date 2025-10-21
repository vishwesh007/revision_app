# Import Progress Feature - User Guide

## What's New? 🎉

The app now shows **real-time progress** when importing questions! No more wondering if the app is frozen.

## What You'll See

### Progress Bar
A blue progress bar that fills up as questions are imported:
```
████████████░░░░░░░░  60%
```

### Status Messages
Clear messages showing what's happening:
- 📥 "Downloading..." (for URL imports)
- 📄 "Processing file..." (for file imports)
- 🔄 "Parsing JSON..." (reading the file)
- 📦 "Importing decks..." (adding decks)
- ✅ "Importing questions... (150/200)" (adding questions with count)
- ✨ "Finalizing..." (finishing up)
- ✓ "Import complete!" (done!)

## Import Methods

### 1. From Asset
Click "Import Demo Database" to load the built-in 200 Java interview questions.

**What to expect:**
- Takes 2-5 seconds for 200 questions
- Shows progress bar filling from 0% to 100%
- Updates every 50 questions

### 2. From URL
Paste a URL to a JSON file and click "Import from URL".

**Supported URLs:**
- ✅ Direct JSON URLs: `https://example.com/data.json`
- ✅ GitHub UI URLs: `https://github.com/user/repo/blob/main/file.json`
- ✅ GitHub Raw URLs: `https://raw.githubusercontent.com/user/repo/main/file.json`

**What to expect:**
- "Downloading..." message appears first
- Progress bar shows parsing and import progress
- GitHub URLs are automatically converted to raw format

### 3. From File
Click "Import from File" to select a local `.json`, `.db`, or `.sqlite` file.

**What to expect:**
- File picker opens
- "Processing file..." message shows
- Progress bar updates as questions are added

## Performance Tips

### For Best Performance:
- ✅ Use WiFi for URL imports
- ✅ Close other heavy apps during large imports
- ✅ Wait for "Import complete!" before navigating away

### Import Speeds:
- **Small (1-50 questions)**: < 1 second
- **Medium (50-200 questions)**: 2-5 seconds  
- **Large (200-500 questions)**: 5-10 seconds
- **Very Large (500+ questions)**: 10-30 seconds

## Understanding the Progress Bar

The progress bar uses different colors:
- **Gray background**: Total progress to complete
- **Blue fill**: Current progress completed
- **Indeterminate (animated)**: Starting up (0%)

### Progress Breakdown:
- 10% - Parsing JSON
- 10% - Importing decks
- 70% - Importing questions (bulk of work)
- 10% - Finalizing and saving

## What if Import Fails?

### Common Issues:

**"Failed to download: HTTP 404"**
- The URL doesn't exist
- Check the URL is correct
- For GitHub, make sure the file is public

**"Invalid JSON format"**
- The file isn't valid JSON
- Try opening it in a text editor to check
- Make sure it matches the expected format (see JSON example)

**"File not found"**
- The file path is invalid
- Try selecting the file again

**"Failed to import: [error]"**
- Check your internet connection (for URLs)
- Make sure the file isn't corrupted
- Try a smaller file first to test

### Troubleshooting:
1. **Check the format**: Copy the JSON example and compare
2. **Try the demo**: Use "Import Demo Database" first
3. **Start small**: Test with 1-2 questions before importing hundreds
4. **Check errors**: Read the error message carefully

## Behind the Scenes 🔧

### Technical Details (for curious users):

**Why is it fast now?**
- JSON parsing happens in a separate thread (isolate)
- Questions are processed in batches of 50
- Database uses transactions for efficiency
- Small delays prevent UI blocking

**Is the UI really responsive?**
Yes! The app:
- Processes 50 questions at a time
- Takes tiny 1ms breaks between batches
- Updates progress every batch
- Keeps the UI thread free

**Can I use the app during import?**
- ⚠️ Best to wait for import to complete
- The import screen stays open until done
- You'll see "Import complete!" when ready
- The app will auto-close after success

## Tips for Large Imports

### Importing 500+ Questions?

1. **Be patient**: Large imports take time
2. **Watch progress**: The counter shows X/Y questions
3. **Don't close app**: Let it finish completely
4. **Check result**: Wait for success message

### Creating Large Question Sets?

**Best practices:**
- Break into multiple files (200 questions each)
- Import one at a time
- Check after each import
- Use descriptive deck names

### Example Structure:
```
java_basics.json (150 questions)
java_advanced.json (200 questions)
java_frameworks.json (180 questions)
```

## Need Help?

### Questions?
- Check GITHUB_URL_SUPPORT.md for URL format help
- See java_questions_prompt.md for creating questions
- Review the JSON example in the app

### Report Issues:
If you experience freezing or errors, note:
- File size
- Number of questions
- Error message
- Device/OS version

---

**Enjoy your smooth importing experience! 🚀**
