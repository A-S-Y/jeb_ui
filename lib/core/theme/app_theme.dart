import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Cairo',
      colorScheme: _lightColorScheme,
      appBarTheme: _lightAppBarTheme,
      scaffoldBackgroundColor: Colors.white,
      cardColor: Colors.white,
      inputDecorationTheme: _inputDecorationTheme(Colors.black),
      elevatedButtonTheme: _elevatedButtonTheme(Colors.white, Colors.redAccent),
      floatingActionButtonTheme: _floatingActionButtonTheme(
        Colors.white,
        const Color.fromARGB(0, 28, 57, 65),
      ),
      textTheme: _getTextTheme(),
      splashFactory: InkRipple.splashFactory,
      splashColor: Colors.red.withOpacity(0.08),
      textSelectionTheme: TextSelectionThemeData(
        selectionHandleColor: Colors.red,
        selectionColor: Colors.red.withOpacity(0.6),
        cursorColor: Colors.red,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: const Color.fromARGB(255, 242, 104, 77),
        contentTextStyle: const TextStyle(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Cairo',
      colorScheme: _darkColorScheme,
      appBarTheme: _darkAppBarTheme,
      scaffoldBackgroundColor: Colors.black,
      cardColor: const Color.fromARGB(255, 57, 57, 57),
      inputDecorationTheme: _inputDecorationTheme(Colors.white),
      elevatedButtonTheme: _elevatedButtonTheme(Colors.white, Colors.black),
      floatingActionButtonTheme: _floatingActionButtonTheme(
        const Color.fromARGB(255, 57, 57, 57),
        Colors.white,
      ),
      textTheme: _getTextTheme(),
      splashFactory: InkRipple.splashFactory,
      splashColor: Colors.red.withOpacity(0.08),
      textSelectionTheme: TextSelectionThemeData(
        selectionHandleColor: Colors.red,
        selectionColor: Colors.red.withOpacity(0.6),
        cursorColor: Colors.red,
      ),
    );
  }

  static const ColorScheme _lightColorScheme = ColorScheme(
    primary: Colors.black,
    secondary: Colors.black,
    surface: Colors.white,
    error: Color.fromARGB(255, 242, 104, 77),
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.black,
    onError: Colors.white,
    brightness: Brightness.light,
  );

  static const ColorScheme _darkColorScheme = ColorScheme(
    primary: Colors.white,
    secondary: Colors.white,
    surface: Colors.black,
    error: Color.fromARGB(255, 242, 104, 77),
    onPrimary: Colors.black,
    onSecondary: Colors.black,
    onSurface: Colors.white,
    onError: Colors.black,
    brightness: Brightness.dark,
  );

  static const AppBarTheme _lightAppBarTheme = AppBarTheme(
    centerTitle: true,
    elevation: 0,
    backgroundColor: Colors.white,
    iconTheme: IconThemeData(color: Colors.black),
  );

  static const AppBarTheme _darkAppBarTheme = AppBarTheme(
    centerTitle: true,
    elevation: 0,
    backgroundColor: Colors.black,
    iconTheme: IconThemeData(color: Colors.white),
  );

  static InputDecorationTheme _inputDecorationTheme(Color borderColor) {
    return InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
    );
  }

  static ElevatedButtonThemeData _elevatedButtonTheme(
      Color backgroundColor, Color foregroundColor) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: foregroundColor,
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  static FloatingActionButtonThemeData _floatingActionButtonTheme(
      Color backgroundColor, Color foregroundColor) {
    return FloatingActionButtonThemeData(
      shape: const CircleBorder(),
      elevation: 1,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
    );
  }

  static TextTheme _getTextTheme() {
    const fontFamily = 'Cairo';
    return const TextTheme(
      displayLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
      bodyMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
      bodySmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.normal,
      ),
    );
  }
}
