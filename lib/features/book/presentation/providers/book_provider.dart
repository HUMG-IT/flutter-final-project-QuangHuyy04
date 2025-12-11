
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/book_repository.dart';
import '../../data/book_model.dart';

final bookRepositoryProvider = Provider<BookRepository>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) throw StateError('User not authenticated');
  return BookRepository();
});

final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

// FIX: Dùng ref.watch thay vì ref.listen
final booksProvider = StreamProvider.autoDispose<List<Book>>((ref) {
  final user = ref.watch(authStateProvider).value;

  if (user == null) {
    return Stream.value([]);
  }

  final repository = ref.watch(bookRepositoryProvider);
  return repository.getBooks();
});