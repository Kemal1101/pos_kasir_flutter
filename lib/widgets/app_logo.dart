import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Widget logo SuperCashier yang bisa digunakan di seluruh aplikasi
/// Mendukung SVG dan fallback ke PNG jika diperlukan
class AppLogo extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? color;
  final bool showText;

  const AppLogo({
    super.key,
    this.width,
    this.height,
    this.color,
    this.showText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Logo SVG
        SvgPicture.asset(
          'assets/images/supercashier_logo.svg',
          width: width ?? 100,
          height: height ?? 100,
          colorFilter: color != null
              ? ColorFilter.mode(color!, BlendMode.srcIn)
              : null,
          // Fallback jika SVG gagal load
          placeholderBuilder: (context) => Image.asset(
            'assets/images/supercashier_logo.png',
            width: width ?? 100,
            height: height ?? 100,
            errorBuilder: (context, error, stackTrace) {
              // Fallback terakhir: Icon default
              return Icon(
                Icons.store,
                size: width ?? 100,
                color: color ?? const Color(0xFF673AB7),
              );
            },
          ),
        ),
        if (showText) ...[
          const SizedBox(height: 8),
          const Text(
            'SuperCashier',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ],
    );
  }
}

/// Logo kecil untuk AppBar
class AppBarLogo extends StatelessWidget {
  const AppBarLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          'assets/images/supercashier_logo.svg',
          width: 32,
          height: 32,
          colorFilter: const ColorFilter.mode(
            Colors.white,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(width: 8),
        const Text(
          'SuperCashier',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }
}

/// Logo untuk splash screen / loading
class SplashLogo extends StatelessWidget {
  const SplashLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/images/supercashier_logo.svg',
          width: 120,
          height: 120,
        ),
        const SizedBox(height: 24),
        const Text(
          'SuperCashier POS',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF673AB7),
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Point of Sale System',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }
}
