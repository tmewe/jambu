import 'package:app_ui/src/colors/app_colors.dart';
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
    return const ChipThemeData(
      backgroundColor: AppColors.lightGrey,
      side: BorderSide.none,
      shape: StadiumBorder(),
    );
  }
}
