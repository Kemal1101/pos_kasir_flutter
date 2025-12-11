# 📱 Panduan Setup App Icon untuk SuperCashier

## 🎯 Langkah-langkah Setup Icon Aplikasi

### 1️⃣ Persiapan File Icon

Anda memerlukan file PNG dengan resolusi tinggi untuk app icon:
- **Ukuran minimum:** 512x512 px
- **Format:** PNG dengan background
- **Ukuran optimal:** 1024x1024 px

**File yang harus disiapkan:**
```
assets/images/app_icon.png (512x512 atau 1024x1024)
assets/images/app_icon_foreground.png (untuk Android adaptive icon)
```

### 2️⃣ Convert SVG ke PNG

Karena saya sudah membuat `app_icon_source.svg`, Anda perlu convert ke PNG:

#### Cara 1: Online Tool
1. Buka https://cloudconvert.com/svg-to-png
2. Upload `assets/images/app_icon_source.svg`
3. Set size ke 1024x1024
4. Download dan simpan sebagai `app_icon.png`

#### Cara 2: Menggunakan Inkscape (jika terinstall)
```bash
inkscape assets/images/app_icon_source.svg --export-type=png --export-width=1024 --export-height=1024 --export-filename=assets/images/app_icon.png
```

### 3️⃣ Install Package

```bash
flutter pub get
```

### 4️⃣ Generate App Icons

Setelah file `app_icon.png` tersedia, jalankan:

```bash
dart run flutter_launcher_icons
```

atau

```bash
flutter pub run flutter_launcher_icons
```

### 5️⃣ Verifikasi

Cek folder berikut untuk memastikan icon sudah terbuat:
- **Android:** `android/app/src/main/res/mipmap-*/ic_launcher.png`
- **iOS:** `ios/Runner/Assets.xcassets/AppIcon.appiconset/`

### 6️⃣ Rebuild & Test

```bash
flutter clean
flutter run
```

## 📋 File yang Sudah Dibuat

1. **flutter_launcher_icons.yaml** - Konfigurasi generator icon
2. **app_icon_source.svg** - Source icon dalam SVG (perlu diconvert ke PNG)

## 🎨 Kustomisasi

### Mengubah Warna Background (Android Adaptive Icon)

Edit `flutter_launcher_icons.yaml`:
```yaml
adaptive_icon_background: "#7DB3E8"  # Ubah warna di sini
```

### Menggunakan Icon yang Berbeda

Ganti path di `flutter_launcher_icons.yaml`:
```yaml
image_path: "assets/images/your_custom_icon.png"
```

## ⚠️ Catatan Penting

1. **File PNG wajib ada** - Flutter launcher icons hanya bekerja dengan PNG
2. **Resolusi tinggi** - Gunakan minimal 512x512, optimal 1024x1024
3. **Background solid** - Untuk icon yang terlihat bagus di semua launcher
4. **Adaptive icon** - Android akan otomatis crop sesuai bentuk launcher

## 🔧 Troubleshooting

### Error: "Image file not found"
- Pastikan file `app_icon.png` ada di `assets/images/`
- Cek nama file sama persis dengan yang di config

### Icon tidak berubah setelah build
```bash
flutter clean
flutter pub get
dart run flutter_launcher_icons
flutter run
```

### Icon terpotong di Android
- Gunakan `adaptive_icon_foreground` dengan padding 20% di setiap sisi
- Background akan otomatis diisi dengan `adaptive_icon_background` color

## 📱 Preview Icon

Setelah generate, icon akan muncul:
- **Android:** Di home screen dan app drawer
- **iOS:** Di home screen
- **Web:** Sebagai favicon dan PWA icon

## 💡 Tips

1. Gunakan logo sederhana untuk app icon (tanpa text kecil)
2. Test di berbagai background (terang/gelap)
3. Pastikan terlihat jelas di ukuran kecil (48x48)
4. Gunakan warna kontras yang baik
