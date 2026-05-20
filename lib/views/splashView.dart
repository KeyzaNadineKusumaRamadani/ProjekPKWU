import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projek_kik/views/loginView.dart';



class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with TickerProviderStateMixin {
  late AnimationController _mascotCtrl;
  late AnimationController _textCtrl;
  late Animation<double> _mascotScale;
  late Animation<double> _textFade;
  late Animation<Offset> _mascotSlide;
  late Animation<Offset> _textSlide;

  int _currentPage = 0;

  final List<Map<String, String>> _pages = [
    {
      'title': 'Cook Without the Hassle',
      'desc': 'Paket sayur dan bumbu lengkap yang siap membantu Anda membuat masakan lezat tanpa perlu repot berbelanja.',
    },
    {
      'title': 'Fresh Every Day',
      'desc': 'Kami menjamin kesegaran setiap produk yang kami antar langsung ke pintu rumah Anda.',
    },
    {
      'title': 'Quick Delivery',
      'desc': 'Pesanan Anda akan sampai dalam waktu singkat dengan pengiriman cepat dan terpercaya.',
    },
  ];

  @override
  void initState() {
    super.initState();

    _mascotCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600), // dipercepat dari 900ms
    );
    _textCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450), // dipercepat dari 700ms
    );

    _mascotScale = CurvedAnimation(parent: _mascotCtrl, curve: Curves.easeOutBack);
    _mascotSlide = Tween<Offset>(begin: const Offset(0, -0.3), end: Offset.zero)
        .animate(CurvedAnimation(parent: _mascotCtrl, curve: Curves.easeOut));
    _textFade = CurvedAnimation(parent: _textCtrl, curve: Curves.easeOut);
    _textSlide = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(CurvedAnimation(parent: _textCtrl, curve: Curves.easeOut));

    _playEnter();
  }

  void _playEnter() {
    _mascotCtrl.forward();
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) _textCtrl.forward();
    });
  }

  @override
  void dispose() {
    _mascotCtrl.dispose();
    _textCtrl.dispose();
    super.dispose();
  }

  void _goToLogin() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const LoginView(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _mascotCtrl.reset();
      _textCtrl.reset();
      setState(() => _currentPage++);
      _playEnter();
    } else {
      _goToLogin();
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = _pages[_currentPage];
    final isLast = _currentPage == _pages.length - 1;

    return Scaffold(
      backgroundColor: const Color(0xFF1A3A2A),
      body: Stack(
        children: [
          Column(
            children: [
              // ── Top: mascot area ─────────────────────────────────────
              Expanded(
                flex: 6,
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius: 1.0,
                      colors: [Color(0xFF2E6B45), Color(0xFF1A3A2A)],
                    ),
                  ),
                  child: SlideTransition(
                    position: _mascotSlide,
                    child: ScaleTransition(
                      scale: _mascotScale,
                      child: Center(child: _BroccoliMascot(size: 210)),
                    ),
                  ),
                ),
              ),

              // ── Bottom: white card ───────────────────────────────────
              Expanded(
                flex: 4,
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(36)),
                  ),
                  padding: const EdgeInsets.fromLTRB(28, 24, 28, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text content
                      FadeTransition(
                        opacity: _textFade,
                        child: SlideTransition(
                          position: _textSlide,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['title']!,
                                style: GoogleFonts.poppins(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF1A3A2A),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                data['desc']!,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                  height: 1.6,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const Spacer(),

                      // Dot indicator + Next button row
                      Row(
                        children: [
                          // Dots
                          Row(
                            children: List.generate(_pages.length, (i) {
                              final active = i == _currentPage;
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                margin: const EdgeInsets.only(right: 6),
                                width: active ? 22 : 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: active
                                      ? const Color(0xFF2E6B45)
                                      : const Color(0xFFB8D4C4),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              );
                            }),
                          ),
                          const Spacer(),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // Next / Get Started button
                      GestureDetector(
                        onTap: _nextPage,
                        child: Container(
                          width: double.infinity,
                          height: 54,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A3A2A),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF1A3A2A).withValues(alpha: 0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              isLast ? 'Get Started' : 'Next',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // ── Skip button (pojok kanan atas) ───────────────────────────
          if (!isLast)
            Positioned(
              top: MediaQuery.of(context).padding.top + 12,
              right: 20,
              child: GestureDetector(
                onTap: _goToLogin,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Skip',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Broccoli Mascot ─────────────────────────────────────────────────────────
class _BroccoliMascot extends StatefulWidget {
  final double size;
  const _BroccoliMascot({required this.size});

  @override
  State<_BroccoliMascot> createState() => _BroccoliMascotState();
}

class _BroccoliMascotState extends State<_BroccoliMascot>
    with SingleTickerProviderStateMixin {
  late AnimationController _bob;

  @override
  void initState() {
    super.initState();
    _bob = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _bob.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _bob,
      builder: (_, child) => Transform.translate(
        offset: Offset(0, Tween<double>(begin: -7, end: 7)
            .evaluate(CurvedAnimation(parent: _bob, curve: Curves.easeInOut))),
        child: child,
      ),
      child: CustomPaint(
        size: Size(widget.size, widget.size),
        painter: _BroccoliPainter(),
      ),
    );
  }
}

class _BroccoliPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Stem
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.42, h * 0.55, w * 0.16, h * 0.38),
        const Radius.circular(8),
      ),
      Paint()..color = const Color(0xFF4A8C5C),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.45, h * 0.57, w * 0.06, h * 0.22),
        const Radius.circular(4),
      ),
      Paint()..color = const Color(0xFF5AA870),
    );

    // Head + sub clusters
    canvas.drawCircle(Offset(w * 0.5, h * 0.38), w * 0.34,
        Paint()..color = const Color(0xFF3D7A52));
    final sub = Paint()..color = const Color(0xFF4A8C5C);
    canvas.drawCircle(Offset(w * 0.32, h * 0.42), w * 0.22, sub);
    canvas.drawCircle(Offset(w * 0.68, h * 0.42), w * 0.22, sub);
    canvas.drawCircle(Offset(w * 0.5, h * 0.24), w * 0.24, sub);

    final hl = Paint()..color = const Color(0xFF5BAA6F);
    canvas.drawCircle(Offset(w * 0.5, h * 0.20), w * 0.16, hl);
    canvas.drawCircle(Offset(w * 0.30, h * 0.36), w * 0.12, hl);
    canvas.drawCircle(Offset(w * 0.70, h * 0.36), w * 0.12, hl);

    // Shadow
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(w * 0.5, h * 0.56), width: w * 0.6, height: h * 0.08),
      Paint()..color = const Color(0xFF2A5C38).withValues(alpha: 0.4),
    );

    // Eyes
    canvas.drawCircle(Offset(w * 0.42, h * 0.40), w * 0.05, Paint()..color = Colors.white);
    canvas.drawCircle(Offset(w * 0.58, h * 0.40), w * 0.05, Paint()..color = Colors.white);
    canvas.drawCircle(Offset(w * 0.43, h * 0.41), w * 0.028, Paint()..color = const Color(0xFF1A2A1E));
    canvas.drawCircle(Offset(w * 0.59, h * 0.41), w * 0.028, Paint()..color = const Color(0xFF1A2A1E));
    canvas.drawCircle(Offset(w * 0.44, h * 0.395), w * 0.01, Paint()..color = Colors.white);
    canvas.drawCircle(Offset(w * 0.60, h * 0.395), w * 0.01, Paint()..color = Colors.white);

    // Smile
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.41, h * 0.47)
        ..quadraticBezierTo(w * 0.5, h * 0.53, w * 0.59, h * 0.47),
      Paint()
        ..color = const Color(0xFF1A2A1E)
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.022
        ..strokeCap = StrokeCap.round,
    );

    // Blush
    canvas.drawCircle(Offset(w * 0.35, h * 0.46), w * 0.045,
        Paint()..color = const Color(0xFFFF8FAB).withValues(alpha: 0.5));
    canvas.drawCircle(Offset(w * 0.65, h * 0.46), w * 0.045,
        Paint()..color = const Color(0xFFFF8FAB).withValues(alpha: 0.5));

    // Arms
    final arm = Paint()
      ..color = const Color(0xFFD4A574)
      ..strokeWidth = w * 0.06
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.22, h * 0.50)
        ..quadraticBezierTo(w * 0.14, h * 0.42, w * 0.10, h * 0.30),
      arm,
    );
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.78, h * 0.50)
        ..quadraticBezierTo(w * 0.86, h * 0.38, w * 0.90, h * 0.28),
      arm,
    );

    // Fork
    final fork = Paint()
      ..color = const Color(0xFFC0C0C0)
      ..strokeWidth = w * 0.025
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(w * 0.10, h * 0.30), Offset(w * 0.07, h * 0.18), fork);
    canvas.drawLine(Offset(w * 0.12, h * 0.29), Offset(w * 0.10, h * 0.17), fork);
    canvas.drawLine(Offset(w * 0.14, h * 0.29), Offset(w * 0.13, h * 0.17), fork);

    // Right hand
    canvas.drawCircle(Offset(w * 0.90, h * 0.26), w * 0.06,
        Paint()..color = const Color(0xFFD4A574));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}