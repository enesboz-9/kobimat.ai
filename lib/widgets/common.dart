import 'package:flutter/material.dart';
import '../models/post.dart';
import '../theme/tokens.dart';

/// Ana yüzey: paper + shadow-xs, 28px radius.
class SurfaceCard extends StatelessWidget {
  const SurfaceCard({super.key, required this.child, this.onTap});
  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final r = BorderRadius.circular(KRadius.surface);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: r,
        boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 2, offset: Offset(0, 1))],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: r,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(padding: const EdgeInsets.all(KSpace.surfacePadding), child: child),
        ),
      ),
    );
  }
}

RoundedRectangleBorder get _controlShape =>
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(KRadius.control));

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({super.key, required this.label, this.onPressed, this.loading = false});
  final String label;
  final VoidCallback? onPressed;
  final bool loading; // yüklenirken yinelenen dokunuş engellenir, etiket korunur

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        height: 52,
        child: FilledButton(
          onPressed: loading ? null : onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: KColors.primary,
            foregroundColor: Colors.white,
            disabledBackgroundColor: KColors.primary.withAlpha(170),
            disabledForegroundColor: Colors.white,
            shape: _controlShape,
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            if (loading) ...[
              const SizedBox(
                  width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)),
              const SizedBox(width: KSpace.compact),
            ],
            Text(label),
          ]),
        ),
      );
}

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({super.key, required this.label, this.onPressed});
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        height: 52,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: isDark(context) ? KColors.primaryLight : KColors.primaryDark,
            side: const BorderSide(color: KColors.primary, width: 1.5),
            shape: _controlShape,
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
          child: Text(label),
        ),
      );
}

class TextAction extends StatelessWidget {
  const TextAction({super.key, required this.label, this.onPressed, this.destructive = false});
  final String label;
  final VoidCallback? onPressed;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final color = destructive
        ? KColors.errorText
        : (isDark(context) ? KColors.primaryLight : KColors.primaryDark);
    return SizedBox(
      width: double.infinity,
      height: touchTargetMin,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(foregroundColor: color, textStyle: Theme.of(context).textTheme.labelLarge),
        child: Text(label),
      ),
    );
  }
}

/// Kalıcı etiket + alan; hata alanın altında.
class LabeledField extends StatelessWidget {
  const LabeledField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.obscure = false,
    this.keyboardType,
    this.errorText,
    this.autofillHints,
  });
  final String label;
  final TextEditingController controller;
  final String? hint;
  final bool obscure;
  final TextInputType? keyboardType;
  final String? errorText;
  final Iterable<String>? autofillHints;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: KSpace.helper),
          TextField(
            controller: controller,
            obscureText: obscure,
            keyboardType: keyboardType,
            autofillHints: autofillHints,
            decoration: InputDecoration(hintText: hint, errorText: errorText),
          ),
        ],
      );
}

/// Durum yalnız renkle değil, nokta + metinle anlatılır.
class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status, this.type});
  final PostStatus status;
  final PostType? type;

  @override
  Widget build(BuildContext context) {
    final color = isDark(context) ? status.darkColor : status.color;
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      const SizedBox(width: 6),
      Text(type == null ? status.label : '${status.label} · ${type!.label}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: color, fontWeight: FontWeight.w600)),
    ]);
  }
}

class TypeThumb extends StatelessWidget {
  const TypeThumb({super.key, required this.type, this.size = 72});
  final PostType type;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: type.color, borderRadius: BorderRadius.circular(KRadius.control)),
        child: Icon(type.icon, color: Colors.white, size: size * 0.4),
      );
}

/// Boş / hata durumları: neden + sonraki eylem.
class StateMessage extends StatelessWidget {
  const StateMessage({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(KSpace.section),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 48, color: mutedOf(context)),
          const SizedBox(height: KSpace.related),
          Text(title, style: t.titleMedium, textAlign: TextAlign.center),
          const SizedBox(height: KSpace.helper),
          Text(message, style: t.bodyMedium?.copyWith(color: mutedOf(context)), textAlign: TextAlign.center),
          if (actionLabel != null) ...[
            const SizedBox(height: KSpace.field),
            SizedBox(width: 220, child: PrimaryButton(label: actionLabel!, onPressed: onAction)),
          ],
        ]),
      ),
    );
  }
}
