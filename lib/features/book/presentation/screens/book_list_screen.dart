// lib/features/book/presentation/screens/book_list_screen.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bookverse/core/theme_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;
import '../providers/book_provider.dart';

class BookListScreen extends ConsumerStatefulWidget {
  const BookListScreen({super.key});

  @override
  ConsumerState<BookListScreen> createState() => _BookListScreenState();
}

class _BookListScreenState extends ConsumerState<BookListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<String> _tabs = [
    'all_books',        // Tất cả
    'reading',          // Đang đọc
    'completed',        // Đã đọc xong
    'wantToRead',       // Muốn đọc
    'favorites',        // Yêu thích
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  String _statusText(String status) => switch (status) {
        'reading' => 'reading'.tr(),
        'completed' => 'completed'.tr(),
        'wantToRead' => 'want_to_read'.tr(),
        'favorites' => 'favorites'.tr(),
        _ => 'wishlist'.tr(),
      };

  Color _cardColor(String status, Brightness brightness) => switch (status) {
        'reading' => brightness == Brightness.dark ? Colors.blue.shade900 : Colors.blue.shade50,
        'completed' => brightness == Brightness.dark ? Colors.green.shade900 : Colors.green.shade50,
        'wantToRead' => brightness == Brightness.dark ? Colors.orange.shade900 : Colors.orange.shade50,
        'favorites' => brightness == Brightness.dark ? Colors.pink.shade900 : Colors.pink.shade50,
        _ => brightness == Brightness.dark ? Colors.purple.shade900 : Colors.purple.shade50,
      };

  Color _chipColor(String status) => switch (status) {
        'reading' => Colors.blue,
        'completed' => Colors.green,
        'wantToRead' => Colors.orange,
        'favorites' => Colors.pink,
        _ => Colors.purple,
      };

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final booksAsync = ref.watch(booksProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('app_name'.tr(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
        centerTitle: true,
        backgroundColor: isDark ? Colors.grey.shade900 : Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 4,
        actions: [
          IconButton(icon: const Icon(Icons.bar_chart), onPressed: () => context.push('/statistics')),
          IconButton(icon: const Icon(Icons.person), onPressed: () => context.push('/profile')),
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () => context.setLocale(context.locale.languageCode == 'vi' ? const Locale('en') : const Locale('vi')),
          ),
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => ref.read(themeProvider.notifier).state = isDark ? ThemeMode.light : ThemeMode.dark,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (kIsWeb) {
                web.window.location.reload();
              } else {
                context.go('/');
              }
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: _tabs.map((key) => Tab(text: key.tr())).toList(),
        ),
      ),
      body: Column(
        children: [
          // THANH TÌM KIẾM
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'search_books'.tr(),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(icon: const Icon(Icons.clear), onPressed: _searchController.clear)
                    : null,
                filled: true,
                fillColor: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
              ),
            ),
          ),

          // NỘI DUNG THEO TAB
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _tabs.map((statusKey) {
                final String filterStatus = statusKey == 'all_books' ? '' : statusKey;

                return booksAsync.when(
                  data: (books) {
                    var filtered = books.where((book) {
                      final matchesSearch = book.title.toLowerCase().contains(_searchQuery) ||
                          book.author.toLowerCase().contains(_searchQuery);
                      final matchesTab = filterStatus.isEmpty || book.status == filterStatus;
                      return matchesSearch && matchesTab;
                    }).toList();

                    if (filtered.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.menu_book, size: 80, color: Colors.grey.shade400),
                            const SizedBox(height: 16),
                            Text(_searchQuery.isEmpty ? 'no_books'.tr() : 'no_results_found'.tr(), style: const TextStyle(fontSize: 18)),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: filtered.length,
                      itemBuilder: (context, i) {
                        final book = filtered[i];
                        return Card(
                          elevation: 8,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          color: _cardColor(book.status, brightness),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(20),
                            leading: Container(
                              width: 70,
                              height: 90,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: isDark
                                    ? [Colors.deepPurple.shade900, Colors.deepPurple.shade700]
                                    : [Colors.deepPurple.shade200, Colors.deepPurple.shade100]),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, offset: const Offset(0, 6))],
                              ),
                              child: const Icon(Icons.book, size: 40, color: Colors.white),
                            ),
                            title: Text(book.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: isDark ? Colors.white : Colors.black87)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(book.author, style: TextStyle(color: isDark ? Colors.white70 : Colors.black54)),
                                const SizedBox(height: 12),
                                Chip(
                                  label: Text(_statusText(book.status), style: const TextStyle(color: Colors.white, fontSize: 12)),
                                  backgroundColor: _chipColor(book.status),
                                ),
                                if (book.pageCount != null)
                                  Text('pages_display'.tr(namedArgs: {'count': book.pageCount.toString()})),
                              ],
                            ),
                            onTap: () => context.push('/edit-book', extra: book),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: isDark ? Colors.red.shade300 : Colors.redAccent),
                              onPressed: () async {
                                await ref.read(bookRepositoryProvider).deleteBook(book.id);
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('book_deleted'.tr()), backgroundColor: Colors.red),
                                  );
                                }
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (_, __) => Center(child: Text('error_loading'.tr())),
                );
              }).toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/add-book'),
        backgroundColor: Colors.deepPurple,
        icon: const Icon(Icons.add),
        label: Text('add_book'.tr()),
      ),
    );
  }
}