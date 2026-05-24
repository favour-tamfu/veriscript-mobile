import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_component_themes.dart';
import 'app_text_styles.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.vsPrimary,
          brightness: Brightness.light,
        ).copyWith(
          primary: AppColors.vsPrimary,
          secondary: AppColors.vsAccent,
          tertiary: AppColors.vsCta,
          surface: AppColors.vsSurface,
          error: AppColors.vsError,
        ),
        fontFamily: GoogleFonts.inter().fontFamily,
        textTheme: AppTextStyles.textTheme,
        elevatedButtonTheme: AppComponentThemes.elevatedButton,
        outlinedButtonTheme: AppComponentThemes.outlinedButton,
        cardTheme: AppComponentThemes.card,
        appBarTheme: AppComponentThemes.appBar,
        navigationBarTheme: AppComponentThemes.navigationBar,
        inputDecorationTheme: AppComponentThemes.inputDecoration,
        scaffoldBackgroundColor: AppColors.vsBackground,
      );
}
