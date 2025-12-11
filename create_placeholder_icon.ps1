# Script untuk membuat placeholder app icon dengan PowerShell
# Jalankan: .\create_placeholder_icon.ps1

Add-Type -AssemblyName System.Drawing

Write-Host "🎨 Membuat placeholder app icon..." -ForegroundColor Cyan

$iconPath = "assets\images\app_icon.png"

# Pastikan folder ada
$folder = Split-Path $iconPath
if (!(Test-Path $folder)) {
    New-Item -ItemType Directory -Path $folder -Force | Out-Null
}

# Buat bitmap 1024x1024
$size = 1024
$bitmap = New-Object System.Drawing.Bitmap($size, $size)
$graphics = [System.Drawing.Graphics]::FromImage($bitmap)
$graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias

# Background gradient
$rect = New-Object System.Drawing.Rectangle(0, 0, $size, $size)
$brush1 = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(168, 213, 242))
$graphics.FillRectangle($brush1, $rect)

# Top box
$topBox = New-Object System.Drawing.Rectangle(175, 80, 400, 320)
$brush2 = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(125, 179, 232))
$graphics.FillRectangle($brush2, $topBox)

# Letter S
$brush3 = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(46, 74, 140))
$sX = 380
$sY = 240
$sW = 200
$sH = 40

$graphics.FillRectangle($brush3, ($sX - $sW/2), ($sY - $sH*3), $sW, $sH)
$graphics.FillRectangle($brush3, ($sX - $sW/2), ($sY - $sH*2), ($sH*0.6), $sH)
$graphics.FillRectangle($brush3, ($sX - $sW/2), ($sY - $sH), $sW, $sH)
$graphics.FillRectangle($brush3, ($sX + $sW/2 - $sH*0.6), $sY, ($sH*0.6), $sH)
$graphics.FillRectangle($brush3, ($sX - $sW/2), ($sY + $sH), $sW, $sH)

# Connector
$connector = New-Object System.Drawing.Rectangle(350, 400, 100, 80)
$brush4 = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(30, 58, 138))
$graphics.FillRectangle($brush4, $connector)

# Bottom box
$bottomBox = New-Object System.Drawing.Rectangle(120, 480, 540, 280)
$graphics.FillRectangle($brush4, $bottomBox)

# White rectangle
$whiteRect = New-Object System.Drawing.Rectangle(330, 560, 100, 80)
$brush5 = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
$graphics.FillRectangle($brush5, $whiteRect)

# Coin decoration
$brush6 = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 213, 79))
$graphics.FillEllipse($brush6, 720, 720, 50, 50)

# Save
$graphics.Dispose()
$bitmap.Save($iconPath, [System.Drawing.Imaging.ImageFormat]::Png)
$bitmap.Dispose()

Write-Host "Icon berhasil dibuat di: $iconPath" -ForegroundColor Green
Write-Host ""
Write-Host "Selanjutnya jalankan:" -ForegroundColor Yellow
Write-Host "   dart run flutter_launcher_icons" -ForegroundColor Gray
