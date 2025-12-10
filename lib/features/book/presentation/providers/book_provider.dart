import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/book_repository.dart';
import '../../data/book_model.dart';

final bookRepositoryProvider = Provider((ref) => BookRepository());
final booksProvider = StreamProvider<List<Book>>((ref) {
  return ref.watch(bookRepositoryProvider).getBooks();
});