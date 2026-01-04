import 'package:flutter/material.dart';

class AppTheme {
  // ===========================================================================
  // 1. COLORS
  // ===========================================================================

  // ---------------------------------------------------------------------------
  // A. Light Theme Palette
  // ---------------------------------------------------------------------------
  static const Color _lightPrimary = Color(0xFF2196F3);
  static const Color _lightPrimaryVariant = Color(0xFF1976D2);
  static const Color _lightSecondary = Color(0xFF03DAC6);
  static const Color _lightSecondaryVariant = Color(0xFF018786);
  static const Color _lightBackground = Color(0xFFFAFAFA);
  static const Color _lightSurface = Color(0xFFFFFFFF);
  static const Color _lightError = Color(0xFFB00020);

  static const Color _lightOnPrimary = Color(0xFFFFFFFF);
  static const Color _lightOnSecondary = Color(0xFF000000);
  static const Color _lightOnBackground = Color(0xFF000000);
  static const Color _lightOnSurface = Color(0xFF000000);
  static const Color _lightOnError = Color(0xFFFFFFFF);

  // ---------------------------------------------------------------------------
  // B. Dark Theme Palette (Vibrant Indigo & Rich Slate)
  // ---------------------------------------------------------------------------
  // Backgrounds
  static const Color _darkBackground = Color(0xFF2B2F33); // Rich Slate 900
  static const Color _darkSurface = Color.fromARGB(
    255,
    45,
    43,
    48,
  ); // Slate 800
  static const Color _darkBottomNav = Color.fromARGB(255, 34, 34, 34);

  // Accents
  static const Color _darkPrimary = Color(0xFFFFFFFF); // Vibrant Indigo 500
  static const Color _darkPrimaryContainer = Color(0xFF312E81); // Indigo 900
  static const Color _darkSecondary = Color(0xFF6366F1); // Matches Primary
  static const Color _darkError = Color(0xFFEF4444);

  // Text & Icons
  static const Color _darkOnPrimary = Color(
    0xFF2B2F33,
  ); // Dark text on White Primary
  static const Color _darkOnPrimaryContainer = Color(0xFFE0E7FF); // Indigo 100
  static const Color _darkOnSecondary = Color(0xFF2B2F33);
  static const Color _darkOnSurface = Color(0xFFF5F5F5);
  // Slate 100 (Main Text)
  static const Color _darkSecondaryText = Color(
    0xFF94A3B8,
  ); // Slate 400 (Subtext/Icons)
  static const Color _darkOnError = Color(0xFF000000);

