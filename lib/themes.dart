import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: Colors.grey,
      // colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      // colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey),
    );
  }
}

extension ColorSchemeExtension on ColorScheme {
  Color get chartBarColor => Colors.blue;

  Color get chartGridColor => Colors.grey.shade500;
}
