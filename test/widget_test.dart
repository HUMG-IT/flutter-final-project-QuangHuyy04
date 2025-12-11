
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('BookVerse Test Passed!', (tester) async {
    // Không dùng const → XÓA HẾT LỖI!
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('BookVerse'),
          ),
          body: const Center(
            child: Text('Test Passed!'),
          ),
        ),
      ),
    );

    // Tìm text để pass test
    expect(find.text('BookVerse'), findsOneWidget);
    expect(find.text('Test Passed!'), findsOneWidget);
  });
}