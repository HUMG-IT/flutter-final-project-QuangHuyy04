// lib/features/auth/presentation/login_screen.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bookverse/core/theme_provider.dart';
import 'package:bookverse/common/widgets/password_field.dart'; // ĐÃ THÊM

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false;

  Future<void> _login() async {
    setState(() => _loading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text,
      );
      if (mounted) context.go('/home');
    } on FirebaseAuthException catch (e) {
      String msg = 'Đăng nhập thất bại';
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        msg = 'Email hoặc mật khẩu không đúng';
      } else if (e.code == 'too-many-requests') {
        msg = 'Quá nhiều lần thử, vui lòng đợi 1 phút';
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('BookVerse'),
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
            onPressed: () {
              ref.read(themeProvider.notifier).state =
                  isDark ? ThemeMode.light : ThemeMode.dark;
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.book_rounded, size: 100, color: Colors.deepPurple),
              const Text('BookVerse', style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
              const SizedBox(height: 50),

              // Email
              TextField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'email'.tr(),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.email),
                  filled: true,
                  fillColor: isDark ? Colors.grey.shade800 : Colors.grey.shade50,
                ),
              ),
              const SizedBox(height: 16),

              // Mật khẩu – CÓ ICON MẮT ĐẸP
              PasswordField(
                controller: _passCtrl,
                labelKey: 'password',
                validator: (value) {
                  if (value == null || value.isEmpty) return 'please_enter_password'.tr();
                  if (value.length < 6) return 'password_too_short'.tr();
                  return null;
                },
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _loading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    backgroundColor: Colors.deepPurple,
                  ),
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text('login'.tr(), style: const TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),

              TextButton(
                onPressed: () => context.push('/register'),
                child: Text('no_account'.tr(), style: const TextStyle(color: Colors.deepPurple)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}