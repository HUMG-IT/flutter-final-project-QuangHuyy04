
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../data/book_model.dart';
import '../providers/book_provider.dart';

class EditBookScreen extends ConsumerStatefulWidget {
  final Book book;
  const EditBookScreen({super.key, required this.book});

  @override
  ConsumerState<EditBookScreen> createState() => _EditBookScreenState();
}

class _EditBookScreenState extends ConsumerState<EditBookScreen> {
  late final _titleCtrl = TextEditingController(text: widget.book.title);
  late final _authorCtrl = TextEditingController(text: widget.book.author);
  late final _pageCtrl = TextEditingController(text: widget.book.pageCount?.toString() ?? '');
  late String _status = widget.book.status;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('edit_book'.tr()),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
              final updatedBook = widget.book.copyWith(
                title: _titleCtrl.text.trim(),
                author: _authorCtrl.text.trim(),
                pageCount: int.tryParse(_pageCtrl.text),
                status: _status,
              );
              await ref.read(bookRepositoryProvider).updateBook(updatedBook);
              if (mounted) {
                context.pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('book_updated'.tr()), backgroundColor: Colors.green),
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleCtrl,
              decoration: InputDecoration(labelText: 'book_title'.tr(), border: const OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _authorCtrl,
              decoration: InputDecoration(labelText: 'author'.tr(), border: const OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _pageCtrl,
              decoration: InputDecoration(labelText: 'pages'.tr(), border: const OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            FormField<String>(
              initialValue: _status,
              builder: (FormFieldState<String> field) {
                return InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'status'.tr(),
                    border: const OutlineInputBorder(),
                    errorText: field.errorText,
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _status,
                      isExpanded: true,
                      isDense: true,
                      items: const [
                        DropdownMenuItem(value: 'wantToRead', child: Text('Muốn đọc')),
                        DropdownMenuItem(value: 'reading', child: Text('Đang đọc')),
                        DropdownMenuItem(value: 'completed', child: Text('Đã đọc xong')),
                        DropdownMenuItem(value: 'favorites', child: Text('Yêu thích')),
                        DropdownMenuItem(value: 'wishlist', child: Text('Wishlist')),
                      ],
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() => _status = newValue);
                          field.didChange(newValue);
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _authorCtrl.dispose();
    _pageCtrl.dispose();
    super.dispose();
  }
}