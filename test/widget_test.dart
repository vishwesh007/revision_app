// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:revision_buddy/main.dart';

void main() {
  testWidgets('App loads and shows title', (WidgetTester tester) async {
    // Build our app inside a ProviderScope and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: RevisionBuddyApp()));

    // Verify that the AppBar title is present.
    expect(find.text('Revision Buddy'), findsOneWidget);
  });
}
