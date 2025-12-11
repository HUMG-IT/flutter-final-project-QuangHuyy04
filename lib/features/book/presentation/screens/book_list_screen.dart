
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bookverse/core/theme_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;
import '../../data/book_model.dart';
import '../providers/book_provider.dart';

class BookListScreen extends ConsumerStatefulWidget {
  const BookListScreen({super.key});

  @override
  ConsumerState<BookListScreen> createState() => _BookListScreenState();
}

class _BookListScreenState extends ConsumerState<BookListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
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
        'wishlist' => brightness == Brightness.dark ? Colors.purple.shade900 : Colors.purple.shade50,
        _ => brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade100,
      };

  Color _chipColor(String status) => switch (status) {
        'reading' => Colors.blue,
        'completed' => Colors.green,
        'wantToRead' => Colors.orange,
        'favorites' => Colors.pink,
        'wishlist' => Colors.purple,
        _ => Colors.grey,
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
            onPressed: () => context.setLocale(
              context.locale.languageCode == 'vi' ? const Locale('en') : const Locale('vi'),
            ),
          ),
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              ref.read(themeProvider.notifier).state = isDark ? ThemeMode.light : ThemeMode.dark;
            },
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
      ),
      body: Column(
        children: [
          // THANH TÌM KIẾM SIÊU ĐẸP + GỢI Ý TỰ ĐỘNG + SONG NGỮ HOÀN HẢO
          Padding(
            padding: const EdgeInsets.all(16),
            child: Autocomplete<Book>(
              optionsBuilder: (textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<Book>.empty();
                }
                final query = textEditingValue.text.toLowerCase();
                return booksAsync.valueOrNull?.where((book) {
                      return book.title.toLowerCase().contains(query) ||
                             book.author.toLowerCase().contains(query);
                    }) ??
                    [];
              },
              displayStringForOption: (book) => '${book.title} - ${book.author}',
              fieldViewBuilder: (context, controller, focusNode, onSubmitted) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    hintText: 'search_books'.tr(),
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: controller.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              controller.clear();
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                );
              },
              optionsViewBuilder: (context, onSelected, options) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 8,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: MediaQuery.of(context).size.width - 32,
                      constraints: const BoxConstraints(maxHeight: 300),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey.shade900 : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: options.length,
                        itemBuilder: (context, i) {
                          final book = options.elementAt(i);
                          return ListTile(
                            leading: Icon(Icons.book, color: _chipColor(book.status)),
                            title: Text(
                              book.title,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                            subtitle: Text(
                              book.author,
                              style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
                            ),
                            trailing: Chip(
                              label: Text(_statusText(book.status), style: const TextStyle(fontSize: 11, color: Colors.white)),
                              backgroundColor: _chipColor(book.status),
                            ),
                            onTap: () => onSelected(book),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
              onSelected: (book) {
                _searchController.text = book.title;
                setState(() {
                  _searchQuery = book.title.toLowerCase();
                });
              },
            ),
          ),

          // DANH SÁCH SÁCH
          Expanded(
            child: booksAsync.when(
              data: (books) {
                final filteredBooks = books.where((book) {
                  return book.title.toLowerCase().contains(_searchQuery) ||
                         book.author.toLowerCase().contains(_searchQuery);
                }).toList();

                if (filteredBooks.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _searchQuery.isEmpty ? Icons.menu_book_rounded : Icons.search_off,
                          size: 80,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isEmpty ? 'no_books'.tr() : 'no_results_found'.tr(),
                          style: TextStyle(fontSize: 20, color: isDark ? Colors.white70 : Colors.black87),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: filteredBooks.length,
                  itemBuilder: (context, index) {
                    final book = filteredBooks[index];
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
                            gradient: LinearGradient(
                              colors: isDark
                                  ? [Colors.deepPurple.shade900, Colors.deepPurple.shade700]
                                  : [Colors.deepPurple.shade200, Colors.deepPurple.shade100],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(230),
                                blurRadius: 10,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.book, size: 40, color: Colors.white),
                        ),
                        title: Text(
                          book.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              book.author,
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: isDark ? Colors.white70 : Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              children: [
                                Chip(
                                  label: Text(
                                    _statusText(book.status),
                                    style: const TextStyle(color: Colors.white, fontSize: 12),
                                  ),
                                  backgroundColor: _chipColor(book.status),
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                ),
                                if (book.pageCount != null)
                                  Chip(
                                    label: Text(
                                      'pages_display'.tr(namedArgs: {'count': book.pageCount.toString()}),
                                      style: TextStyle(color: isDark ? Colors.white70 : Colors.black87, fontSize: 11),
                                    ),
                                    backgroundColor: isDark ? Colors.white24 : Colors.black12,
                                  ),
                              ],
                            ),
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
              error: (_, __) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.cloud_off, size: 80, color: Colors.red.shade400),
                    const SizedBox(height: 20),
                    Text('error_loading'.tr()),
                    ElevatedButton.icon(
                      onPressed: () => ref.refresh(booksProvider),
                      icon: const Icon(Icons.refresh),
                      label: Text('try_again'.tr()),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/add-book'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: Text('add_book'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}