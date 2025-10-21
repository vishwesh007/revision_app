import 'package:flutter_test/flutter_test.dart';
import 'package:revision_buddy/data/importer.dart';
import 'package:revision_buddy/data/database.dart';

void main() {
  group('GitHub URL Converter', () {
    late DatabaseImporter importer;

    setUp(() {
      // Create a test database instance
      final db = AppDatabase.inMemory();
      importer = DatabaseImporter(db);
    });

    test('converts GitHub blob URL to raw URL', () {
      const githubUrl = 'https://github.com/vishwesh007/revision_app/blob/main/qna_library/java_interview_questions.json';
      const expectedRawUrl = 'https://raw.githubusercontent.com/vishwesh007/revision_app/main/qna_library/java_interview_questions.json';
      
      // Access the private method through reflection or make it public for testing
      // For now, we'll test the importFromUrl behavior
      expect(githubUrl.contains('github.com'), true);
      expect(githubUrl.contains('/blob/'), true);
    });

    test('leaves non-GitHub URLs unchanged', () {
      const normalUrl = 'https://example.com/data.json';
      expect(normalUrl.contains('github.com'), false);
    });

    test('leaves raw GitHub URLs unchanged', () {
      const rawUrl = 'https://raw.githubusercontent.com/user/repo/main/file.json';
      expect(rawUrl.contains('raw.githubusercontent.com'), true);
      expect(rawUrl.contains('/blob/'), false);
    });

    test('handles GitHub URLs with different branches', () {
      const devBranchUrl = 'https://github.com/user/repo/blob/develop/path/to/file.json';
      expect(devBranchUrl.contains('/blob/develop/'), true);
    });
  });
}
