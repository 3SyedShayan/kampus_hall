import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LoginTransitionScreen extends StatefulWidget {
  static const routeName = '/login/transition';
  const LoginTransitionScreen({super.key});

  @override
  State<LoginTransitionScreen> createState() => _LoginTransitionScreenState();
}

class _LoginTransitionScreenState extends State<LoginTransitionScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _imageSlide;
  late final Animation<double> _logoScale;
  late final Animation<double> _contentFade;
  String? _email;
  bool _showPasswordField = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: 2000.ms)
      ..forward();
    _imageSlide = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0, 0.6, curve: Curves.easeOutCubic),
    );
    _logoScale = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 0.8, curve: Curves.easeOutBack),
    );
    _contentFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 1, curve: Curves.easeOut),
    );

    // Show password field after initial animations
    Future.delayed(1500.ms, () {
      if (mounted) {
        setState(() => _showPasswordField = true);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is String) {
      _email = args;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _getUniversityImage() {
    if (_email == null) return 'assets/images/generic_campus.png';
    final lower = _email!.toLowerCase();
    if (lower.endsWith('@nust.edu.pk')) return 'assets/images/nust_campus.png';
    if (lower.endsWith('@fast.edu.pk')) return 'assets/images/fast_campus.png';
    return 'assets/images/generic_campus.png';
  }

  String _getUniversityLogo() {
    if (_email == null) return 'U';
    final lower = _email!.toLowerCase();
    if (lower.endsWith('@nust.edu.pk')) return 'N';
    if (lower.endsWith('@fast.edu.pk')) return 'F';
    return 'U';
  }

  @override
  Widget build(BuildContext context) {
    final imagePath = _getUniversityImage();
    final logoText = _getUniversityLogo();

    return Scaffold(
      backgroundColor: const Color(0xff2C2C2E),
      body: Stack(
        children: [
          // Diagonal background image
          AnimatedBuilder(
            animation: _imageSlide,
            builder: (context, child) {
              return ClipPath(
                clipper: _DiagonalClipper(),
                child: Transform.translate(
                  offset: Offset(0, -300 * (1 - _imageSlide.value)),
                  child: Container(
                    width: 375,
                    height: 286,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(imagePath),
                        fit: BoxFit.cover,
                        onError: (exception, stackTrace) {},
                      ),
                    ),
                    // Fallback color if image fails to load
                    child: imagePath == 'assets/images/generic_campus.png'
                        ? Container(
                            color: const Color(0xff85F0F7).withOpacity(0.3),
                            child: const Center(
                              child: Icon(
                                Icons.account_balance,
                                size: 60,
                                color: Colors.white70,
                              ),
                            ),
                          )
                        : null,
                  ),
                ),
              );
            },
          ),
          // Circular logo in the center
          AnimatedBuilder(
            animation: _logoScale,
            builder: (context, child) {
              return Positioned(
                left: 150,
                top: 207,
                child: Transform.scale(
                  scale: _logoScale.value,
                  child: Container(
                    width: 75,
                    height: 75,
                    decoration: const BoxDecoration(
                      color: Color(0xff85F0F7),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Container(
                        width: 39,
                        height: 52,
                        decoration: BoxDecoration(
                          color: const Color(0xff2C2C2E),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(
                          child: Text(
                            logoText,
                            style: const TextStyle(
                              color: Color(0xff85F0F7),
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          // Content section
          AnimatedBuilder(
            animation: _contentFade,
            builder: (context, child) {
              return Opacity(
                opacity: _contentFade.value,
                child: Positioned(
                  left: 21,
                  top: 312,
                  right: 21,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Login title
                      const Text(
                        'Login',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Color(0xffEFEFEF),
                        ),
                      ),
                      const SizedBox(height: 80), // 392 - 312 = 80
                      // Email field
                      const Text(
                        'Email 365',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Column(
                        children: [
                          Text(
                            _email ?? 'user@university.edu.pk',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 1,
                            width: 332.5,
                            color: const Color(0xff85F0F7),
                          ),
                        ],
                      ),
                      const SizedBox(height: 80), // 472 - 392 = 80
                      // Password field (animated in)
                      if (_showPasswordField) ...[
                        const Text(
                              'Password',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Color(0xffEFEFEF),
                              ),
                            )
                            .animate()
                            .fadeIn(duration: 400.ms)
                            .slideY(begin: 0.3, end: 0),
                        const SizedBox(height: 8),
                        Row(
                              children: [
                                const Expanded(
                                  child: TextField(
                                    obscureText: true,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.only(
                                        bottom: 8,
                                      ),
                                      hintText: '••••••••',
                                      hintStyle: TextStyle(
                                        color: Colors.white54,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 44,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: Colors.white24),
                                  ),
                                  child: const Icon(
                                    Icons.visibility_outlined,
                                    color: Colors.white54,
                                    size: 20,
                                  ),
                                ),
                              ],
                            )
                            .animate()
                            .fadeIn(duration: 400.ms, delay: 100.ms)
                            .slideY(begin: 0.3, end: 0),
                        const SizedBox(height: 8),
                        Container(
                              height: 1,
                              width: 332.5,
                              color: const Color(0xff85F0F7),
                            )
                            .animate()
                            .fadeIn(duration: 400.ms, delay: 200.ms)
                            .scaleX(begin: 0, end: 1),
                        const SizedBox(height: 44), // 539 - 495 = 44
                      ],
                      // Login button
                      Container(
                            width: 332,
                            height: 52,
                            decoration: BoxDecoration(
                              color: const Color(0xff85F0F7),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    'Login',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                          .animate()
                          .slideY(
                            begin: 0.4,
                            end: 0,
                            duration: 500.ms,
                            delay: _showPasswordField ? 600.ms : 0.ms,
                          )
                          .fadeIn(delay: _showPasswordField ? 600.ms : 0.ms),
                    ],
                  ),
                ),
              );
            },
          ),
          // Wave design at bottom
          Positioned.fill(child: CustomPaint(painter: _WavePainter())),
        ],
      ),
    );
  }
}

class _DiagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(375, 0); // Full width at top
    path.lineTo(375, 286); // Full height at right
    path.lineTo(0, 286); // Full height at left
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xff85F0F7)
      ..style = PaintingStyle.fill;

    final path = Path();
    final height = size.height;
    final width = size.width;

    // Start wave from bottom left, matching Figma design
    path.moveTo(-23, height - 139); // Starting point from Figma coordinates

    // Create the wave curve
    path.quadraticBezierTo(
      width * 0.3,
      height - 120, // Control point 1
      width * 0.6,
      height - 100, // End point 1
    );
    path.quadraticBezierTo(
      width * 0.8,
      height - 80, // Control point 2
      width + 100,
      height - 60, // End point extending beyond screen
    );

    // Complete the shape
    path.lineTo(width + 100, height);
    path.lineTo(-23, height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
