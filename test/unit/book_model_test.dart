import 'package:flutter_test/flutter_test.dart';
import 'package:bookverse/features/book/data/book_model.dart';

void main() {
  group('Book Model Tests', () {
    test('Create Book with required fields', () {
      final now = DateTime.now();
      final book = Book(
        id: '1',
        title: 'Test Title',
        author: 'Test Author',
        status: 'reading',
        addedDate: now,
      );

      expect(book.id, '1');
      expect(book.title, 'Test Title');
      expect(book.author, 'Test Author');
      expect(book.status, 'reading');
      expect(book.addedDate, now);
      expect(book.pageCount, isNull);
    });

    test('Create Book with pageCount', () {
      final book = Book(
        id: '2',
        title: 'Full Book',
        author: 'Full Author',
        status: 'completed',
        addedDate: DateTime(2023, 1, 1),
        pageCount: 300,
      );

      expect(book.pageCount, 300);
    });

    test('toMap converts Book to Map correctly', () {
      final fixedDate = DateTime(2023, 1, 1);
      final book = Book(
        id: '3',
        title: 'Map Book',
        author: 'Map Author',
        status: 'wantToRead',
        addedDate: fixedDate,
        pageCount: 250,
      );

      final map = book.toMap();

      expect(map['title'], 'Map Book');
      expect(map['author'], 'Map Author');
      expect(map['status'], 'wantToRead');
      expect(map['pageCount'], 250);
      expect(map['addedDate'], fixedDate.toIso8601String());
    });

    test('fromMap converts Map to Book correctly', () {
      final map = {
        'title': 'From Map',
        'author': 'From Author',
        'status': 'favorites',
        'addedDate': '2024-01-01T00:00:00.000',
        'pageCount': 400,
      };

      final book = Book.fromMap(map, '4');

      expect(book.id, '4');
      expect(book.title, 'From Map');
      expect(book.author, 'From Author');
      expect(book.status, 'favorites');
      expect(book.pageCount, 400);
      expect(book.addedDate.year, 2024);
    });

    test('fromMap handles missing fields gracefully', () {
      final map = {
        'title': 'Minimal Book',
        'author': 'Minimal Author',
        'status': 'wishlist',
        'addedDate': DateTime.now().toIso8601String(),
      };

      final book = Book.fromMap(map, '5');

      expect(book.title, 'Minimal Book');
      expect(book.author, 'Minimal Author');
      expect(book.status, 'wishlist');
      expect(book.pageCount, isNull);
    });

    test('Default status is wantToRead when missing', () {
      final map = {
        'title': 'No Status',
        'author': 'Test',
        'addedDate': DateTime.now().toIso8601String(),
      };

      final book = Book.fromMap(map, '6');
      expect(book.status, 'wantToRead');
    });
  });
}