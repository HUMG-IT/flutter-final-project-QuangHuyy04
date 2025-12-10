import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bookverse/features/book/presentation/screens/statistics_screen.dart';
import 'package:bookverse/features/book/presentation/providers/book_provider.dart';

void main() {
  testWidgets('Hiển thị màn hình thống kê', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [booksProvider.overrideWith((ref) => Stream.value([]))],
        child: const MaterialApp(home: StatisticsScreen()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('Thống kê'), findsOneWidget);
  });
}