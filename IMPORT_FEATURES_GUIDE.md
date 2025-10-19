# Database Import Features Guide

## ✅ Enhanced Import Features

Your Revision Buddy app now supports **multiple import methods** with enhanced user experience!

### 🎯 New Features Added

1. **Multiple File Format Support**
   - ✅ JSON files (.json) - Human-readable format
   - ✅ SQLite databases (.db, .sqlite) - Binary database format
   - ✅ URL imports for both JSON and SQLite files

2. **JSON Example with Copy Button**
   - ✅ Built-in JSON example visible in the app
   - ✅ One-tap copy to clipboard functionality
   - ✅ Easy template for creating custom databases

3. **File Picker Integration**
   - ✅ Browse and select local files from device storage
   - ✅ Filter by supported file types (.json, .db, .sqlite)
   - ✅ Native file picker UI on Android

4. **Enhanced Import Screen**
   - ✅ Three import methods: Bundled Demo, File Picker, URL
   - ✅ Format information with expandable details
   - ✅ Visual status indicators for import success/failure
   - ✅ Helpful tips and guidelines

## 📱 User Guide

### Method 1: Quick Import (Bundled Demo)

**Use this for:** Getting started quickly with sample data

1. Open the app
2. Tap **"Import Demo DB"** on home screen
3. Tap **"Import Bundled Demo"**
4. Done! Sample questions are immediately available

### Method 2: Import from File

**Use this for:** Importing your own database files from device storage

1. Open the app
2. Tap **"Import Demo DB"**
3. Tap **"Choose File"** in the "Import from File" section
4. Browse and select your .json, .db, or .sqlite file
5. Wait for import to complete
6. Questions are now available!

**Supported file types:**
- `.json` - Text-based database format (recommended for creating/editing)
- `.db` - SQLite database file
- `.sqlite` - SQLite database file (alternative extension)

### Method 3: Import from URL

**Use this for:** Downloading databases from the internet

1. Open the app
2. Tap **"Import Demo DB"**
3. Enter or paste the database URL
4. Tap **"Import from URL"**
5. Wait for download and import
6. Questions are ready!

**URL formats supported:**
- `https://example.com/database.json` - JSON file
- `https://example.com/database.db` - SQLite file
- `https://example.com/database.sqlite` - SQLite file

### Using the JSON Example

Want to create your own database? Use the built-in example!

1. Scroll to **"JSON Format Example"** section
2. Tap the **"Copy"** button
3. Paste into any text editor
4. Modify the decks, questions, and choices
5. Save as `.json` file
6. Import using the File Picker method!

## 🔧 Technical Details

### JSON Format Specification

```json
{
  "decks": [
    {
      "id": "unique-deck-id",
      "title": "Deck Title",
      "description": "Deck description",
      "createdAt": "2025-10-01T00:00:00.000Z"
    }
  ],
  "questions": [
    {
      "id": "unique-question-id",
      "deckId": "unique-deck-id",
      "type": "mcq",
      "prompt": "Question text here?",
      "metadata": "{}",
      "choices": [
        {"id": "choice-1", "text": "Option 1", "isCorrect": false},
        {"id": "choice-2", "text": "Option 2", "isCorrect": true},
        {"id": "choice-3", "text": "Option 3", "isCorrect": false}
      ]
    }
  ]
}
```

### Question Types

**MCQ (Multiple Choice Question)**
- Type: `"mcq"`
- Only ONE choice can be marked as correct
- User selects a single answer
- Example: "Which organelle is the powerhouse of the cell?"

**Multi-Select**
- Type: `"multi-select"`
- MULTIPLE choices can be marked as correct
- User can select multiple answers
- Example: "Which are parts of a plant cell? (Select all)"

### Field Requirements

| Field | Required | Format | Notes |
|-------|----------|--------|-------|
| deck.id | Yes | String | Must be unique |
| deck.title | Yes | String | Display name |
| deck.description | No | String | Optional description |
| deck.createdAt | Yes | ISO 8601 | e.g., "2025-10-01T00:00:00.000Z" |
| question.id | Yes | String | Must be unique |
| question.deckId | Yes | String | Must match existing deck.id |
| question.type | Yes | "mcq" or "multi-select" | Question type |
| question.prompt | Yes | String | Question text |
| question.metadata | No | JSON String | Optional metadata (default: "{}") |
| choice.id | Yes | String | Must be unique |
| choice.text | Yes | String | Choice text |
| choice.isCorrect | Yes | Boolean | true or false |

### SQLite Database Format

If you have an existing SQLite database, it must follow this schema:

**Decks Table:**
```sql
CREATE TABLE decks (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  created_at DATETIME NOT NULL
);
```

**Questions Table:**
```sql
CREATE TABLE questions (
  id TEXT PRIMARY KEY,
  deck_id TEXT NOT NULL,
  type TEXT NOT NULL,
  prompt TEXT NOT NULL,
  metadata TEXT NOT NULL,
  FOREIGN KEY (deck_id) REFERENCES decks(id)
);
```

