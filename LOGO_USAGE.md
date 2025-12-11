# 🎨 Panduan Penggunaan Logo SuperCashier

## 📦 Setup

Logo SuperCashier sudah tersedia dalam format SVG dan dapat digunakan di seluruh aplikasi.

### File yang Sudah Dibuat:
- `assets/images/supercashier_logo.svg` - Logo utama dalam SVG
- `lib/widgets/app_logo.dart` - Widget logo reusable

## 🚀 Cara Penggunaan

### 1. Import Widget Logo

```dart
import 'package:pos_kasir_flutter/widgets/app_logo.dart';
```

### 2. Penggunaan Dasar

#### Logo Default (100x100)
```dart
const AppLogo()
```

#### Logo dengan Text
```dart
const AppLogo(showText: true)
```

#### Logo dengan Ukuran Custom
```dart
const AppLogo(
  width: 150,
  height: 150,
)
```

#### Logo dengan Warna Custom
```dart
const AppLogo(
  width: 100,
  height: 100,
  color: Colors.white,
)
```

### 3. Logo untuk AppBar

```dart
AppBar(
  title: const AppBarLogo(),
  backgroundColor: const Color(0xFF673AB7),
)
```

### 4. Logo untuk Splash Screen

```dart
const Scaffold(
  body: Center(
    child: SplashLogo(),
  ),
)
```

## 📝 Contoh Implementasi

### Di Login Page
```dart
Column(
  children: [
    const AppLogo(
      width: 120,
      height: 120,
      showText: true,
    ),
    const SizedBox(height: 24),
    // ... form login
  ],
)
```

### Di AppBar Home Screen
```dart
AppBar(
  title: const AppBarLogo(),
  backgroundColor: const Color(0xFF673AB7),
)
```

### Di Dialog/Popup
```dart
showDialog(
  context: context,
  builder: (context) => AlertDialog(
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const AppLogo(width: 80, height: 80),
        const SizedBox(height: 16),
        const Text('Transaksi Berhasil!'),
      ],
    ),
  ),
);
```

## 🎯 Widget yang Tersedia

### 1. AppLogo
Widget utama logo dengan berbagai kustomisasi.

**Parameters:**
- `width` (double?) - Lebar logo
- `height` (double?) - Tinggi logo
- `color` (Color?) - Warna logo (untuk monochrome)
- `showText` (bool) - Tampilkan text "SuperCashier"

### 2. AppBarLogo
Logo khusus untuk AppBar dengan text.

### 3. SplashLogo
Logo untuk splash screen dengan text lengkap.

## 💡 Tips

1. **Gunakan const** untuk performa lebih baik
2. **Logo SVG** otomatis scalable tanpa kehilangan kualitas
3. **Fallback** ke PNG jika SVG gagal load
4. **Custom color** cocok untuk tema dark/light mode

## 🔧 Troubleshooting

### Logo tidak muncul?
1. Pastikan `flutter pub get` sudah dijalankan
2. Cek file SVG ada di `assets/images/supercashier_logo.svg`
3. Cek `pubspec.yaml` sudah include `flutter_svg` package
4. Restart app dengan hot restart (bukan hot reload)

### Error saat build?
```bash
flutter clean
flutter pub get
flutter run
```
