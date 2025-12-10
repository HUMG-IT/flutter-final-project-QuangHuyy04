import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bookverse/features/book/presentation/screens/book_list_screen.dart';
import 'package:bookverse/features/book/presentation/providers/book_provider.dart';
import 'package:bookverse/features/book/data/book_model.dart';

void main() {
  testWidgets('1. Hiển thị loading khi đang tải', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [booksProvider.overrideWith((ref) => const Stream.empty())],
        child: const MaterialApp(home: BookListScreen()),
      ),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('2. Hiển thị danh sách sách khi có dữ liệu', (tester) async {
    final books = [
      Book(id: '1', title: 'Test', author: 'Author', status: 'reading', addedDate: DateTime.now()),
    ];
    await tester.pumpWidget(
      ProviderScope(
        overrides: [booksProvider.overrideWith((ref) => Stream.value(books))],
        child: const MaterialApp(home: BookListScreen()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(ListTile), findsOneWidget);
  });

  testWidgets('3. Hiển thị thông báo khi trống', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [booksProvider.overrideWith((ref) => Stream.value([]))],
        child: const MaterialApp(home: BookListScreen()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(ListTile), findsNothing);
    expect(find.byType(Center), findsAtLeastNWidgets(1));
  });

  testWidgets('4. Có nút thêm sách', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: BookListScreen())),
    );
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}