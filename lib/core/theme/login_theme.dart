import 'package:flutter/material.dart';

abstract class LoginTheme {
  static const  borderDefault =  OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.zero),
  );
  static const borderError = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.zero),
    borderSide: BorderSide(color: Colors.red),
  );
}
