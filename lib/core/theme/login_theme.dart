import 'package:flutter/material.dart';

abstract class LoginTheme {
  static const  borderDefault =  OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(16)),
  );
  static const borderError = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(16)),
    borderSide: BorderSide(color: Colors.red),
  );
}
