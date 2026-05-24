import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppComponentThemes {
  AppComponentThemes._();

  static ElevatedButtonThemeData get elevatedButton {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.vsCta,
        foregroundColor: AppColors.vsDark,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static OutlinedButtonThemeData get outlinedButton {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.vsAccent,
        side: const BorderSide(color: AppColors.vsAccent, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  static CardThemeData get card {
    return CardThemeData(
      color: AppColors.vsSurface,
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  static AppBarTheme get appBar {
    return const AppBarTheme(
      backgroundColor: AppColors.vsPrimary,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
    );
  }

  static NavigationBarThemeData get navigationBar {
    return NavigationBarThemeData(
      indicatorColor: AppColors.vsAccent.withOpacity(0.2),
      backgroundColor: AppColors.vsSurface,
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final color = states.contains(WidgetState.selected)
            ? AppColors.vsAccent
            : AppColors.vsGray;
        return IconThemeData(color: color);
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        return GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: states.contains(WidgetState.selected)
              ? AppColors.vsAccent
              : AppColors.vsGray,
        );
      }),
    );
  }

  static InputDecorationTheme get inputDecoration {
    return InputDecorationTheme(
      filled: true,
      fillColor: AppColors.vsBackground,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.vsGray),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.vsAccent, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}
