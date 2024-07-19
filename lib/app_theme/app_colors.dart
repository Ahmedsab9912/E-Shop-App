import 'package:flutter/material.dart';
import 'app_theme.dart';

class AppTheme {
  // Define the global theme
  static ThemeData get themeData {
    return ThemeData(
      primaryColor: AppColors.appBarColor,
      hintColor: AppColors.accentColor,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        color: AppColors.appBarColor,
        titleTextStyle: TextStyle(
          color: AppColors.appBarTextColor,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(
          color: AppColors.appBarTextColor,
        ),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: AppColors.buttonColor,
        textTheme: ButtonTextTheme.primary,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.primaryTextColor),
        bodyMedium: TextStyle(color: AppColors.secondaryTextColor),
      ),
      dividerColor: AppColors.dividerColor,
    );
  }
}