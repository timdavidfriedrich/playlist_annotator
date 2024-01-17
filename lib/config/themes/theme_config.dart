import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:playlist_annotator/constants/measurements.dart';

class ThemeConfig {
  ThemeConfig._();

  static ThemeData light(BuildContext context) {
    return _themeData(context, _darkColorScheme);
  }

  static ThemeData dark(BuildContext context) {
    return _themeData(context, _darkColorScheme);
  }

  static const ColorScheme _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF1DB954),
    onPrimary: Colors.white,
    secondary: Color(0xFFb91d82),
    onSecondary: Colors.white,
    error: Colors.red,
    onError: Colors.white,
    background: Color(0xFF121212),
    onBackground: Colors.white,
    surface: Color(0xFF181818),
    surfaceTint: Color(0xFF222222),
    outline: Color(0xFF262626),
    onSurface: Colors.white,
  );

  static ThemeData _themeData(BuildContext context, ColorScheme colorScheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      hintColor: colorScheme.onSurface.withOpacity(0.5),
      appBarTheme: AppBarTheme(
        color: colorScheme.background,
        centerTitle: false,
      ),
      scaffoldBackgroundColor: colorScheme.background,
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.surface,
        contentTextStyle: TextStyle(color: colorScheme.onSurface),
      ),
      cardColor: colorScheme.surface,
      cardTheme: const CardTheme(
        elevation: 0,
        // margin: EdgeInsets.zero,
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Measurements.defaultBorderRadius),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceTint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Measurements.defaultBorderRadius),
          borderSide: BorderSide.none,
        ),
        alignLabelWithHint: true,
      ),
      cupertinoOverrideTheme: CupertinoThemeData(
        brightness: Brightness.dark,
        applyThemeToAll: true,
        barBackgroundColor: colorScheme.background,
        scaffoldBackgroundColor: colorScheme.background,
      ),
    );
  }
}