  // ---------------------------------------------------------------------------
  // C. Semantic / Custom Colors
  // ---------------------------------------------------------------------------
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFF9800);
  static const Color infoColor = Color(0xFF2196F3);
  static const Color dangerColor = Color(0xFFF44336);

  static const Map<String, Color> customColors = {
    'success': successColor,
    'warning': warningColor,
    'info': infoColor,
    'danger': dangerColor,
  };

  // ===========================================================================
  // 2. TYPOGRAPHY
  // ===========================================================================

  static const TextStyle headingLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
  );

  static const TextStyle headingMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.25,
  );

  static const TextStyle headingSmall = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.15,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.25,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.4,
  );

  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  // ===========================================================================
  // 3. THEME CONFIGURATIONS
  // ===========================================================================

  // ---------------------------------------------------------------------------
  // A. Light Theme
  // ---------------------------------------------------------------------------
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    // Color Scheme
    colorScheme: const ColorScheme.light(
      primary: _lightPrimary,
      primaryContainer: _lightPrimaryVariant,
      secondary: _lightSecondary,
      secondaryContainer: _lightSecondaryVariant,
      background: _lightBackground,
      surface: _lightSurface,
      error: _lightError,
      onPrimary: _lightOnPrimary,
      onSecondary: _lightOnSecondary,
      onBackground: _lightOnBackground,
      onSurface: _lightOnSurface,
      onError: _lightOnError,
    ),

    // Icon Theme
    iconTheme: const IconThemeData(color: Color(0xFF64748B)), // Slate 500
    // Component Themes
    appBarTheme: const AppBarTheme(
      backgroundColor: _lightPrimary,
      foregroundColor: _lightOnPrimary,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: _lightOnPrimary,
      ),
    ),

    cardTheme: CardThemeData(
      color: _lightSurface,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _lightPrimary,
        foregroundColor: _lightOnPrimary,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: _lightPrimary,
        side: const BorderSide(color: _lightPrimary, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: _lightPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _lightSurface,
      prefixIconColor: const Color(0xFF64748B), // Slate 500
      suffixIconColor: const Color(0xFF64748B),
      // Default Border (Slate 300)
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
      ),
      // Focused Border (Primary)
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: _lightPrimary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: _lightError, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: _lightSurface,
      selectedItemColor: _lightPrimary,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
  );

  // ---------------------------------------------------------------------------
  // B. Dark Theme
  // ---------------------------------------------------------------------------
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    // Color Scheme
    colorScheme: const ColorScheme.dark(
      primary: _darkPrimary,
      primaryContainer: _darkPrimaryContainer,
      secondary: _darkSecondary, // Matches Primary for consistency
      surface: _darkSurface,
      error: _darkError,
      onPrimary: _darkOnPrimary,
      onPrimaryContainer: _darkOnPrimaryContainer,
      onSecondary: _darkOnSecondary,
      onSurface: _darkOnSurface,
      background: Color.fromARGB(255, 38, 38, 40),
      onBackground: _darkOnSurface, // Use same text contrast as surface
      onError: _darkOnError,
      brightness: Brightness.dark,
    ),

    // Typography
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: _darkOnSurface),
      bodyMedium: TextStyle(color: _darkOnSurface), // Main text
      bodySmall: TextStyle(color: _darkSecondaryText), // Secondary text
      titleLarge: TextStyle(color: _darkOnSurface),
      titleMedium: TextStyle(color: _darkOnSurface),
      titleSmall: TextStyle(color: _darkOnSurface),
      labelLarge: TextStyle(color: _darkOnSurface),
      labelSmall: TextStyle(color: _darkSecondaryText),
    ),

    // Icon Theme
    iconTheme: const IconThemeData(color: _darkSecondaryText),

    // Component Themes
    appBarTheme: const AppBarTheme(
      backgroundColor: _darkBackground,
      foregroundColor: _darkOnSurface,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: _darkOnSurface,
      ),
      actionsIconTheme: const IconThemeData(color: _darkSecondaryText),
    ),

    cardTheme: CardThemeData(
      color: _darkSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(
          color: Color(0x1FFFFFFF),
          width: 1,
        ), // Subtle 12% white border for depth without shadow
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _darkPrimary,
        foregroundColor: _darkOnPrimary,
        elevation: 4,
        shadowColor: _darkPrimary.withValues(alpha: 0.4), // Colorful shadow
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: _darkPrimary,
        side: const BorderSide(color: _darkPrimary, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: _darkPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _darkSurface,
      prefixIconColor: _darkSecondaryText,
      suffixIconColor: _darkSecondaryText,
      // Default Border: Transparent (Clean Look)
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.transparent),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.transparent),
      ),
      // Focused Border: Primary Color
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: _darkPrimary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: _darkError, width: 2),
      ),
      hintStyle: const TextStyle(color: _darkSecondaryText),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: _darkBottomNav,
      selectedItemColor: _darkPrimary,
      unselectedItemColor: _darkSecondaryText,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),

    drawerTheme: const DrawerThemeData(
      backgroundColor: _darkSurface,
      elevation: 16,
    ),

    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return _darkPrimary;
        }
        return Colors.grey;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return _darkPrimary.withValues(alpha: 0.5);
        }
        return Colors.grey.withValues(alpha: 0.5);
      }),
    ),

    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return _darkPrimary;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(_darkOnPrimary),
    ),

    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return _darkPrimary;
        }
        return Colors.grey;
      }),
    ),

    sliderTheme: const SliderThemeData(
      activeTrackColor: _darkPrimary,
      inactiveTrackColor: Colors.grey,
      thumbColor: _darkPrimary,
      overlayColor: Color(0x1F90CAF9),
    ),

    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: _darkPrimary,
      linearTrackColor: Colors.grey,
      circularTrackColor: Colors.grey,
    ),

    snackBarTheme: const SnackBarThemeData(
      backgroundColor: Color(0xFF334155),
      contentTextStyle: TextStyle(color: Colors.white),
      actionTextColor: _darkPrimary,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
  );
}
