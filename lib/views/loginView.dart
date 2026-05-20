import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:projek_kik/providers/authProvider.dart';
import 'package:projek_kik/views/forgotView.dart';
import 'package:projek_kik/views/registerView.dart';
import 'package:projek_kik/widgets/authButton.dart';
import 'package:projek_kik/widgets/authText.dart';
import 'package:projek_kik/widgets/brocoliWidget.dart';
import 'package:projek_kik/widgets/mainNav.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView>
    with SingleTickerProviderStateMixin {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscure = true;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeAnim =
        CurvedAnimation(parent: _animController, curve: Curves.easeOut);

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();

    final success = await auth.login(
      _emailCtrl.text.trim(),
      _passCtrl.text,
    );

    if (!mounted) return;

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainNav(initialIndex: 0),),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.error ?? 'Login gagal'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: Colors.white,

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Color(0xffEAF5F1),
              Color(0xff1F5B4D),
            ],
          ),
        ),

        child: SafeArea(
          child: Column(
            children: [
              // ── Top bar ─────────────────────────────────────────────────
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),

                      child: Text(
                        'Cancel',

                        style: GoogleFonts.poppins(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ),

                    Text(
                      'Sign In',

                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: const Color(0xFF2E6B45),
                      ),
                    ),

                    const SizedBox(width: 50),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),

                  child: FadeTransition(
                    opacity: _fadeAnim,

                    child: SlideTransition(
                      position: _slideAnim,

                      child: Form(
                        key: _formKey,

                        child: Column(
                          children: [
                            const SizedBox(height: 12),

                            // Mascot
                            const BroccoliMascot(size: 160),

                            const SizedBox(height: 24),

                            // Welcome text
                            Text(
                              'Welcome Back !',

                              style: GoogleFonts.poppins(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF1A3A2A),
                              ),
                            ),

                            const SizedBox(height: 24),

                            // ── Form fields ────────────────────────────────
                            Container(
                              padding: const EdgeInsets.all(20),

                              decoration: BoxDecoration(
                                color: const Color(0xFF1A3A2A),
                                borderRadius: BorderRadius.circular(20),
                              ),

                              child: Column(
                                children: [
                                  AuthTextField(
                                    controller: _emailCtrl,
                                    hint: 'Email Address',
                                    icon: Icons.email_outlined,

                                    keyboardType:
                                        TextInputType.emailAddress,

                                    validator: (v) => v!.isEmpty
                                        ? 'Email wajib diisi'
                                        : null,
                                  ),

                                  const SizedBox(height: 14),

                                  AuthTextField(
                                    controller: _passCtrl,
                                    hint: 'Password',
                                    icon: Icons.lock_outline,

                                    obscureText: _obscure,

                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscure
                                            ? Icons
                                                .visibility_off_outlined
                                            : Icons
                                                .visibility_outlined,

                                        color: Colors.grey[400],
                                        size: 20,
                                      ),

                                      onPressed: () {
                                        setState(() {
                                          _obscure = !_obscure;
                                        });
                                      },
                                    ),

                                    validator: (v) => v!.isEmpty
                                        ? 'Password wajib diisi'
                                        : null,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Forgot password
                            Align(
                              alignment: Alignment.centerLeft,

                              child: GestureDetector(
                                onTap: () => Navigator.push(
                                  context,

                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const ForgotPasswordView(),
                                  ),
                                ),

                                child: RichText(
                                  text: TextSpan(
                                    text: 'Forgot Password? ',

                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: Colors.grey[600],
                                    ),

                                    children: [
                                      TextSpan(
                                        text: 'Click here',

                                        style: GoogleFonts.poppins(
                                          color:
                                              const Color(0xFF2E6B45),

                                          fontWeight: FontWeight.w600,

                                          decoration:
                                              TextDecoration.underline,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            AuthButton(
                              label: 'Sign In',
                              isLoading: auth.isLoading,
                              onTap: _login,
                            ),

                            const SizedBox(height: 20),

                            // OR divider
                            Row(
                              children: [
                                const Expanded(
                                  child: Divider(
                                    color: Color(0xFFD0D0D0),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),

                                  child: Text(
                                    'OR',

                                    style: GoogleFonts.poppins(
                                      color:const Color.fromARGB(255, 42, 42, 42),
                                      fontSize: 12,
                                    ),
                                  ),
                                ),

                                const Expanded(
                                  child: Divider(
                                    color: Color(0xFFD0D0D0),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // Google sign in
                            _GoogleButton(),

                            const SizedBox(height: 20),

                            // Sign Up link
                            GestureDetector(
                              onTap: () => Navigator.pushReplacement(
                                context,

                                MaterialPageRoute(
                                  builder: (_) =>
                                      const RegisterView(),
                                ),
                              ),

                              child: RichText(
                                text: TextSpan(
                                  text:
                                      "Don't have account yet? ",

                                  style: GoogleFonts.poppins(
                                    color: const Color.fromARGB(255, 42, 42, 42),
                                    fontSize: 13,
                                  ),

                                  children: [
                                    TextSpan(
                                      text: 'Sign Up',

                                      style: GoogleFonts.poppins(
                                        color:
                                            const Color.fromARGB(255, 250, 250, 250),

                                        fontWeight:
                                            FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GoogleButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},

      child: Container(
        height: 52,

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),

          border: Border.all(
            color: const Color(0xFFE0E0E0),
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            // G logo
            Container(
              width: 22,
              height: 22,

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),

              child: CustomPaint(
                painter: _GoogleLogoPainter(),
              ),
            ),

            const SizedBox(width: 10),

            Text(
              'Continue with Google',

              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                color: Colors.grey[800],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    final center = rect.center;

    const strokeW = 2.5;

    final bluePaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeW
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCenter(
        center: center,
        width: size.width * 0.85,
        height: size.height * 0.85,
      ),

      -0.3,
      5.4,
      false,

      bluePaint..color = const Color(0xFF4285F4),
    );

    final linePaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..strokeWidth = strokeW
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(center.dx, center.dy),
      Offset(size.width * 0.92, center.dy),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}