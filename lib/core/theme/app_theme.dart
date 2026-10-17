import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primaryDark,
          onPrimary: AppColors.buttonPrimaryText,
          primaryContainer: AppColors.primaryContainer,
          onPrimaryContainer: AppColors.secondary,
          secondary: AppColors.secondary,
          onSecondary: Colors.white,
          secondaryContainer: AppColors.secondaryLight,
          onSecondaryContainer: AppColors.secondary,
          surface: AppColors.surface,
          onSurface: AppColors.textPrimary,
          surfaceContainerHighest: AppColors.surfaceVariant,
          error: AppColors.error,
          onError: Colors.white,
          outline: AppColors.border,
        ),
        scaffoldBackgroundColor: AppColors.background,
        textTheme: _textTheme(
          heading: AppColors.heading,
          body: AppColors.body,
          caption: AppColors.caption,
        ),
        appBarTheme: AppBarTheme(
          elevation: 0,
          scrolledUnderElevation: 0.5,
          centerTitle: false,
          backgroundColor: AppColors.appBarBackground,
          foregroundColor: AppColors.appBarIcon,
          surfaceTintColor: Colors.transparent,
          titleTextStyle: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.appBarTitle,
          ),
          iconTheme: const IconThemeData(color: AppColors.appBarIcon),
        ),
        cardTheme: CardThemeData(
          color: AppColors.card,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: EdgeInsets.zero,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.buttonPrimary,
            foregroundColor: AppColors.buttonPrimaryText,
            disabledBackgroundColor: AppColors.buttonDisabled,
            disabledForegroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.buttonSecondaryText,
            backgroundColor: AppColors.buttonSecondaryBg,
            side: const BorderSide(color: AppColors.buttonSecondaryBorder),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.secondary,
            textStyle: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.searchBackground,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide:
                const BorderSide(color: AppColors.primaryDark, width: 1.5),
          ),
          hintStyle: GoogleFonts.plusJakartaSans(
            color: AppColors.searchHint,
            fontSize: 14,
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.surfaceVariant,
          selectedColor: AppColors.primaryContainer,
          labelStyle: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            color: AppColors.textPrimary,
          ),
          secondaryLabelStyle: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            color: AppColors.secondary,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          side: const BorderSide(color: AppColors.border),
          padding: const EdgeInsets.symmetric(horizontal: 8),
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.divider,
          thickness: 1,
          space: 1,
        ),
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.accent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.navBackground,
          selectedItemColor: AppColors.navSelectedIcon,
          unselectedItemColor: AppColors.navUnselected,
        ),
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primaryDark,
          onPrimary: AppColors.buttonPrimaryText,
          primaryContainer: AppColors.secondary,
          onPrimaryContainer: AppColors.primaryLight,
          secondary: AppColors.primary,
          onSecondary: AppColors.darkBackground,
          surface: AppColors.darkSurface,
          onSurface: AppColors.darkTextPrimary,
          surfaceContainerHighest: AppColors.darkSurfaceVariant,
          error: AppColors.error,
          onError: Colors.white,
          outline: AppColors.darkBorder,
        ),
        scaffoldBackgroundColor: AppColors.darkBackground,
        textTheme: _textTheme(
          heading: AppColors.darkTextPrimary,
          body: AppColors.darkTextSecondary,
          caption: AppColors.darkTextHint,
        ),
        appBarTheme: AppBarTheme(
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          backgroundColor: AppColors.darkBackground,
          foregroundColor: AppColors.darkTextPrimary,
          surfaceTintColor: Colors.transparent,
          titleTextStyle: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.darkTextPrimary,
          ),
          iconTheme: const IconThemeData(color: AppColors.darkTextSecondary),
        ),
        cardTheme: CardThemeData(
          color: AppColors.darkCard,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: EdgeInsets.zero,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.buttonPrimary,
            foregroundColor: AppColors.buttonPrimaryText,
            disabledBackgroundColor: AppColors.buttonDisabled,
            disabledForegroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primaryDark),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.darkDivider,
          thickness: 1,
          space: 1,
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: AppColors.darkCard,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.darkSurfaceVariant,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          hintStyle: GoogleFonts.plusJakartaSans(
            color: AppColors.darkTextHint,
            fontSize: 14,
          ),
        ),
      );

  static TextTheme _textTheme({
    required Color heading,
    required Color body,
    required Color caption,
  }) {
    final base = GoogleFonts.plusJakartaSansTextTheme();
    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(color: heading),
      displayMedium: base.displayMedium?.copyWith(color: heading),
      displaySmall: base.displaySmall?.copyWith(color: heading),
      headlineLarge: base.headlineLarge?.copyWith(color: heading),
      headlineMedium: base.headlineMedium?.copyWith(color: heading),
      headlineSmall: base.headlineSmall?.copyWith(color: heading),
      titleLarge: base.titleLarge?.copyWith(
        color: heading,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: base.titleMedium?.copyWith(color: heading),
      titleSmall: base.titleSmall?.copyWith(color: heading),
      bodyLarge: base.bodyLarge?.copyWith(color: body),
      bodyMedium: base.bodyMedium?.copyWith(color: body),
      bodySmall: base.bodySmall?.copyWith(color: caption),
      labelLarge: base.labelLarge?.copyWith(color: body),
      labelMedium: base.labelMedium?.copyWith(color: caption),
      labelSmall: base.labelSmall?.copyWith(color: caption),
    );
  }
}
