import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: "Tajawal",
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF1A66FF), // Custom primary color
      onPrimary: Color(0xFFFFFFFF), // Text/icons on primary
      secondary: Color(0xFF698596), // Secondary color
      onSecondary: Color(0xFF000000),
      primaryContainer: Colors.white,
      surface: Color(0xFFFBFAFF), // For cards, sheets, etc.
      onSurface: Color(0xFF000000),
      error: Color(0xFFD54444), // Error color
      onError: Color(0xFFFFFFFF),
      outline: Color(0xFFEAEEF0), // Outline color
      onSurfaceVariant: Color(0xFF49454F),
      surfaceContainerLow: Color(0xFFEAEEF0),
      surfaceContainerHighest: Color(0xFFF0F0F0),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: "Tajawal",
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFF16CA8B), // Custom primary color
      onPrimary: Color(0xFFFFFFFF), // White text/icons on primary
      secondary: Color(0xFF9CA3AF), // Secondary color for dark mode
      onSecondary: Color(0xFF000000),
      primaryContainer: Color(0xFF2D3748), // Lighter dark container
      surface: Color(0xFF1A202C), // Dark surface for cards, sheets, etc.
      onSurface: Color(0xFFE2E8F0), // Light gray text on dark surface
      error: Color(0xFFEF4444), // Error color for dark mode
      onError: Color(0xFFFFFFFF),
      outline: Color(0xFF4A5568), // Lighter dark outline color
      onSurfaceVariant: Color(0xFFCBD5E0), // Light text on dark surface
      surfaceContainerLow: Color(0xFF2D3748), // Dark container low
      background: Color(0xFF171923), // Dark background
      onBackground: Color(0xFFE2E8F0), // Light gray text on dark background
      surfaceVariant: Color(0xFF2D3748), // For input fields background
      inverseSurface: Color(0xFFE2E8F0), // Light surface for contrast
      onInverseSurface: Color(0xFF1A202C), // Dark text on light surface
    ),
  );
}
