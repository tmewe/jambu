import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme();

  ThemeData get themeData {
    return ThemeData(
      useMaterial3: true,
      chipTheme: _chipTheme,
    );
  }

  ChipThemeData get _chipTheme {
    return ChipThemeData(
      backgroundColor: Colors.grey.shade300,
      side: BorderSide.none,
      shape: const StadiumBorder(),
    );
  }
}
