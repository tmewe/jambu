import 'package:flutter/material.dart';

abstract class AppColors {
  static const Color orange = Color(0xffef7d00);
  static const Color brightOrange = Color(0xffFFD09E);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  static const Color brightGreen = Color(0xFFEFF8E6);
  static const Color mediumGreen = Color(0xFF9FD866);
  static const Color green = Color(0xFF8FD14F);

  static const Color brightBlue = Color(0xFFD9EEF9);
  static const Color mediumBlue = Color(0xFF50B1E4);
  static const Color blue = Color(0xFF299EDE);

  static const Color seasaltGrey = Color(0xFFF8F9FA);
  static const Color platinumGrey = Color(0xFFDEE2E6);
  static const Color frenchGrey = Color(0xFFADB5BD);
  static const Color slateGrey = Color(0xFF6C757D);
  static const Color outerSpaceGrey = Color(0xFF495057);
  static const Color jambitGrey = Color(0xFF3c3c3b);

  static const Color onBackground = Color(0xFF1A1A1A);

  static Color checkmarkColor({required bool isColorBlind}) {
    return isColorBlind ? AppColors.blue : AppColors.green;
  }

  static Color attendingColor({required bool isColorBlind}) {
    return isColorBlind ? AppColors.mediumBlue : AppColors.mediumGreen;
  }

  static Color bestDayColor({required bool isColorBlind}) {
    return isColorBlind ? AppColors.brightBlue : AppColors.brightGreen;
  }
}
