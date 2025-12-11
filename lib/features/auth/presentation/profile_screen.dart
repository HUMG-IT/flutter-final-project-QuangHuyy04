
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bookverse/core/theme_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _nameCtrl = TextEditingController();
  DateTime? _birthDate;
  final _jobCtrl = TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser!;
    final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    if (doc.exists) {
      final data = doc.data()!;
      _nameCtrl.text = data['displayName'] ?? '';
      _birthDate = data['birthDate'] != null ? DateTime.parse(data['birthDate']) : null;
      _jobCtrl.text = data['job'] ?? '';
      setState(() {});
    }
  }

  Future<void> _saveProfile() async {
    setState(() => _loading = true);
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'displayName': _nameCtrl.text.trim(),
        'birthDate': _birthDate?.toIso8601String(),
        'job': _jobCtrl.text.trim(),
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('profile_saved'.tr()),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('error'.tr())),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final age = _birthDate != null
        ? DateTime.now().year -
            _birthDate!.year -
            ((DateTime.now().month < _birthDate!.month ||
                    (DateTime.now().month == _birthDate!.month && DateTime.now().day < _birthDate!.day))
                ? 1
                : 0)
        : null;

    return Scaffold(
      appBar: AppBar(
        title: Text('profile'.tr()),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              context.setLocale(
                context.locale.languageCode == 'vi' ? const Locale('en') : const Locale('vi'),
              );
            },
          ),
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () {
              ref.read(themeProvider.notifier).state =
                  Theme.of(context).brightness == Brightness.dark ? ThemeMode.light : ThemeMode.dark;
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.deepPurple,
              child: Text(
                user.email![0].toUpperCase(),
                style: const TextStyle(fontSize: 60, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            Text(user.email!, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 32),

            TextField(
              controller: _nameCtrl,
              decoration: InputDecoration(
                labelText: 'full_name'.tr(),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              readOnly: true,
              controller: TextEditingController(
                text: _birthDate != null ? DateFormat('dd/MM/yyyy').format(_birthDate!) : '',
              ),
              decoration: InputDecoration(
                labelText: 'birth_date'.tr(),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) setState(() => _birthDate = date);
                  },
                ),
              ),
            ),
            if (age != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  'age'.tr(namedArgs: {'age': age.toString()}),
                  style: const TextStyle(fontSize: 18, color: Colors.blue, fontWeight: FontWeight.w600),
                ),
              ),
            const SizedBox(height: 16),
            TextField(
              controller: _jobCtrl,
              decoration: InputDecoration(
                labelText: 'job'.tr(),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _saveProfile,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text('save_profile'.tr(), style: const TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _jobCtrl.dispose();
    super.dispose();
  }
}