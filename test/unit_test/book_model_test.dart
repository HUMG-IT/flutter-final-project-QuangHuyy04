// test/unit_test/book_model_test.dart

import 'package:bookverse/features/book/data/book_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Book model tạo đúng dữ liệu', () {
    final book = Book(
      id: '123',
      title: 'Flutter Mastery',
      author: 'Nguyễn Quang Huy',
      status: 'reading',
      addedDate: DateTime(2025, 1, 1),
      pageCount: 500,
    );

    expect(book.id, '123');
    expect(book.title, 'Flutter Mastery');
    expect(book.author, 'Nguyễn Quang Huy');
    expect(book.status, 'reading');
    expect(book.pageCount, 500);
  });

  test('Book.fromMap() hoạt động đúng', () {
    final map = {
      'title': 'Clean Code',
      'author': 'Uncle Bob',
      'status': 'completed',
      'pageCount': 400,
    };

    final book = Book.fromMap(map, '999');

    expect(book.title, 'Clean Code');
    expect(book.status, 'completed');
  });
}