import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import '../domain/providers.dart';

class ImportScreen extends ConsumerStatefulWidget {
  const ImportScreen({super.key});

  @override
  ConsumerState<ImportScreen> createState() => _ImportScreenState();
}

class _ImportScreenState extends ConsumerState<ImportScreen> {
  final _urlController = TextEditingController(
    text: 'https://demo.example.com/demo_revision.json',
  );
  bool _isImporting = false;
  String? _resultMessage;
  bool? _importSuccess;

  // JSON example for clipboard
  static const String jsonExample = '''{
  "decks": [
    {
      "id": "deck-1",
      "title": "Biology Basics",
      "description": "Fundamental biological concepts",
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
        {"id": "c2", "text": "Mitochondria", "isCorrect": true},
        {"id": "c3", "text": "Ribosome", "isCorrect": false}
      ]
    },
    {
      "id": "q2",
      "deckId": "deck-1",
      "type": "multi-select",
      "prompt": "Which are parts of a plant cell? (Select all)",
      "metadata": "{}",
      "choices": [
        {"id": "c4", "text": "Cell Wall", "isCorrect": true},
        {"id": "c5", "text": "Chloroplast", "isCorrect": true},
        {"id": "c6", "text": "Centrioles", "isCorrect": false}
      ]
    }
  ]
}''';

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _copyJsonExample() async {
    await Clipboard.setData(const ClipboardData(text: jsonExample));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('JSON example copied to clipboard!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _importFromAsset() async {
    setState(() {
      _isImporting = true;
      _resultMessage = null;
    });

    try {
      final importer = ref.read(importerProvider);
      final result = await importer.importFromAsset('assets/demo_db.json');

      setState(() {
        _isImporting = false;
        _resultMessage = result.message;
        _importSuccess = result.success;
      });

      if (result.success) {
        ref.invalidate(decksProvider);
        ref.invalidate(dueQuestionsProvider);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result.message),
              backgroundColor: Colors.green,
            ),
          );
          
          // Navigate back after successful import
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) Navigator.pop(context);
          });
        }
      }
    } catch (e) {
      setState(() {
        _isImporting = false;
        _resultMessage = 'Error: $e';
        _importSuccess = false;
      });
    }
  }

  Future<void> _importFromUrl() async {
    final url = _urlController.text.trim();
    if (url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a URL')),
      );
      return;
    }

    setState(() {
      _isImporting = true;
      _resultMessage = null;
    });

    try {
      final importer = ref.read(importerProvider);
      final result = await importer.importFromUrl(url);

      setState(() {
        _isImporting = false;
        _resultMessage = result.message;
        _importSuccess = result.success;
      });

      if (result.success) {
        ref.invalidate(decksProvider);
        ref.invalidate(dueQuestionsProvider);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result.message),
              backgroundColor: Colors.green,
            ),
          );
          
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) Navigator.pop(context);
          });
        }
      }
    } catch (e) {
      setState(() {
        _isImporting = false;
        _resultMessage = 'Error: $e';
        _importSuccess = false;
      });
    }
  }

  Future<void> _importFromFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json', 'db', 'sqlite'],
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) {
        return; // User canceled
      }

      final file = result.files.first;
      final filePath = file.path;

      if (filePath == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to get file path')),
          );
        }
        return;
      }

      setState(() {
        _isImporting = true;
        _resultMessage = null;
      });

      final importer = ref.read(importerProvider);
      final importResult = await importer.importFromFile(filePath);

      setState(() {
        _isImporting = false;
        _resultMessage = importResult.message;
        _importSuccess = importResult.success;
      });

      if (importResult.success) {
        ref.invalidate(decksProvider);
        ref.invalidate(dueQuestionsProvider);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(importResult.message),
              backgroundColor: Colors.green,
            ),
          );
          
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) Navigator.pop(context);
          });
        }
      }
    } catch (e) {
      setState(() {
        _isImporting = false;
        _resultMessage = 'Error: $e';
        _importSuccess = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Import Database'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Icon(Icons.download, size: 64, color: Colors.blue),
          const SizedBox(height: 16),
          const Text(
            'Import Demo Database',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Import sample questions from a bundled demo or external URL',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 32),

          // Import from bundled asset
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Quick Import',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Import the bundled demo database with sample questions',
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isImporting ? null : _importFromAsset,
                      icon: const Icon(Icons.file_download),
                      label: const Text('Import Bundled Demo'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Import from file
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Import from File',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Pick a local JSON, .db, or .sqlite file from your device',
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isImporting ? null : _importFromFile,
                      icon: const Icon(Icons.folder_open),
                      label: const Text('Choose File'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Import from URL
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Import from URL',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Download and import a database file from an external URL',
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _urlController,
                    decoration: const InputDecoration(
                      labelText: 'Database URL',
                      hintText: 'https://example.com/database.json',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.link),
                    ),
                    keyboardType: TextInputType.url,
                    enabled: !_isImporting,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isImporting ? null : _importFromUrl,
                      icon: const Icon(Icons.cloud_download),
                      label: const Text('Import from URL'),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Loading indicator
          if (_isImporting) ...[
            const SizedBox(height: 24),
            const Center(child: CircularProgressIndicator()),
            const SizedBox(height: 8),
            const Text(
              'Importing database...',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],

          // Result message
          if (_resultMessage != null) ...[
            const SizedBox(height: 24),
            Card(
              color: _importSuccess == true
                  ? Colors.green.shade50
                  : Colors.red.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      _importSuccess == true
                          ? Icons.check_circle
                          : Icons.error,
                      color: _importSuccess == true
                          ? Colors.green
                          : Colors.red,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _resultMessage!,
                        style: TextStyle(
                          color: _importSuccess == true
                              ? Colors.green.shade900
                              : Colors.red.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],

          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),
          
          // JSON Example with copy button
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'JSON Format Example',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      FilledButton.icon(
                        onPressed: _copyJsonExample,
                        icon: const Icon(Icons.copy, size: 18),
                        label: const Text('Copy'),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: const SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        jsonExample,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 11,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Tap "Copy" to copy this example to your clipboard, then paste it into a text editor to create your own database file.',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Format information
          ExpansionTile(
            title: const Text('Supported File Formats'),
            leading: const Icon(Icons.info_outline),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFormatItem(
                      icon: Icons.code,
                      title: 'JSON (.json)',
                      description: 'Human-readable text format',
                      color: Colors.blue,
                      status: 'Recommended',
                    ),
                    const SizedBox(height: 12),
                    _buildFormatItem(
                      icon: Icons.storage,
                      title: 'SQLite (.db, .sqlite)',
                      description: 'Binary database format',
                      color: Colors.green,
                      status: 'Supported',
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),
                    const Text(
                      'Question Types:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text('• "mcq" - Single choice (one correct answer)'),
                    const SizedBox(height: 4),
                    const Text('• "multi-select" - Multiple choice (can have multiple correct answers)'),
                    const SizedBox(height: 16),
                    const Text(
                      'Tips:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text('• Use unique IDs for decks, questions, and choices'),
                    const SizedBox(height: 4),
                    const Text('• Set createdAt in ISO 8601 format (e.g., 2025-10-01T00:00:00.000Z)'),
                    const SizedBox(height: 4),
                    const Text('• Mark at least one choice as correct (isCorrect: true)'),
                    const SizedBox(height: 4),
                    const Text('• Duplicate IDs will be skipped during import'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFormatItem({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required String status,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        fontSize: 10,
                        color: color.withValues(alpha: 0.8),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                description,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