**Choices Table:**
```sql
CREATE TABLE choices (
  id TEXT PRIMARY KEY,
  question_id TEXT NOT NULL,
  choice_text TEXT NOT NULL,
  is_correct INTEGER NOT NULL,
  FOREIGN KEY (question_id) REFERENCES questions(id)
);
```

**Reviews Table (optional):**
```sql
CREATE TABLE reviews (
  id TEXT PRIMARY KEY,
  question_id TEXT NOT NULL,
  reviewed_at DATETIME NOT NULL,
  quality INTEGER NOT NULL,
  interval INTEGER NOT NULL,
  repetition INTEGER NOT NULL,
  easiness REAL NOT NULL,
  next_review DATETIME NOT NULL,
  FOREIGN KEY (question_id) REFERENCES questions(id)
);
```

## 📝 Creating Custom Databases

### Option 1: Using the JSON Example

1. **Copy the Example**
   - Open Import screen in app
   - Scroll to "JSON Format Example"
   - Tap "Copy" button

2. **Edit in Text Editor**
   - Paste into any text editor (Notepad, VS Code, etc.)
   - Modify deck titles and descriptions
   - Add/remove questions
   - Update choices

3. **Save as JSON**
   - Save file with `.json` extension
   - Example: `my_biology_questions.json`

4. **Import**
   - Use File Picker method to import your file

### Option 2: Creating SQLite Database

1. **Use SQLite Tools**
   - DB Browser for SQLite (recommended)
   - SQLite command line
   - Python with sqlite3 module

2. **Create Tables**
   - Follow the schema provided above
   - Insert data into decks, questions, and choices tables

3. **Export Database**
   - Save as `.db` or `.sqlite` file

4. **Import**
   - Use File Picker or URL method

### Option 3: Converting Existing Data

If you have data in other formats:

**From CSV:**
```python
import sqlite3
import csv

# Create database
conn = sqlite3.connect('my_database.db')
cursor = conn.cursor()

# Create tables (use schema above)
# ...

# Import from CSV
with open('questions.csv', 'r') as f:
    reader = csv.DictReader(f)
    for row in reader:
        cursor.execute(
            "INSERT INTO questions VALUES (?, ?, ?, ?, ?)",
            (row['id'], row['deck_id'], row['type'], row['prompt'], '{}')
        )

conn.commit()
conn.close()
```

**From Excel:**
- Export to CSV first
- Use CSV import method above

**From Anki (.apkg):**
- Use third-party Anki converter tools
- Export to JSON or SQLite format
- Import using file picker

## 🎨 UI Features

### Visual Feedback

**Import Success:**
- ✅ Green success card
- Check icon
- Message: "Successfully imported X decks and Y questions"
- Auto-navigates back to home after 1 second

**Import Failure:**
- ❌ Red error card
- Error icon
- Detailed error message
- Stays on screen for troubleshooting

**Loading State:**
- Circular progress indicator
- "Importing database..." message
- Disabled buttons during import

### Format Information Panel

Expandable panel with:
- Supported file formats with color-coded badges
- Question type explanations
- Tips for creating databases
- Field requirements

### Copy Button

- Located next to JSON example title
- Filled button style with copy icon
- Shows green snackbar confirmation
- Instant clipboard copy

## 🔍 Import Process Details

### JSON Import Flow

1. **Read file content** (from asset, file, or URL)
2. **Parse JSON** - Validate structure
3. **Check for duplicates** - Skip if ID already exists
4. **Import decks** - Insert deck records
5. **Import questions** - Insert question records
6. **Import choices** - Insert choice records for each question
7. **Show result** - Display success/failure message
8. **Refresh UI** - Update home screen deck list

### SQLite Import Flow

1. **Read file bytes** (from file or URL)
2. **Save to temporary location** - Create temp copy
3. **Open SQLite database** - Validate schema
4. **Read decks** - Query decks table
5. **Check for duplicates** - Skip if ID already exists
6. **Import decks** - Copy to main database
7. **Read questions** - Query questions table
8. **Import questions** - Copy to main database
9. **Read choices** - Query choices for each question
10. **Import choices** - Copy to main database
11. **Close and cleanup** - Remove temporary file
12. **Show result** - Display success message

### Duplicate Handling

**What happens with duplicates:**
- Import checks for existing IDs before inserting
- If deck ID exists: Skips that deck
- If question ID exists: Skips that question and its choices
- Import continues with remaining items
- Result message shows how many items were imported

**Why this approach:**
- Prevents data corruption
- Allows partial updates
- Safe to re-import files
- No data loss of existing items

## 🛠️ Troubleshooting

### Import fails with "Failed to parse JSON"

**Cause:** Invalid JSON syntax

