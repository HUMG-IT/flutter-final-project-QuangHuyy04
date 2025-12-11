
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'book_model.dart';

class BookRepository {
  final _firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!;

  CollectionReference get _collection => _firestore
      .collection('users')
      .doc(user.uid)
      .collection('books');

  Stream<List<Book>> getBooks() => _collection.snapshots().map(
        (s) => s.docs.map((d) => Book.fromMap(d.data() as Map<String, dynamic>, d.id)).toList(),
      );

  Future<void> addBook(Book book) => _collection.doc(book.id).set(book.toMap());
  Future<void> updateBook(Book book) => _collection.doc(book.id).update(book.toMap());
  Future<void> deleteBook(String id) => _collection.doc(id).delete();
}