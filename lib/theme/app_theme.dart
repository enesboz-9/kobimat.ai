import 'package:flutter/material.dart';
import 'tokens.dart';

const _font = 'ClashGrotesk';

TextTheme _textTheme(Color c) {
  TextStyle s(double size, double line, FontWeight w) => TextStyle(
      fontFamily: _font, fontSize: size, height: line / size, fontWeight: w, color: c);
  return TextTheme(
    titleLarge: s(20, 28, FontWeight.w700), // H5 sayfa başlığı
    titleMedium: s(18, 24, FontWeight.w700), // H6 bölüm başlığı
    bodyLarge: s(16, 24, FontWeight.w500), // Body1
    bodyMedium: s(14, 20, FontWeight.w500), // Body2
    labelLarge: s(14, 20, FontWeight.w600), // Buton
    bodySmall: s(13, 20, FontWeight.w500), // Caption
  );
}

ThemeData _build(Brightness b) {
  final dark = b == Brightness.dark;
  final bg = dark ? KColors.bgDark : KColors.bgLight;
  final paper = dark ? KColors.paperDark : KColors.paperLight;
  final text = dark ? KColors.textDark : KColors.textLight;
  final outline = dark ? KColors.outlineDark : KColors.outlineLight;
  final muted = dark ? KColors.mutedDark : KColors.mutedLight;
  OutlineInputBorder border(Color c, double w) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(KRadius.control),
      borderSide: BorderSide(color: c, width: w));

  return ThemeData(
    useMaterial3: true,
    brightness: b,
    fontFamily: _font,
    scaffoldBackgroundColor: bg,
    colorScheme: ColorScheme(
      brightness: b,
      primary: KColors.primary,
      onPrimary: Colors.white,
      secondary: KColors.secondary,
      onSecondary: Colors.white,
      error: KColors.error,
      onError: Colors.white,
      surface: paper,
      onSurface: text,
    ),
    textTheme: _textTheme(text),
    appBarTheme: AppBarTheme(
      backgroundColor: bg,
      foregroundColor: text,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: _textTheme(text).titleMedium,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: paper,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      hintStyle: TextStyle(fontFamily: _font, color: muted),
      border: border(outline, 1),
      enabledBorder: border(outline, 1),
      focusedBorder: border(KColors.primary, 2),
      errorBorder: border(KColors.error, 1),
      focusedErrorBorder: border(KColors.error, 2),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: paper,
      height: 72,
      indicatorColor: KColors.primary.withAlpha(30),
      labelTextStyle: WidgetStateProperty.resolveWith((s) => TextStyle(
          fontFamily: _font,
          fontSize: 12,
          fontWeight: s.contains(WidgetState.selected) ? FontWeight.w700 : FontWeight.w600,
          color: s.contains(WidgetState.selected) ? KColors.primary : muted)),
      iconTheme: WidgetStateProperty.resolveWith((s) => IconThemeData(
          color: s.contains(WidgetState.selected) ? KColors.primary : muted)),
    ),
    dividerColor: outline,
  );
}

final ThemeData kobimatLight = _build(Brightness.light);
final ThemeData kobimatDark = _build(Brightness.dark);
