import 'package:flutter/material.dart';
import '../theme/tokens.dart';

/// Resmi marka ikonu: assets/images/icon.webp (https://kobimat.ai/images/icon.webp).
/// Dosya henüz pakette yoksa yedek olarak mor "k" karesi gösterilir.
class KobimatLogo extends StatelessWidget {
  const KobimatLogo({super.key, this.size = 56, this.showWordmark = false});
  final double size;
  final bool showWordmark;

  @override
  Widget build(BuildContext context) {
    final icon = ClipRRect(
      borderRadius: BorderRadius.circular(size * 0.28),
      child: Image.asset(
        'assets/images/icon.webp',
        width: size,
        height: size,
        fit: BoxFit.cover,
        semanticLabel: 'Kobimat logosu',
        errorBuilder: (_, __, ___) => Container(
          width: size,
          height: size,
          color: KColors.primary,
          alignment: Alignment.center,
          child: Text('k',
              style: TextStyle(color: Colors.white, fontSize: size * 0.5, fontWeight: FontWeight.w700)),
        ),
      ),
    );
    if (!showWordmark) return icon;
    return Row(mainAxisSize: MainAxisSize.min, children: [
      icon,
      const SizedBox(width: KSpace.related),
      Text('kobimat',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: 24, color: isDark(context) ? KColors.primaryLight : KColors.primaryDark)),
    ]);
  }
}
