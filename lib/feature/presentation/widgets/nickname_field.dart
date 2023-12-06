import 'package:flutter/material.dart';
import 'package:todo/core/theme/login_theme.dart';

class NicknameField extends StatelessWidget {
  final TextEditingController controller;
  const NicknameField({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: TextInputAction.next,
      validator: _validator,
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        helperText: 'Nickname format',
        labelText: 'Nickname',
        labelStyle: const TextStyle(color: Colors.black),
        enabledBorder: LoginTheme.borderDefault,
        focusedBorder: LoginTheme.borderDefault,
        errorBorder: LoginTheme.borderError,
        focusedErrorBorder: LoginTheme.borderError,
      ),
    );
  }

  String? _validator(String? value) {
    if (value == null || value.isEmpty) return 'Nickname can' 't be empty';

    return null;
  }
}