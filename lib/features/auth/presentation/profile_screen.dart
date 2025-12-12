// lib/features/auth/presentation/profile_screen.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bookverse/core/theme_provider.dart';
import 'package:bookverse/common/widgets/password_field.dart'; // ĐÃ THÊM

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _nameCtrl = TextEditingController();
  final _currentPassCtrl = TextEditingController();
  final _newPassCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();
  final _jobCtrl = TextEditingController();

  DateTime? _birthDate;
  bool _loading = false;
  bool _changingPassword = false;

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
      _nameCtrl.text = data['displayName'] ?? user.displayName ?? '';
      _birthDate = data['birthDate'] != null ? DateTime.tryParse(data['birthDate']) : null;
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
        SnackBar(content: Text('profile_saved'.tr()), backgroundColor: Colors.green),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi lưu hồ sơ'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _changePassword() async {
    if (_newPassCtrl.text != _confirmPassCtrl.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('password_not_match'.tr()), backgroundColor: Colors.red),
      );
      return;
    }
    if (_newPassCtrl.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('password_too_short'.tr()), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _loading = true);
    try {
      final user = FirebaseAuth.instance.currentUser!;
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: _currentPassCtrl.text,
      );
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(_newPassCtrl.text);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('password_changed'.tr()), backgroundColor: Colors.green),
      );

      _currentPassCtrl.clear();
      _newPassCtrl.clear();
      _confirmPassCtrl.clear();
      setState(() => _changingPassword = false);
    } on FirebaseAuthException catch (e) {
      String msg = 'change_password_failed'.tr();
      if (e.code == 'wrong-password') msg = 'wrong_current_password'.tr();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: Colors.red),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('profile'.tr()),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () => context.setLocale(
              context.locale.languageCode == 'vi' ? const Locale('en') : const Locale('vi'),
            ),
          ),
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => ref.read(themeProvider.notifier).state =
                isDark ? ThemeMode.light : ThemeMode.dark,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Avatar + Email
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.deepPurple,
              child: Text(
                user.email![0].toUpperCase(),
                style: const TextStyle(fontSize: 60, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user.email!,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),

            // Thông tin cá nhân
            TextField(
              controller: _nameCtrl,
              decoration: InputDecoration(
                labelText: 'full_name'.tr(),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: isDark ? Colors.grey.shade800 : Colors.grey.shade50,
              ),
            ),
            const SizedBox(height: 16),

            // Ngày sinh
            TextField(
              readOnly: true,
              controller: TextEditingController(
                text: _birthDate != null
                    ? '${_birthDate!.day.toString().padLeft(2, '0')}/${_birthDate!.month.toString().padLeft(2, '0')}/${_birthDate!.year}'
                    : '',
              ),
              decoration: InputDecoration(
                labelText: 'birth_date'.tr(),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: isDark ? Colors.grey.shade800 : Colors.grey.shade50,
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
                  style: const TextStyle(fontSize: 18, color: Colors.blue, fontWeight: FontWeight.bold),
                ),
              ),
            const SizedBox(height: 16),

            // Nghề nghiệp
            TextField(
              controller: _jobCtrl,
              decoration: InputDecoration(
                labelText: 'job'.tr(),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: isDark ? Colors.grey.shade800 : Colors.grey.shade50,
              ),
            ),
            const SizedBox(height: 32),

            // Nút lưu hồ sơ
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text('save_profile'.tr(), style: const TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 24),

            // NÚT ĐỔI MẬT KHẨU
            OutlinedButton.icon(
              onPressed: () => setState(() => _changingPassword = !_changingPassword),
              icon: Icon(_changingPassword ? Icons.keyboard_arrow_up : Icons.vpn_key),
              label: Text(_changingPassword ? 'hide_change_password'.tr() : 'change_password'.tr()),
              style: OutlinedButton.styleFrom(foregroundColor: Colors.deepPurple),
            ),

            // FORM ĐỔI MẬT KHẨU – CÓ ICON MẮT SIÊU ĐẸP
            if (_changingPassword) ...[
              const SizedBox(height: 16),
              PasswordField(controller: _currentPassCtrl, labelKey: 'current_password'),
              const SizedBox(height: 16),
              PasswordField(controller: _newPassCtrl, labelKey: 'new_password'),
              const SizedBox(height: 16),
              PasswordField(controller: _confirmPassCtrl, labelKey: 'confirm_password'),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _changePassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text('update_password'.tr(), style: const TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _currentPassCtrl.dispose();
    _newPassCtrl.dispose();
    _confirmPassCtrl.dispose();
    _jobCtrl.dispose();
    super.dispose();
  }
}