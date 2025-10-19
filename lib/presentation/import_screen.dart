import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/providers.dart';

class ImportScreen extends ConsumerStatefulWidget {
  const ImportScreen({super.key});

  @override
  ConsumerState<ImportScreen> createState() => _ImportScreenState();
}

class _ImportScreenState extends ConsumerState<ImportScreen> {
  final _urlController = TextEditingController(
    text: 'https://demo.example.com/demo_revision.db',
  );
  bool _isImporting = false;
  String? _resultMessage;
  bool? _importSuccess;

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
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
          
          // Format information
          ExpansionTile(
            title: const Text('Supported Formats'),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '• JSON format (.json)',
                      style: TextStyle(fontFamily: 'monospace'),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '• SQLite database (.db, .sqlite) - Coming soon',
                      style: TextStyle(fontFamily: 'monospace', color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'JSON Example:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        '''
{
  "decks": [{
    "id": "deck-1",
    "title": "Biology",
    "description": "...",
    "createdAt": "2025-10-01T00:00:00.000Z"
  }],
  "questions": [{
    "id": "q1",
    "deckId": "deck-1",
    "type": "mcq",
    "prompt": "Question text?",
    "choices": [
      {"id": "c1", "text": "Option A", "isCorrect": false},
      {"id": "c2", "text": "Option B", "isCorrect": true}
    ]
  }]
}
''',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
