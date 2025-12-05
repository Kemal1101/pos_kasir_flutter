import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool rememberMe = false;
  bool isLoading = false;
  // State untuk toggle show/hide password
  bool obscurePassword = true;

  // Colors based on the image's gradient and accents
  static const Color primaryPurple = Color(0xFF7A59FF); // Warna ungu utama
  static const Color lightPurple = Color(0xFFC78FF9); // Warna ungu muda/pink
  static const Color mainTextColor = Color(
    0xFF4A4A8E,
  ); // Warna teks utama gelap

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Melakukan proses login
  Future<void> doLogin() async {
    if (isLoading) return;

    setState(() => isLoading = true);

    final email = emailController.text.trim();
    // PERBAIKAN: Mengganti passwordController.controller.text menjadi passwordController.text
    final password = passwordController.text.trim();

    try {
      // Simulasikan panggilan ke AuthController (ganti dengan implementasi AuthController sesungguhnya)
      await Future.delayed(const Duration(seconds: 1));

      // Panggil AuthController
      if (mounted) {
        // Asumsi AuthController().login adalah fungsi yang ada
        // Jika AuthController belum diimplementasikan, ini akan tetap menjadi TO DO
        // Namun, error kompilasi di sini sudah diperbaiki.
        AuthController().login(context, email, password);
      }
    } catch (e) {
      if (mounted) {
        // Tampilkan pesan error jika login gagal
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Login Error: $e')));
      }
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLandscape = screenWidth > screenHeight;
    
    // Untuk landscape di mobile/tablet, gunakan desktop layout
    // Untuk portrait di layar kecil, gunakan mobile layout
    final bool useDesktopLayout = screenWidth >= 800 || isLandscape;

    return Scaffold(
      // Menggunakan warna latar belakang yang lebih halus
      backgroundColor: const Color(0xfff5f5f5),
      // Penting: Biarkan scaffold resize saat keyboard muncul
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: useDesktopLayout
            ? _desktopBody(context)
            : _mobileBody(context),
      ),
    );
  }

  // ------------------------------------
  // DESKTOP BODY WRAPPER (Juga untuk landscape)
  // ------------------------------------
  Widget _desktopBody(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallLandscape = screenHeight < 450;
    
    // Hitung tinggi card yang optimal
    final cardHeight = screenHeight * 0.85;
    final minCardHeight = isSmallLandscape ? 280.0 : 400.0;
    final maxCardHeight = 650.0;
    final finalCardHeight = cardHeight.clamp(minCardHeight, maxCardHeight);
    
    return Center(
      child: SingleChildScrollView(
        child: Container(
          width: screenWidth > 1000 ? 1000 : screenWidth * 0.95,
          height: finalCardHeight,
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: _desktopLayout(context, isSmallLandscape),
          ),
        ),
      ),
    );
  }

  // ------------------------------------
  // MOBILE BODY WRAPPER (Diperbaiki untuk mengisi layar penuh)
  // ------------------------------------
  Widget _mobileBody(BuildContext context) {
    return Container(
      // Menggunakan tinggi layar penuh untuk Container utama di mobile
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      // Hapus BoxDecoration agar tidak ada sudut membulat di mobile
      // dan pastikan latar belakang scaffold terlihat.
      color: Colors.white,
      child: _mobileLayout(),
    );
  }

  // ------------------------------------
  // MOBILE LAYOUT (Disesuaikan untuk padding)
  // ------------------------------------
  Widget _mobileLayout() {
    return SingleChildScrollView(
      // Gunakan ConstrainedBox untuk memastikan SingleChildScrollView mengisi tinggi yang tersedia
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight:
              MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top -
              MediaQuery.of(context).padding.bottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header dengan lebar penuh
            const _GradientHeader(isMobile: true),
            // Beri padding hanya pada Form Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              child: _formSection(),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------
  // DESKTOP LAYOUT (Juga untuk landscape mobile)
  // ------------------------------------
  Widget _desktopLayout(BuildContext context, bool isSmallLandscape) {
    final isCompact = isSmallLandscape;
    
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: _GradientHeader(isMobile: false, isCompact: isCompact),
        ),
        Expanded(
          flex: 5,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isCompact ? 20 : 60,
              vertical: isCompact ? 10 : 40,
            ),
            child: _formSection(isCompact: isCompact),
          ),
        ),
      ],
    );
  }

  // ------------------------------------
  // FORM SECTION (Digunakan oleh kedua layout)
  // ------------------------------------
  Widget _formSection({bool isCompact = false}) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // "Sign In" title
          Text(
            "Sign In",
            style: TextStyle(
              fontSize: isCompact ? 22 : 28,
              fontWeight: FontWeight.bold,
              color: mainTextColor,
            ),
          ),

          SizedBox(height: isCompact ? 15 : 30),

          // EMAIL INPUT
          _buildInputField(
            label: "EMAIL",
            hint: "admin@supercashier.com",
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            isCompact: isCompact,
          ),

          SizedBox(height: isCompact ? 10 : 20),

          // PASSWORD INPUT
          _buildInputField(
            label: "PASSWORD",
            hint: "********",
            controller: passwordController,
            isPassword: true,
            isCompact: isCompact,
          ),

          SizedBox(height: isCompact ? 8 : 15),

          // REMEMBER ME + FORGOT PASSWORD
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                    height: isCompact ? 24 : 48,
                    width: isCompact ? 24 : 48,
                    child: Checkbox(
                      value: rememberMe,
                      onChanged: (v) => setState(() => rememberMe = v ?? false),
                      activeColor: primaryPurple,
                    ),
                  ),
                  Text(
                    "Remember me",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: isCompact ? 12 : 14,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  /* TODO: Implement Forgot Password */
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: isCompact ? 4 : 8,
                    vertical: isCompact ? 2 : 4,
                  ),
                ),
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(
                    color: primaryPurple,
                    fontWeight: FontWeight.w600,
                    fontSize: isCompact ? 12 : 14,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: isCompact ? 15 : 35),

          // LOGIN BUTTON
          _buildLoginButton(isCompact: isCompact),

          SizedBox(height: isCompact ? 10 : 30),
        ],
      ),
    );
  }

  // ------------------------------------
  // HELPER WIDGETS
  // ------------------------------------

  // Custom Input Field for consistent styling
  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
    bool isCompact = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.grey,
            fontSize: isCompact ? 11 : 14,
          ),
        ),
        SizedBox(height: isCompact ? 4 : 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(isCompact ? 8 : 10),
            // Border yang sangat tipis, seperti di gambar
            border: Border.all(color: Colors.grey.shade300, width: 1.0),
          ),
          child: TextField(
            controller: controller,
            // Gunakan obscurePassword jika isPassword=true
            obscureText: isPassword ? obscurePassword : false,
            keyboardType: keyboardType,
            style: TextStyle(
              color: mainTextColor,
              fontSize: isCompact ? 13 : 16,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.grey.shade400,
                fontSize: isCompact ? 13 : 16,
              ),
              filled: true,
              fillColor: Colors.transparent,
              // Disesuaikan: Mengurangi padding vertikal agar lebih compact
              contentPadding: EdgeInsets.symmetric(
                horizontal: isCompact ? 12 : 20,
                vertical: isCompact ? 8 : 12,
              ),
              border: InputBorder.none, // Hapus border default
              isDense: true,
              // ICON TOGGLE untuk password
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                        size: isCompact ? 18 : 20,
                      ),
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  // Custom Login Button with Gradient
  Widget _buildLoginButton({bool isCompact = false}) {
    return SizedBox(
      width: double.infinity,
      height: isCompact ? 40 : 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [primaryPurple, lightPurple],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(isCompact ? 8 : 12),
          boxShadow: [
            BoxShadow(
              color: primaryPurple.withOpacity(0.4),
              blurRadius: isCompact ? 6 : 10,
              offset: Offset(0, isCompact ? 3 : 5),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : doLogin,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(isCompact ? 8 : 12),
            ),
          ),
          child: isLoading
              ? SizedBox(
                  width: isCompact ? 20 : 24,
                  height: isCompact ? 20 : 24,
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                )
              : Text(
                  "SIGN IN",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isCompact ? 14 : 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
        ),
      ),
    );
  }
}

