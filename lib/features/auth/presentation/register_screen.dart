
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bookverse/core/theme_provider.dart'; 


class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});
  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _loading = false;

  Future<void> _register() async {
    if (_passCtrl.text != _confirmCtrl.text) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('password_not_match'.tr())));
      return;
    }
    if (_passCtrl.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('password_too_short'.tr())));
      return;
    }

    setState(() => _loading = true);
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('register_success'.tr()), backgroundColor: Colors.green),
      );
      if (mounted) context.go('/');
    } on FirebaseAuthException catch (e) {
      String msg = 'register_failed'.tr();
      if (e.code == 'email-already-in-use') msg = 'email_in_use'.tr();
      else if (e.code == 'weak-password') msg = 'weak_password'.tr();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('register'.tr()),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () => context.setLocale(
              context.locale.languageCode == 'vi' ? const Locale('en') : const Locale('vi'),
            ),
          ),
          IconButton(
            icon: Icon(Theme.of(context).brightness == Brightness.dark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              final current = Theme.of(context).brightness;
              ref.read(themeProvider.notifier).state = 
                  current == Brightness.dark ? ThemeMode.light : ThemeMode.dark;
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(controller: _emailCtrl, decoration: InputDecoration(labelText: 'email'.tr())),
            const SizedBox(height: 16),
            TextField(controller: _passCtrl, obscureText: true, decoration: InputDecoration(labelText: 'password'.tr())),
            const SizedBox(height: 16),
            TextField(controller: _confirmCtrl, obscureText: true, decoration: InputDecoration(labelText: 'confirm_password'.tr())),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: _loading ? null : _register, child: Text('register'.tr())),
          ],
        ),
      ),
    );
  }
}