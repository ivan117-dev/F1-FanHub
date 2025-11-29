import 'package:flutter/material.dart';

class AppTheme {
  // Tu color verde de marca
  static const Color primaryColor = Color(0xFF69C56C);

  // Colores para Modo Oscuro
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);

  // Colores para Modo Claro
  static const Color lightBackground = Color(0xFFF5F7FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFF0F4F8);

  // Nuevos colores de acento
  static const Color accentOrange = Color(0xFFFF6B35);
  static const Color accentBlue = Color(0xFF4ECDC4);

  // 1. TEMA CLARO (LIGHT)
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
      primary: primaryColor,
      secondary: accentOrange,
      surface: lightSurface,
      surfaceContainerHighest: lightSurfaceVariant,
      outline: Colors.grey.shade300,
    ),
    scaffoldBackgroundColor: lightBackground,

    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey.shade600,
      backgroundColor: lightSurface,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
      unselectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 12,
      ),
    ),

    cardTheme: CardThemeData(
      color: lightSurface,
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
        shadowColor: primaryColor.withValues(alpha: 0.3),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: primaryColor.withValues(alpha: 0.12),
      labelStyle: TextStyle(
        color: primaryColor.withValues(alpha: 0.9),
        fontWeight: FontWeight.w600,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      side: BorderSide(color: primaryColor.withValues(alpha: 0.2), width: 1),
    ),

    dividerTheme: DividerThemeData(
      color: Colors.grey.shade300,
      thickness: 1,
      space: 1,
    ),

    textTheme: TextTheme(
      bodyMedium: TextStyle(color: Colors.grey.shade800),
      bodyLarge: TextStyle(color: Colors.grey.shade900),
      bodySmall: TextStyle(color: Colors.grey.shade600),
      titleLarge: TextStyle(
        color: Colors.grey.shade900,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: TextStyle(
        color: Colors.grey.shade900,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: TextStyle(
        color: Colors.grey.shade700,
        fontWeight: FontWeight.w500,
      ),
    ),

    iconTheme: IconThemeData(color: Colors.grey.shade700),
  );

  // 2. TEMA OSCURO (DARK)
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
      primary: primaryColor,
      secondary: accentOrange,
      surface: darkSurface,
      outline: Colors.grey.shade800,
    ),
    scaffoldBackgroundColor: darkBackground,

    appBarTheme: const AppBarTheme(
      backgroundColor: darkSurface,
      foregroundColor: primaryColor,
      elevation: 0,
      centerTitle: true,
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.white.withValues(alpha: 0.6),
      backgroundColor: darkSurface,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
      unselectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 12,
      ),
    ),

    cardTheme: CardThemeData(
      color: darkSurface,
      elevation: 0,
      shadowColor: primaryColor.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: primaryColor.withValues(alpha: 0.2), width: 1),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: darkBackground,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: primaryColor.withValues(alpha: 0.15),
      labelStyle: const TextStyle(color: primaryColor),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),

    dividerTheme: DividerThemeData(
      color: Colors.grey.shade800,
      thickness: 1,
      space: 1,
    ),

    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.white70),
      bodyLarge: TextStyle(color: Colors.white),
      bodySmall: TextStyle(color: Colors.white60),
      titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      titleSmall: TextStyle(color: Colors.white70, fontWeight: FontWeight.w500),
    ),

    iconTheme: const IconThemeData(color: Colors.white70),
  );
}
