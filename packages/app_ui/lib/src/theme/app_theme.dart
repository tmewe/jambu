import 'package:app_ui/src/colors/app_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme();

  ThemeData get themeData {
    return ThemeData(
      useMaterial3: true,
      primaryColor: AppColors.orange,
      canvasColor: _backgroundColor,
      scaffoldBackgroundColor: _backgroundColor,
      filledButtonTheme: _filledButtonTheme,
      textButtonTheme: _textButtonTheme,
      inputDecorationTheme: _inputDecorationTheme,
      textSelectionTheme: _textSelectionThemeData,
      chipTheme: _chipTheme,
      progressIndicatorTheme: _progressIndicatorTheme,
      cardTheme: _cardTheme,
      popupMenuTheme: _popupMenuThemeData,
      dialogTheme: _dialogTheme,
      menuTheme: _menuTheme,
      iconTheme: _iconThemeData,
    );
  }

  Color get _backgroundColor => AppColors.white;

  FilledButtonThemeData get _filledButtonTheme {
    return FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.orange,
        foregroundColor: AppColors.white,
      ),
    );
  }

  TextButtonThemeData get _textButtonTheme {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.outerSpaceGrey,
      ),
    );
  }

  ChipThemeData get _chipTheme {
    return ChipThemeData(
      backgroundColor: AppColors.platinumGrey,
      side: BorderSide.none,
      shape: const StadiumBorder(),
      selectedColor: AppColors.orange.withOpacity(0.6),
    );
  }

  ProgressIndicatorThemeData get _progressIndicatorTheme {
    return const ProgressIndicatorThemeData(
      color: AppColors.outerSpaceGrey,
    );
  }

  CardTheme get _cardTheme {
    return const CardTheme(
      color: AppColors.seasaltGrey,
    );
  }

  InputDecorationTheme get _inputDecorationTheme {
    return const InputDecorationTheme(
      iconColor: AppColors.outerSpaceGrey,
      fillColor: AppColors.platinumGrey,
    );
  }

  TextSelectionThemeData get _textSelectionThemeData {
    return const TextSelectionThemeData(
      cursorColor: AppColors.outerSpaceGrey,
      selectionColor: AppColors.seasaltGrey,
    );
  }

  PopupMenuThemeData get _popupMenuThemeData {
    return const PopupMenuThemeData(
      color: AppColors.seasaltGrey,
      position: PopupMenuPosition.over,
      surfaceTintColor: AppColors.seasaltGrey,
    );
  }

  DialogTheme get _dialogTheme {
    return const DialogTheme(
      surfaceTintColor: AppColors.seasaltGrey,
    );
  }

  MenuThemeData get _menuTheme {
    return const MenuThemeData(
      style: MenuStyle(
        surfaceTintColor: MaterialStatePropertyAll(AppColors.seasaltGrey),
      ),
    );
  }

  IconThemeData get _iconThemeData {
    return const IconThemeData(color: AppColors.outerSpaceGrey);
  }
}
