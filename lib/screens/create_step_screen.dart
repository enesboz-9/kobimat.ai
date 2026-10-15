import 'package:flutter/material.dart';
import '../models/post.dart';
import '../theme/tokens.dart';
import '../widgets/common.dart';

/// Oluşturma akışının 2. adımı: tek ekranda tek ana adım, ilerleme ve geri dönüş görünür.
class CreateStepScreen extends StatefulWidget {
  const CreateStepScreen({super.key});
  @override
  State<CreateStepScreen> createState() => _CreateStepScreenState();
}

class _CreateStepScreenState extends State<CreateStepScreen> {
  static const _step = 2, _total = 4;
  PostType _type = PostType.video;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni gönderi'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: KSpace.pageGutter),
            child: Center(child: Text('Adım $_step / $_total', style: t.bodySmall?.copyWith(color: mutedOf(context), fontWeight: FontWeight.w600))),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: KSpace.pageGutter),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Semantics(
                  label: 'İlerleme: adım $_step / $_total',
                  child: Row(children: [
                    for (var i = 1; i <= _total; i++) ...[
                      Expanded(
                        child: Container(
                          height: 6,
                          decoration: BoxDecoration(
                            color: i <= _step ? KColors.primary : outlineOf(context),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                      if (i < _total) const SizedBox(width: 6),
                    ],
                  ]),
                ),
                const SizedBox(height: KSpace.field),
                Text('Gönderi türünü seç', style: t.titleLarge),
                const SizedBox(height: KSpace.helper),
                Text('Sonraki adımlar seçtiğin türe göre şekillenir.',
                    style: t.bodyMedium?.copyWith(color: mutedOf(context))),
                const SizedBox(height: KSpace.field),
                for (final type in PostType.values) ...[
                  _TypeOption(type: type, selected: type == _type, onTap: () => setState(() => _type = type)),
                  const SizedBox(height: KSpace.related),
                ],
              ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(KSpace.pageGutter),
            child: Column(children: [
              PrimaryButton(label: 'Devam', onPressed: () {}), // TODO: sonraki adım
              const SizedBox(height: KSpace.compact),
              TextAction(label: 'Taslağı kaydet', onPressed: () {}),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _TypeOption extends StatelessWidget {
  const _TypeOption({required this.type, required this.selected, required this.onTap});
  final PostType type;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Semantics(
      button: true,
      selected: selected,
      label: type.label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(KRadius.section),
        child: Container(
          constraints: const BoxConstraints(minHeight: 72),
          padding: const EdgeInsets.all(KSpace.surfacePadding),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(KRadius.section),
            border: Border.all(color: selected ? KColors.primary : outlineOf(context), width: selected ? 2 : 1.5),
          ),
          child: Row(children: [
            TypeThumb(type: type, size: 44),
            const SizedBox(width: KSpace.related),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(type.label, style: t.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                Text(type.hint, style: t.bodySmall?.copyWith(color: mutedOf(context))),
              ]),
            ),
            if (selected)
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(color: KColors.primary, shape: BoxShape.circle),
                child: const Icon(Icons.check, color: Colors.white, size: 18),
              ),
          ]),
        ),
      ),
    );
  }
}
