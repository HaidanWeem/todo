import 'package:flutter/material.dart';
import 'package:todo/core/theme/login_theme.dart';

class TextFieldLogin extends StatelessWidget {
  final TextEditingController controller;
  const TextFieldLogin({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: TextInputAction.next,
      validator: _validator,
      controller: controller,
      decoration: const InputDecoration(
        helperText: 'Email format',
        labelText: 'Email',
        labelStyle: TextStyle(color: Colors.black),
        enabledBorder: LoginTheme.borderDefault,
        focusedBorder: LoginTheme.borderDefault,
        errorBorder: LoginTheme.borderError,
        focusedErrorBorder: LoginTheme.borderError,
      ),
    );
  }

  String? _validator(String? value) {
    final regExp = RegExp(r'^\S+@\S+\.\S+$');
    if (regExp.hasMatch(value ?? '')) return null;

    return 'Email is not valid';
  }
}