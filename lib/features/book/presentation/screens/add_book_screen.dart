
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../data/book_model.dart';
import '../providers/book_provider.dart';

class AddBookScreen extends ConsumerStatefulWidget {
  const AddBookScreen({super.key});

  @override
  ConsumerState<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends ConsumerState<AddBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _authorCtrl = TextEditingController();
  final _pageCtrl = TextEditingController();

  String _status = 'wantToRead';

  Future<void> _scanISBN() async {
    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('scan_isbn_web_warning'.tr())),
      );
      return;
    }

    final picker = ImagePicker();
    final photo = await picker.pickImage(source: ImageSource.camera);
    if (photo == null) return;

    final inputImage = InputImage.fromFilePath(photo.path);
    final scanner = BarcodeScanner();
    final barcodes = await scanner.processImage(inputImage);

    if (barcodes.isNotEmpty && barcodes.first.displayValue != null) {
      final isbn = barcodes.first.displayValue!;
      final url = 'https://www.googleapis.com/books/v1/volumes?q=isbn:$isbn';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['totalItems'] > 0) {
          final info = data['items'][0]['volumeInfo'];
          setState(() {
            _titleCtrl.text = info['title'] ?? '';
            _authorCtrl.text = info['authors']?.join(', ') ?? '';
            _pageCtrl.text = info['pageCount']?.toString() ?? '';
          });
        }
      }
    }
    await scanner.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('add_book'.tr()),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _titleCtrl,
                  decoration: InputDecoration(
                    labelText: 'book_title'.tr(),
                    border: const OutlineInputBorder(),
                  ),
                  validator: (v) => v?.trim().isEmpty == true ? 'required_field'.tr() : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _authorCtrl,
                  decoration: InputDecoration(
                    labelText: 'author'.tr(),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _pageCtrl,
                  decoration: InputDecoration(
                    labelText: 'pages'.tr(),
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),

                FormField<String>(
                  initialValue: _status,
                  validator: (value) => value == null ? 'required_field'.tr() : null,
                  builder: (FormFieldState<String> field) {
                    return InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'status'.tr(),
                        border: const OutlineInputBorder(),
                        errorText: field.errorText,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: field.value,
                          isDense: true,
                          isExpanded: true,
                          hint: Text('select_status'.tr()),
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

                const SizedBox(height: 24),

                if (!kIsWeb)
                  OutlinedButton.icon(
                    onPressed: _scanISBN,
                    icon: const Icon(Icons.qr_code_scanner),
                    label: Text('scan_isbn'.tr()),
                  ),

                const SizedBox(height: 32),

                ElevatedButton(
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;

                    final book = Book(
                      id: const Uuid().v4(),
                      title: _titleCtrl.text.trim(),
                      author: _authorCtrl.text.trim(),
                      status: _status,
                      addedDate: DateTime.now(),
                      pageCount: int.tryParse(_pageCtrl.text),
                    );

                    await ref.read(bookRepositoryProvider).addBook(book);

                    if (mounted) {
                      context.pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('book_added'.tr()), backgroundColor: Colors.green),
                      );
                    }
                  },
                  child: Text('save_book'.tr(), style: const TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),
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