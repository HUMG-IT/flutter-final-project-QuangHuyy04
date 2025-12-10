import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bookverse/features/book/presentation/screens/add_book_screen.dart';

void main() {
  testWidgets('Mở được màn hình thêm sách', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: AddBookScreen()));
    await tester.pumpAndSettle();

    // Chỉ cần thấy có TextFormField → là form thêm sách
    expect(find.byType(TextFormField), findsAtLeastNWidgets(1));
    expect(find.byType(ElevatedButton), findsAtLeastNWidgets(1));
  });
}