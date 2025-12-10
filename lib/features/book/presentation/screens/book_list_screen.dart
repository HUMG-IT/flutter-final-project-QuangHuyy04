// lib/features/book/presentation/screens/book_list_screen.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/book_provider.dart';

class BookListScreen extends ConsumerWidget {
  const BookListScreen({super.key});

  String _statusText(String status) => switch (status) {
        'reading' => 'Đang đọc',
        'completed' => 'Đã đọc xong',
        'wantToRead' => 'Muốn đọc',
        'favorites' => 'Yêu thích',
        _ => 'Wishlist',
      };

  Color _statusColor(String status) => switch (status) {
        'reading' => Colors.blue,
        'completed' => Colors.green,
        'wantToRead' => Colors.orange,
        'favorites' => Colors.pink,
        _ => Colors.grey,
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booksAsync = ref.watch(booksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('BookVerse', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.bar_chart), onPressed: () => context.push('/statistics')),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              context.go('/');
            },
          ),
        ],
      ),
      body: booksAsync.when(
        data: (books) => books.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.menu_book, size: 80, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('Chưa có sách nào', style: TextStyle(fontSize: 20)),
                    Text('Nhấn nút + để thêm sách đầu tiên nhé!'),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: books.length,
                itemBuilder: (_, i) {
                  final book = books[i];
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: const CircleAvatar(
                        backgroundColor: Colors.deepPurple,
                        child: Icon(Icons.book, color: Colors.white, size: 32),
                      ),
                      title: Text(book.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(book.author, style: const TextStyle(fontSize: 14)),
                          const SizedBox(height: 6),
                          Chip(
                            label: Text(_statusText(book.status), style: const TextStyle(fontSize: 11)),
                            backgroundColor: _statusColor(book.status).withAlpha(38),
                            labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => ref.read(bookRepositoryProvider).deleteBook(book.id),
                      ),
                    ),
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Lỗi tải dữ liệu')),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => context.push('/add-book'),
      ),
    );
  }
}