# Kobimat Mobil

## Kurulum (Windows PowerShell)

```powershell
cd C:\Users\enesb\kobimat.ai
flutter create mobile --platforms=web,android --project-name kobimat_mobile
# Bu zipin içeriğini mobile\ klasörüne çıkar (pubspec.yaml, lib\, test\, assets\ üzerine yazılır)
cd mobile
Invoke-WebRequest https://kobimat.ai/images/icon.webp -OutFile assets\images\icon.webp
flutter pub get
flutter run -d chrome
```

- Flutter 3.24+ gerekir (`flutter upgrade`).
- Logo yoksa uygulama yedek "k" karesini gösterir.
- Font eklenene kadar sistem fontu kullanılır (bkz. pubspec.yaml).
- Telefon boyutu: Chrome'da F12 > Ctrl+Shift+M > 390x844.

## Yapı

- `lib/theme/` renk, boşluk, radius tokenları ve açık/koyu tema
- `lib/widgets/` logo ve ortak bileşenler
- `lib/screens/` giriş, gönderi listesi, ayrıntı, oluşturma adımı
- `lib/models/post.dart` model ve örnek veri (TODO: Supabase)
