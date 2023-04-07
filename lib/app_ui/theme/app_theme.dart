import 'package:flutter/material.dart';
import 'package:jambu/app_ui/colors/app_colors.dart';

class AppTheme {
  const AppTheme();

  ThemeData get themeData {
    return ThemeData(
      useMaterial3: true,
      chipTheme: _chipTheme,
    );
  }

  ChipThemeData get _chipTheme {
    return const ChipThemeData(
      backgroundColor: AppColors.lightGrey,
      side: BorderSide.none,
      shape: StadiumBorder(),
    );
  }
}
