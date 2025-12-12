// lib/common/widgets/password_field.dart

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String labelKey;
  final String? Function(String?)? validator;

  const PasswordField({
    super.key,
    required this.controller,
    required this.labelKey,
    this.validator,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      validator: widget.validator,
      decoration: InputDecoration(
        labelText: widget.labelKey.tr(),
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: isDark ? Colors.white70 : Colors.grey.shade700,
          ),
          onPressed: () => setState(() => _obscureText = !_obscureText),
        ),
        filled: true,
        fillColor: isDark ? Colors.grey.shade800 : Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}