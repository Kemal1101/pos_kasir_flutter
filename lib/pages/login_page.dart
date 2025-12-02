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
    // Breakpoint untuk layout responsif
    final bool isMobile = MediaQuery.of(context).size.width < 800;

    return Scaffold(
      // Menggunakan warna latar belakang yang lebih halus
      backgroundColor: const Color(0xfff5f5f5),
      body: isMobile
          ? _mobileBody(context)
          : _desktopBody(), // Memisahkan body untuk mobile/desktop
    );
  }

  // ------------------------------------
  // DESKTOP BODY WRAPPER (Masih menggunakan Center/Container terbatas)
  // ------------------------------------
  Widget _desktopBody() {
    return Center(
      child: Container(
        width: 1000,
        height: 650,
        margin: const EdgeInsets.all(20),
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
        child: _desktopLayout(),
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
  // DESKTOP LAYOUT
  // ------------------------------------
  Widget _desktopLayout() {
    return Row(
      children: [
        const Expanded(flex: 4, child: _GradientHeader(isMobile: false)),
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
            child: _formSection(),
          ),
        ),
      ],
    );
  }

  // ------------------------------------
  // FORM SECTION (Digunakan oleh kedua layout)
  // ------------------------------------
  Widget _formSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // "Sign In" title
        const Text(
          "Sign In",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: mainTextColor,
          ),
        ),

        const SizedBox(height: 30),

        // EMAIL INPUT
        _buildInputField(
          label: "EMAIL",
          hint: "admin@supercashier.com",
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
        ),

        const SizedBox(height: 20),

        // PASSWORD INPUT
        _buildInputField(
          label: "PASSWORD",
          hint: "********",
          controller: passwordController,
          isPassword: true,
        ),

        const SizedBox(height: 15),

        // REMEMBER ME + FORGOT PASSWORD
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Checkbox(
                  value: rememberMe,
                  onChanged: (v) => setState(() => rememberMe = v ?? false),
                  activeColor: primaryPurple,
                ),
                const Text("Remember me", style: TextStyle(color: Colors.grey)),
              ],
            ),
            TextButton(
              onPressed: () {
                /* TODO: Implement Forgot Password */
              },
              child: const Text(
                "Forgot Password?",
                style: TextStyle(
                  color: primaryPurple,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 35),

        // LOGIN BUTTON
        _buildLoginButton(),

        const SizedBox(height: 30),
      ],
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
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            // Border yang sangat tipis, seperti di gambar
            border: Border.all(color: Colors.grey.shade300, width: 1.0),
          ),
          child: TextField(
            controller: controller,
            // Gunakan obscurePassword jika isPassword=true
            obscureText: isPassword ? obscurePassword : false,
            keyboardType: keyboardType,
            style: const TextStyle(color: mainTextColor),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey.shade400),
              filled: true,
              fillColor: Colors.transparent,
              // Disesuaikan: Mengurangi padding vertikal agar lebih compact
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
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
                        size: 20,
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
  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [primaryPurple, lightPurple],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: primaryPurple.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 5),
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
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                )
              : const Text(
                  "SIGN IN",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
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
  const _GradientHeader({required this.isMobile});

  static const Color primaryPurple = Color(0xFF7A59FF);
  static const Color lightPurple = Color(0xFFC78FF9);
  static const Color brightPink = Color(0xFFF988BC);
  static const Color cashierTextColor = Color(0xFFFFEB3B);

  @override
  Widget build(BuildContext context) {
    return Container(
      // Pastikan lebar selalu penuh di mobile
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
            padding: EdgeInsets.all(isMobile ? 30 : 50.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // Disesuaikan: Menggunakan center untuk tampilan vertikal yang lebih baik di mobile (Refinement 1)
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Menjaga agar 'Welcome Back!' tetap satu baris di mobile sesuai screenshot
                Text(
                  "Welcome Back!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isMobile ? 32 : 44,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "SuperCashier",
                  style: TextStyle(
                    color: cashierTextColor,
                    fontSize: 20,
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
