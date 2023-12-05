
import 'package:flutter/material.dart';
import 'package:todo/core/theme/login_theme.dart';

class TextFieldPassword extends StatefulWidget {
  final TextEditingController controller;

  const TextFieldPassword({required this.controller, super.key});

  @override
  State<TextFieldPassword> createState() => _TextFieldPasswordState();
}

class _TextFieldPasswordState extends State<TextFieldPassword> {
  bool _isCharachtersHidden = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: _validator,
      controller: widget.controller,
      obscureText: _isCharachtersHidden,
      decoration: InputDecoration(
        helperText: 'Password must be 8 or more characters',
        labelText: 'Password',
        suffixIcon: IconButton(
          icon: Icon(
            _isCharachtersHidden ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: _toggleObscureText,
          color: !_isCharachtersHidden ? Colors.red : Colors.grey,
        ),
        enabledBorder: LoginTheme.borderDefault,
        focusedBorder: LoginTheme.borderDefault,
        errorBorder: LoginTheme.borderError,
        focusedErrorBorder: LoginTheme.borderError,
      ),
      style: const TextStyle(color: Colors.black),
    );
  }

  void _toggleObscureText() =>
      setState(() => _isCharachtersHidden = !_isCharachtersHidden);

  String? _validator(String? value) {
    if (value == null || value.length < 8) return 'Invalid password';

    return null;
  }
}