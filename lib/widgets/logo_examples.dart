import 'package:flutter/material.dart';
import '../widgets/app_logo.dart';

/// Contoh penggunaan AppLogo di berbagai tempat dalam aplikasi
class LogoExamplesScreen extends StatelessWidget {
  const LogoExamplesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contoh Penggunaan Logo'),
        backgroundColor: const Color(0xFF673AB7),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Logo Default
            const Text('1. Logo Default:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            const Center(child: AppLogo()),
            const Divider(height: 40),

            // 2. Logo dengan Text
            const Text('2. Logo dengan Text:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            const Center(child: AppLogo(showText: true)),
            const Divider(height: 40),

            // 3. Logo Kecil
            const Text('3. Logo Kecil (50x50):', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            const Center(child: AppLogo(width: 50, height: 50)),
            const Divider(height: 40),

            // 4. Logo Besar
            const Text('4. Logo Besar (200x200):', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            const Center(child: AppLogo(width: 200, height: 200)),
            const Divider(height: 40),

            // 5. Logo dengan Custom Color
            const Text('5. Logo dengan Custom Color:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            const Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AppLogo(width: 60, height: 60, color: Colors.red),
                  AppLogo(width: 60, height: 60, color: Colors.green),
                  AppLogo(width: 60, height: 60, color: Colors.blue),
                ],
              ),
            ),
            const Divider(height: 40),

            // 6. Logo di AppBar (Preview)
            const Text('6. Logo di AppBar:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            Container(
              color: const Color(0xFF673AB7),
              padding: const EdgeInsets.all(12),
              child: const AppBarLogo(),
            ),
            const Divider(height: 40),

            // 7. Splash Logo
            const Text('7. Splash Screen Logo:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            Container(
              height: 300,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(child: SplashLogo()),
            ),
          ],
        ),
      ),
    );
  }
}
