import 'package:flutter/material.dart';
import '../models/post.dart';
import '../theme/tokens.dart';
import '../widgets/common.dart';

class PostDetailScreen extends StatelessWidget {
  const PostDetailScreen({super.key, required this.post});
  final Post post;

  Future<void> _confirmDelete(BuildContext context) async {
    final ok = await showModalBottomSheet<bool>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(KSpace.pageGutter, 0, KSpace.pageGutter, KSpace.field),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Gönderi silinsin mi?', style: Theme.of(ctx).textTheme.titleMedium),
            const SizedBox(height: KSpace.helper),
            Text('Bu işlem geri alınamaz.',
                style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(color: mutedOf(ctx))),
            const SizedBox(height: KSpace.field),
            PrimaryButton(label: 'Sil', onPressed: () => Navigator.pop(ctx, true)),
            const SizedBox(height: KSpace.compact),
            TextAction(label: 'Vazgeç', onPressed: () => Navigator.pop(ctx, false)),
          ]),
        ),
      ),
    );
    if (ok == true && context.mounted) {
      // TODO: silme isteği
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Gönderi ayrıntısı')),
      body: SafeArea(
        child: Column(children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: KSpace.pageGutter),
              child: SurfaceCard(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  // İç bölüm: 24px radius, gölgesiz.
                  Container(
                    height: 176,
                    width: double.infinity,
                    decoration: BoxDecoration(color: post.type.color, borderRadius: BorderRadius.circular(KRadius.section)),
                    child: Stack(children: [
                      Center(child: Icon(post.type.icon, color: Colors.white, size: 48)),
                      Positioned(
                        left: KSpace.related,
                        top: KSpace.related,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: KSpace.related, vertical: 4),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
                          child: Text(post.type.label,
                              style: t.bodySmall?.copyWith(color: const Color(0xFF4D4D4D), fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ]),
                  ),
                  const SizedBox(height: KSpace.related),
                  Text(post.title, style: t.bodyLarge?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: KSpace.helper),
                  StatusChip(status: post.status),
                  const SizedBox(height: KSpace.related),
                  const Divider(height: 1),
                  const SizedBox(height: KSpace.related),
                  _Info('Zamanlama', fullSchedule(post.scheduledAt)),
                  _Info('Platformlar', post.platforms.isEmpty ? '—' : post.platforms.join(', ')),
                  _Info('Açıklama', post.caption.isEmpty ? '—' : post.caption),
                ]),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(KSpace.pageGutter),
            child: Column(children: [
              PrimaryButton(label: 'Düzenle', onPressed: () {}),
              const SizedBox(height: KSpace.compact),
              SecondaryButton(label: 'Yeniden zamanla', onPressed: () {}),
              const SizedBox(height: KSpace.helper),
              TextAction(label: 'Gönderiyi sil', destructive: true, onPressed: () => _confirmDelete(context)),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _Info extends StatelessWidget {
  const _Info(this.label, this.value);
  final String label, value;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: KSpace.related),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: t.bodySmall?.copyWith(color: mutedOf(context), fontWeight: FontWeight.w600)),
        Text(value, style: t.bodyMedium),
      ]),
    );
  }
}
