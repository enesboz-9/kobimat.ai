import 'package:flutter/material.dart';
import '../models/post.dart';
import '../theme/tokens.dart';
import '../widgets/common.dart';
import 'create_step_screen.dart';
import 'post_detail_screen.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});
  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  PostStatus? _filter; // null = Tümü
  late Future<List<Post>> _future = _load();

  // TODO: Supabase sorgusu ile değiştir.
  Future<List<Post>> _load() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return samplePosts;
  }

  void _retry() => setState(() => _future = _load());

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CreateStepScreen())),
        backgroundColor: KColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: Text('Oluştur', style: t.labelLarge?.copyWith(color: Colors.white)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(KSpace.pageGutter, KSpace.field, KSpace.pageGutter, 0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Marka seçimi üst alanda; seçim ekranlar arasında korunmalı (state yönetimine taşı).
            SizedBox(
              height: touchTargetMin,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.keyboard_arrow_down),
                iconAlignment: IconAlignment.end,
                label: const Text('Örnek Marka'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.onSurface,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  side: BorderSide(color: outlineOf(context)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(KRadius.control)),
                  textStyle: t.labelLarge,
                ),
              ),
            ),
            const SizedBox(height: KSpace.field),
            Text('Gönderiler', style: t.titleLarge),
            const SizedBox(height: KSpace.field),
            Wrap(spacing: KSpace.compact, children: [
              _chip('Tümü', null),
              _chip('Planlı', PostStatus.scheduled),
              _chip('Taslak', PostStatus.draft),
            ]),
            const SizedBox(height: KSpace.related),
            Expanded(
              child: FutureBuilder<List<Post>>(
                future: _future,
                builder: (context, snap) {
                  if (snap.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snap.hasError) {
                    return StateMessage(
                        icon: Icons.cloud_off_outlined,
                        title: 'Gönderiler yüklenemedi',
                        message: 'Bağlantını kontrol edip tekrar dene.',
                        actionLabel: 'Tekrar dene',
                        onAction: _retry);
                  }
                  final posts = snap.data!.where((p) => _filter == null || p.status == _filter).toList();
                  if (posts.isEmpty) {
                    return const StateMessage(
                        icon: Icons.grid_view_rounded,
                        title: 'Henüz gönderi yok',
                        message: 'Bu filtrede gönderi bulunmuyor. "Oluştur" ile yenisini ekleyebilirsin.');
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.only(bottom: 88),
                    itemCount: posts.length,
                    separatorBuilder: (_, __) => const SizedBox(height: KSpace.related),
                    itemBuilder: (_, i) => _PostCard(post: posts[i]),
                  );
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _chip(String label, PostStatus? value) {
    final selected = _filter == value;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      showCheckmark: false,
      onSelected: (_) => setState(() => _filter = value),
      selectedColor: KColors.primary,
      labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: selected ? Colors.white : Theme.of(context).colorScheme.onSurface),
      side: BorderSide(color: selected ? KColors.primary : outlineOf(context)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(KRadius.control)),
      padding: const EdgeInsets.symmetric(horizontal: KSpace.compact, vertical: KSpace.compact),
    );
  }
}

class _PostCard extends StatelessWidget {
  const _PostCard({required this.post});
  final Post post;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final muted = t.bodySmall?.copyWith(color: mutedOf(context));
    final meta = [shortSchedule(post.scheduledAt), if (post.platforms.isNotEmpty) post.platforms.join(', ')].join(' · ');
    return SurfaceCard(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => PostDetailScreen(post: post))),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        TypeThumb(type: post.type),
        const SizedBox(width: KSpace.related),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(post.title, style: t.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: KSpace.helper),
            StatusChip(status: post.status, type: post.type),
            const SizedBox(height: KSpace.helper),
            Text(meta, style: muted),
          ]),
        ),
        // İkincil eylemler menüde.
        PopupMenuButton<String>(
          tooltip: 'Daha fazla eylem',
          iconSize: 24,
          constraints: const BoxConstraints(minWidth: touchTargetMin),
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'edit', child: Text('Düzenle')),
            PopupMenuItem(value: 'delete', child: Text('Sil')),
          ],
          onSelected: (_) {},
        ),
      ]),
    );
  }
}
