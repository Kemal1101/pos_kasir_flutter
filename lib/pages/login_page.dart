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
  bool obscurePassword =
      true; // KEMBALIKAN: State untuk toggle show/hide password

  // Colors based on the image's gradient and accents
  static const Color primaryPurple = Color(0xFF7A59FF); // Warna ungu utama
  static const Color lightPurple = Color(0xFFC78FF9); // Warna ungu muda/pink
  static const Color brightPink = Color(0xFFF988BC); // Warna pink terang
  static const Color cashierTextColor = Color(
    0xFFFFEB3B,
  ); // Kuning/emas untuk SuperCashier
  static const Color mainTextColor = Color(
    0xFF4A4A8E,
  ); // Warna teks utama gelap

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> doLogin() async {
    if (isLoading) return;

    setState(() => isLoading = true);

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // Panggil AuthController
    await AuthController().login(context, email, password);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    // Breakpoint untuk layout responsif
    final bool isMobile = MediaQuery.of(context).size.width < 800;

    return Scaffold(
      // Menggunakan warna latar belakang yang lebih halus
      backgroundColor: const Color(0xfff5f5f5),
      body: Center(
        child: Container(
          // Di mobile, Container harus mengisi lebar penuh layar jika tidak ada padding di Scaffold
          width: isMobile ? double.infinity : 1000,
          height: isMobile ? null : 650,
          // Hapus margin container utama di mobile
          margin: isMobile ? EdgeInsets.zero : const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: isMobile ? null : BorderRadius.circular(25),
            boxShadow: isMobile
                ? []
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 30,
                      offset: const Offset(0, 15),
                    ),
                  ],
          ),
          child: isMobile ? _mobileLayout() : _desktopLayout(),
        ),
      ),
    );
  }

  // ------------------------------------
  // MOBILE LAYOUT
  // ------------------------------------
  Widget _mobileLayout() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header dengan lebar penuh
          const _GradientHeader(isMobile: true),
          // Beri padding hanya pada Form Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: _formSection(),
          ),
        ],
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
          isPassword: true, // KEMBALIKAN: Aktifkan mode password
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

        // SIGN UP
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Don’t have an account? ",
              style: TextStyle(color: Colors.grey),
            ),
            TextButton(
              onPressed: () {
                /* TODO: Implement Sign Up Navigation */
              },
              child: const Text(
                "Sign Up",
                style: TextStyle(
                  color: primaryPurple,
                  fontWeight: FontWeight.bold,
                  // Garis bawah untuk Sign Up
                  decoration: TextDecoration.underline,
                  decorationColor: primaryPurple,
                  decorationThickness: 1.5,
                ),
              ),
            ),
          ],
        ),
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
    bool isPassword = false, // KEMBALIKAN: Menerima flag isPassword
    TextInputType keyboardType = TextInputType.text,
  }) {
    // Tentukan apakah input ini adalah kolom password berdasarkan flag
    // final bool isPassword = label == "PASSWORD"; // Tidak digunakan lagi karena sudah ada flag

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
            // KEMBALIKAN LOGIKA: Gunakan obscurePassword jika isPassword=true
            obscureText: isPassword ? obscurePassword : false,
            keyboardType: keyboardType,
            style: const TextStyle(color: mainTextColor),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey.shade400),
              filled: true,
              fillColor: Colors.transparent,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 14,
              ),
              border: InputBorder.none, // Hapus border default
              isDense: true,
              // KEMBALIKAN ICON TOGGLE
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
                  width: 24, // Disesuaikan agar lebih jelas
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
              mainAxisAlignment: isMobile
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.center,
              children: [
                if (isMobile) const SizedBox(height: 20),
                Text(
                  isMobile ? "Welcome Back!" : "Welcome\nBack!",
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
          // Tombol Back Button sudah dihapus (sesuai permintaan sebelumnya)
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

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
