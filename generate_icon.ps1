# Script untuk generate app icon
# Jalankan dengan: .\generate_icon.ps1

Write-Host "🎨 SuperCashier - App Icon Generator" -ForegroundColor Cyan
Write-Host "====================================`n" -ForegroundColor Cyan

# Cek apakah file icon PNG sudah ada
$iconPath = "assets\images\app_icon.png"

if (Test-Path $iconPath) {
    Write-Host "✅ File icon ditemukan: $iconPath" -ForegroundColor Green
    
    # Tampilkan info file
    $iconFile = Get-Item $iconPath
    Write-Host "   Ukuran file: $($iconFile.Length / 1KB) KB" -ForegroundColor Gray
    
    Write-Host "`n🔄 Generating app icons..." -ForegroundColor Yellow
    
    # Generate icons
    dart run flutter_launcher_icons
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "`n✅ App icons berhasil di-generate!" -ForegroundColor Green
        Write-Host "`n📱 Icon telah dibuat untuk:" -ForegroundColor Cyan
        Write-Host "   - Android (semua resolusi)" -ForegroundColor Gray
        Write-Host "   - iOS (semua resolusi)" -ForegroundColor Gray
        Write-Host "   - Web (favicon)" -ForegroundColor Gray
        
        Write-Host "`n🚀 Langkah selanjutnya:" -ForegroundColor Yellow
        Write-Host "   1. flutter clean" -ForegroundColor Gray
        Write-Host "   2. flutter run" -ForegroundColor Gray
        Write-Host "`n   Icon baru akan muncul setelah rebuild aplikasi.`n" -ForegroundColor Gray
    } else {
        Write-Host "`n❌ Error saat generate icons!" -ForegroundColor Red
    }
} else {
    Write-Host "❌ File icon tidak ditemukan!" -ForegroundColor Red
    Write-Host "`n📝 Yang perlu dilakukan:" -ForegroundColor Yellow
    Write-Host "   1. Convert app_icon_source.svg ke PNG (1024x1024)" -ForegroundColor Gray
    Write-Host "   2. Simpan sebagai: $iconPath" -ForegroundColor Gray
    Write-Host "`n🌐 Tool online untuk convert:" -ForegroundColor Cyan
    Write-Host "   - https://cloudconvert.com/svg-to-png" -ForegroundColor Gray
    Write-Host "   - https://svgtopng.com/" -ForegroundColor Gray
    Write-Host "`n   Atau baca panduan lengkap di: APP_ICON_SETUP.md`n" -ForegroundColor Gray
}
