import 'package:flutter/material.dart';

/// Kaynak: Kobimat Mobil Tasarım Rehberi. Hex değerler yuvarlanmış karşılıklardır.
class KColors {
  static const primary = Color(0xFFBD32AF);
  static const primaryLight = Color(0xFFD152C4);
  static const primaryDark = Color(0xFF95288A);
  static const secondary = Color(0xFF9256DC);
  static const error = Color(0xFFD64363);
  static const errorText = Color(0xFFC0304F); // küçük metinde kontrast için
  static const warning = Color(0xFFED8B45);
  static const success = Color(0xFF77C464);
  static const successText = Color(0xFF2E7D32);
  static const info = Color(0xFF47C0E1);
  static const infoText = Color(0xFF1B6F85);

  // Gönderi türü renkleri (post-type-colors.ts)
  static const postImage = Color(0xFF2FB7DE);
  static const postVideo = Color(0xFF9B4DE6);
  static const postText = Color(0xFF7A828C);

  static const bgLight = Color(0xFFF5F5F5);
  static const bgDark = Color(0xFF242424);
  static const paperLight = Color(0xFFFFFFFF);
  static const paperDark = Color(0xFF292929);
  static const textLight = Color(0xFF4D4D4D);
  static const textDark = Color(0xFFE6E6E6);
  // Rehberdeki #999999 küçük metinde zayıf; okunabilirlik için koyulaştırıldı.
  static const mutedLight = Color(0xFF6B6B6B);
  static const mutedDark = Color(0xFFA8A8A8);
  static const outlineLight = Color(0xFFCFCFCF);
  static const outlineDark = Color(0xFF4A4A4A);
}

class KSpace {
  static const helper = 4.0;
  static const compact = 8.0;
  static const related = 12.0;
  static const field = 16.0;
  static const section = 24.0;
  static const pageGutter = 16.0;
  static const surfacePadding = 16.0;
}

class KRadius {
  static const surface = 28.0;
  static const section = 24.0;
  static const control = 16.0;
}

const double touchTargetMin = 48;

bool isDark(BuildContext c) => Theme.of(c).brightness == Brightness.dark;
Color mutedOf(BuildContext c) => isDark(c) ? KColors.mutedDark : KColors.mutedLight;
Color outlineOf(BuildContext c) => isDark(c) ? KColors.outlineDark : KColors.outlineLight;
