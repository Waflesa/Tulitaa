import 'package:flutter/material.dart';

/// Tema pensado para adultos mayores: letra grande, alto contraste y
/// botones de al menos 64 dp de alto (Material recomienda mínimo 48 dp).
class AppTheme {
  AppTheme._();

  static const Color _verde = Color(0xFF1B5E20);

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: _verde,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: const Color(0xFFF7F7F2),
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
        titleMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
        bodyLarge: TextStyle(fontSize: 22),
        bodyMedium: TextStyle(fontSize: 20),
        labelLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        centerTitle: true,
        toolbarHeight: 72,
        titleTextStyle: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w700,
          color: scheme.onPrimary,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(64),
          textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        extendedSizeConstraints: BoxConstraints.tightFor(height: 68),
        extendedTextStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        labelStyle: const TextStyle(fontSize: 22),
        errorStyle: const TextStyle(fontSize: 18),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(width: 2),
        ),
      ),
    );
  }
}