// ------------------------------------
// WIDGET BARU: HEADER GRADIENT
// ------------------------------------
class _GradientHeader extends StatelessWidget {
  final bool isMobile;
  final bool isCompact;
  const _GradientHeader({required this.isMobile, this.isCompact = false});

  static const Color primaryPurple = Color(0xFF7A59FF);
  static const Color lightPurple = Color(0xFFC78FF9);
  static const Color brightPink = Color(0xFFF988BC);
  static const Color cashierTextColor = Color(0xFFFFEB3B);

  @override
  Widget build(BuildContext context) {
    return Container(
      // Pastikan lebar selalu penuh di mobile, dan tinggi penuh untuk desktop/landscape
      width: double.infinity,
      height: isMobile ? 220 : double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [primaryPurple, lightPurple, brightPink],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: isMobile
            ? const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              )
            : const BorderRadius.only(
                topLeft: Radius.circular(25),
                bottomLeft: Radius.circular(25),
              ),
      ),
      child: Stack(
        children: [
          // Background waves/shapes (menggunakan CustomPainter)
          Positioned.fill(
            child: Opacity(
              opacity: 0.15,
              child: CustomPaint(painter: _HeaderWavePainter(isMobile)),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(isMobile ? 30 : (isCompact ? 20 : 50)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // Disesuaikan: Menggunakan center untuk tampilan vertikal yang lebih baik di mobile (Refinement 1)
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Menjaga agar 'Welcome Back!' tetap satu baris di mobile sesuai screenshot
                Text(
                  "Welcome Back!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isMobile ? 32 : (isCompact ? 28 : 44),
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: isCompact ? 4 : 8),
                Text(
                  "SuperCashier",
                  style: TextStyle(
                    color: cashierTextColor,
                    fontSize: isCompact ? 16 : 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------
// CUSTOM PAINTER (Untuk mensimulasikan bentuk gelombang/garis di background)
// ------------------------------------
class _HeaderWavePainter extends CustomPainter {
  final bool isMobile;
  _HeaderWavePainter(this.isMobile);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Bentuk gelombang yang disederhanakan
    Path path = Path();
    if (isMobile) {
      // Wave bottom for mobile
      path.lineTo(0, size.height * 0.7);
      path.quadraticBezierTo(
        size.width * 0.25,
        size.height * 0.9,
        size.width * 0.5,
        size.height * 0.75,
      );
      path.quadraticBezierTo(
        size.width * 0.75,
        size.height * 0.6,
        size.width,
        size.height * 0.75,
      );
      path.lineTo(size.width, 0);
    } else {
      // Wave right edge for desktop
      path.moveTo(size.width, 0);
      path.lineTo(size.width * 0.3, 0);
      path.quadraticBezierTo(
        size.width * 0.6,
        size.height * 0.25,
        size.width * 0.4,
        size.height * 0.5,
      );
      path.quadraticBezierTo(
        size.width * 0.1,
        size.height * 0.75,
        size.width * 0.3,
        size.height,
      );
      path.lineTo(size.width, size.height);
    }
    path.close(); // Pastikan path tertutup

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