**Solutions:**
1. Validate JSON using online tools (jsonlint.com)
2. Check for:
   - Missing commas between objects
   - Missing closing braces/brackets
   - Unescaped quotes in text
   - Trailing commas (not allowed in JSON)
3. Use the built-in example as template
4. Copy example and modify carefully

### Import fails with "Invalid SQLite database format"

**Cause:** Database doesn't match required schema

**Solutions:**
1. Verify table names match exactly (case-sensitive)
2. Check column names and types
3. Ensure foreign keys reference correct tables
4. Use DB Browser for SQLite to inspect/fix schema

### File picker doesn't show my file

**Cause:** File extension not recognized

**Solutions:**
1. Rename file with correct extension (.json, .db, .sqlite)
2. Ensure file is on device storage (not cloud)
3. Check file isn't corrupted

### URL import fails with network error

**Cause:** Connection issues or incorrect URL

**Solutions:**
1. Verify URL is accessible in browser
2. Check internet connection
3. Ensure URL points to raw file (not HTML page)
4. For GitHub: Use "Raw" file URL
5. Check server has CORS headers enabled

### Import succeeds but shows "0 decks and 0 questions"

**Cause:** All items were duplicates

**Solutions:**
1. Check if data already exists in database
2. Use different IDs for new items
3. Clear all data from Settings if you want to reimport

### Copy button doesn't work

**Cause:** Clipboard permission issue (rare)

**Solutions:**
1. Try again (may be temporary glitch)
2. Manually select and copy text from example
3. Check app permissions in Android settings

## 📊 Import Statistics

After successful import, you'll see:
- Number of decks imported
- Number of questions imported
- Total counts exclude duplicates
- Home screen automatically refreshes to show new content

## 🔐 Data Safety

### What happens during import:

**Existing data is preserved:**
- Import only adds new items
- Never deletes or modifies existing data
- Duplicate IDs are safely skipped

**Transaction safety:**
- Each import is atomic (all or nothing)
- If import fails, no partial data is saved
- Database remains in consistent state

**File cleanup:**
- Temporary SQLite files are deleted after import
- No leftover files on device
- Minimal storage impact

## 📚 Example Databases

### Sample Biology Deck

See the built-in JSON example in the app for a complete biology deck with:
- 2 sample questions (MCQ and multi-select)
- 6 total choices
- Proper ID structure
- Correct date formatting

### Creating Subject-Specific Decks

**Math Deck:**
- Use MCQ for formula identification
- Use multi-select for steps in solving equations
- Include metadata with difficulty level

**Language Learning:**
- Use MCQ for vocabulary
- Use multi-select for grammar rules
- Include metadata with word type (noun, verb, etc.)

**Programming:**
- Use MCQ for syntax questions
- Use multi-select for identifying correct code patterns
- Include metadata with programming language

## 🚀 Best Practices

1. **Use descriptive IDs:**
   - Good: `"bio-cell-q1"`, `"math-algebra-q5"`
   - Bad: `"q1"`, `"1"`, `"abc"`

2. **Keep IDs consistent:**
   - Use same prefix for related items
   - Example: All biology questions start with `"bio-"`

3. **Test with small files first:**
   - Start with 1-2 questions
   - Verify import works
   - Then import full database

4. **Backup before bulk import:**
   - Export existing data if possible
   - Or use Settings → Clear All Data to start fresh

5. **Use JSON for development:**
   - Easy to edit and version control
   - Can be stored in GitHub
   - Human-readable for review

6. **Use SQLite for distribution:**
   - Smaller file size
   - Faster import
   - Better for large databases (1000+ questions)

## 📄 File Size Recommendations

| Question Count | Recommended Format | Typical Size |
|----------------|-------------------|--------------|
| 1-100 | JSON | < 50 KB |
| 100-500 | JSON or SQLite | 50-250 KB |
| 500-2000 | SQLite | 250 KB - 1 MB |
| 2000+ | SQLite | 1 MB+ |

## 🎓 Advanced Tips

### Metadata Usage

Store additional data in the `metadata` field:

```json
{
  "id": "q1",
  "metadata": "{\"difficulty\": \"easy\", \"tags\": [\"cell-biology\", \"organelles\"]}"
}
```

### Batch Imports

Import multiple files:
1. Import first file
2. Wait for completion
3. Import next file
4. Data from all files combines safely

### URL Import for Team Sharing

1. Store database JSON on cloud (Dropbox, Google Drive, GitHub)
2. Get public sharing link
3. Distribute link to team
4. Everyone imports same database via URL

### Creating Study Sets

Organize by topics:
- One deck per chapter/topic
- Use descriptive titles
- Link related decks via metadata

---

**Created:** October 19, 2025  
**Status:** ✅ Complete and Ready to Use  
**APK Location:** `build/app/outputs/flutter-apk/app-release.apk`  
**APK Size:** 55.8 MB

**Your import features are now fully functional!** 🎉
