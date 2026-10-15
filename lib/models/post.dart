import 'package:flutter/material.dart';
import '../theme/tokens.dart';

enum PostType {
  image('Görsel', Icons.image_outlined, KColors.postImage, 'Tek görsel veya galeri'),
  video('Video', Icons.play_arrow_rounded, KColors.postVideo, 'Kısa veya uzun video'),
  text('Metin', Icons.text_fields_rounded, KColors.postText, 'Yalnızca yazılı paylaşım');

  const PostType(this.label, this.icon, this.color, this.hint);
  final String label;
  final IconData icon;
  final Color color;
  final String hint;
}

enum PostStatus {
  scheduled('Planlandı', KColors.infoText, KColors.info),
  published('Yayında', KColors.successText, KColors.success),
  draft('Taslak', Color(0xFF5F5F5F), Color(0xFFB0B0B0));

  const PostStatus(this.label, this.color, this.darkColor);
  final String label;
  final Color color; // açık mod
  final Color darkColor; // koyu mod
}

class Post {
  const Post({
    required this.id,
    required this.title,
    required this.type,
    required this.status,
    this.scheduledAt,
    this.platforms = const [],
    this.caption = '',
  });
  final String id;
  final String title;
  final PostType type;
  final PostStatus status;
  final DateTime? scheduledAt;
  final List<String> platforms;
  final String caption;
}

const _short = ['Oca', 'Şub', 'Mar', 'Nis', 'May', 'Haz', 'Tem', 'Ağu', 'Eyl', 'Eki', 'Kas', 'Ara'];
const _long = ['Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran', 'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'];
String _two(int n) => n.toString().padLeft(2, '0');

String shortSchedule(DateTime? d) =>
    d == null ? 'Henüz zamanlanmadı' : '${d.day} ${_short[d.month - 1]} · ${_two(d.hour)}:${_two(d.minute)}';

/// Tarih, saat ve saat dilimi açıkça gösterilir.
String fullSchedule(DateTime? d) {
  if (d == null) return 'Henüz zamanlanmadı';
  final o = d.timeZoneOffset;
  return '${d.day} ${_long[d.month - 1]} ${d.year} · ${_two(d.hour)}:${_two(d.minute)} · '
      'GMT${o.isNegative ? '-' : '+'}${o.inHours.abs()}';
}

// TODO: Supabase'ten gelen gerçek veriyle değiştir.
final samplePosts = <Post>[
  Post(id: '1', title: 'Hafta sonu kampanya videosu', type: PostType.video, status: PostStatus.scheduled,
      scheduledAt: DateTime(2026, 10, 15, 18, 30), platforms: const ['Instagram', 'Facebook'],
      caption: '[Gönderi açıklama metni]'),
  Post(id: '2', title: 'Yeni ürün tanıtım görseli', type: PostType.image, status: PostStatus.published,
      scheduledAt: DateTime(2026, 10, 14, 12, 0), platforms: const ['LinkedIn'], caption: '[Gönderi açıklama metni]'),
  const Post(id: '3', title: 'Müşteri yorumu paylaşımı', type: PostType.text, status: PostStatus.draft),
];
