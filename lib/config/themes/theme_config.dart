import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    onPrimary: Colors.black,
    secondary: Colors.white,
    onSecondary: Colors.black,
    error: Colors.red,
    onError: Colors.white,
    background: Color(0xFF101010),
    onBackground: Colors.white,
    surface: Color(0x12868686),
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
      cardColor: colorScheme.surface,
      sliderTheme: SliderThemeData(
        activeTrackColor: colorScheme.onBackground,
        inactiveTrackColor: colorScheme.onSurface.withOpacity(0.5),
        thumbColor: colorScheme.onBackground,
        overlayColor: colorScheme.onBackground.withOpacity(0.2),
        trackHeight: 8,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
        trackShape: const RoundedRectSliderTrackShape(),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 0),
      ),
      cardTheme: const CardTheme(
        elevation: 0,
        // margin: EdgeInsets.zero,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.background,
        actionTextColor: colorScheme.onBackground,
        contentTextStyle: TextStyle(color: colorScheme.onBackground),
        elevation: 0,
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Measurements.defaultBorderRadius),
        ),
        subtitleTextStyle: GoogleFonts.poppins(fontSize: Theme.of(context).textTheme.labelMedium?.fontSize),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(Measurements.defaultBorderRadius)),
        alignLabelWithHint: true,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          padding: MaterialStateProperty.all(const EdgeInsets.fromLTRB(16, 0, 16, 0)),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Measurements.defaultBorderRadius),
            ),
          ),
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) {
              return colorScheme.onBackground.withOpacity(0.1);
            }
            if (states.contains(MaterialState.pressed) || states.contains(MaterialState.hovered)) {
              return colorScheme.onBackground.withOpacity(0.2);
            }
            return colorScheme.onBackground;
          }),
          foregroundColor: MaterialStateProperty.all(colorScheme.onPrimary),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          padding: MaterialStateProperty.all(const EdgeInsets.fromLTRB(32, 16, 32, 16)),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Measurements.defaultBorderRadius),
            ),
          ),
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) {
              return colorScheme.onBackground.withOpacity(0.1);
            }
            if (states.contains(MaterialState.pressed) || states.contains(MaterialState.hovered)) {
              return colorScheme.onBackground.withOpacity(0.2);
            }
            return colorScheme.onBackground;
          }),
          foregroundColor: MaterialStateProperty.all(colorScheme.onPrimary),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(colorScheme.primary),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.onBackground,
        foregroundColor: colorScheme.onPrimary,
      ),
      cupertinoOverrideTheme: CupertinoThemeData(
        brightness: Brightness.dark,
        applyThemeToAll: true,
        barBackgroundColor: colorScheme.background,
        scaffoldBackgroundColor: colorScheme.background,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(
        TextTheme(
          displayLarge: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
          bodySmall: TextStyle(
            color: colorScheme.onSurface.withOpacity(0.5),
          ),
          titleLarge: TextStyle(
            fontSize: Theme.of(context).textTheme.titleLarge!.fontSize! * 1.25,
            fontWeight: FontWeight.w600,
          ),
          titleMedium: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
          titleSmall: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
