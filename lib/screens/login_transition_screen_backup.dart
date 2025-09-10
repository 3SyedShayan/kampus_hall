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
      curve: const Interval(0.3, 0.8, curve: Curves.elasticOut),
    );
    _contentFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.6, 1, curve: Curves.easeIn),
    );

    // Get email from route arguments
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is Map<String, dynamic>) {
        setState(() {
          _email = args['email'] as String?;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showPasswordInput() {
    setState(() {
      _showPasswordField = true;
    });
  }

  void _login() {
    // Handle login logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Login functionality not implemented yet')),
    );
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final imagePath = _getUniversityImage();

    return Scaffold(
      backgroundColor: const Color(0xff2C2C2E),
      body: Stack(
        children: [
          // University image with diagonal clipping and animation
          AnimatedBuilder(
            animation: _imageSlide,
            builder: (context, child) {
              return Positioned(
                left: 0,
                top: 0,
                child: Transform.translate(
                  offset: Offset(0, -300 * (1 - _imageSlide.value)),
                  child: ClipPath(
                    clipper: _DiagonalImageClipper(),
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
                      // Fallback: Create a visual university building representation
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFF87CEEB), // Sky blue
                              Color(0xFF4682B4), // Steel blue
                            ],
                          ),
                        ),
                        child: Stack(
                          children: [
                            // Buildings silhouette
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              height: 120,
                              child: Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0xFFB22222), // Brick red
                                      Color(0xFF8B1538), // Dark red
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // Central tower
                            Positioned(
                              bottom: 0,
                              left: 140,
                              width: 95,
                              height: 180,
                              child: Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0xFF4682B4), // Glass blue
                                      Color(0xFF2F4F4F), // Dark slate
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // Windows pattern
                            ...List.generate(
                              8,
                              (i) => Positioned(
                                bottom: 20 + (i * 15),
                                left: 150 + (i % 2) * 40,
                                width: 25,
                                height: 8,
                                child: Container(
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // Circular logo with animated scale
          AnimatedBuilder(
            animation: _logoScale,
            builder: (context, child) {
              return Positioned(
                top: 360, // Figma: y: 360
                left: screenWidth / 2 - 40, // Center horizontally
                child: Transform.scale(
                  scale: _logoScale.value,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      color: Color(0xff85F0F7),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          color: Color(0xff2C2C2E),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            _getUniversityLogo(),
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: Colors.white,
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

          // Login content with fade animation
          AnimatedBuilder(
            animation: _contentFade,
            builder: (context, child) {
              return Opacity(
                opacity: _contentFade.value,
                child: Positioned(
                  top: 483, // Figma: y: 483
                  left: 21, // Figma: x: 21
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
                      const SizedBox(height: 40), // Figma spacing
                      // Email field (read-only display)
                      if (_email != null) ...[
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
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(bottom: 8),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xff85F0F7),
                                width: 1,
                              ),
                            ),
                          ),
                          child: Text(
                            _email!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],

                      // Password field (appears after tapping login button)
                      if (_showPasswordField) ...[
                        const Text(
                          'Password',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xff85F0F7),
                                width: 1,
                              ),
                            ),
                          ),
                          child: Row(
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
                                    contentPadding: EdgeInsets.only(bottom: 8),
                                    hintText: '••••••••••••',
                                    hintStyle: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.visibility_off,
                                  color: Colors.white54,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],

                      // Login button
                      SizedBox(
                        width: double.infinity,
                        child: Container(
                          height: 52,
                          decoration: BoxDecoration(
                            color: const Color(0xff85F0F7),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: _showPasswordField
                                  ? _login
                                  : _showPasswordInput,
                              child: const Center(
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
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // Wave design at bottom - positioned as per Figma
          Positioned(
            left: -23, // Figma: x: -23
            top: 673, // Figma: y: 673
            width: 511.987, // Figma width
            height: 272.812, // Figma height
            child: CustomPaint(
              painter: _WavePainter(),
              size: const Size(511.987, 272.812),
            ),
          ),
        ],
      ),
    );
  }
}

class _DiagonalImageClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // Create dramatic diagonal perspective effect matching the Figma design exactly
    // The university building has a strong diagonal cut from top-right to bottom-left
    path.moveTo(0, 0); // Start at top-left corner
    path.lineTo(size.width, 0); // Go across full width at top

    // Create the dramatic diagonal cut that matches Figma
    // The right side goes down much further than the left side
    path.lineTo(
      size.width,
      size.height * 0.85,
    ); // Right side goes down 85% of height

    // Create smooth diagonal line to left side
    // Left side should end much higher (around 45% height) to create strong perspective
    path.lineTo(0, size.height * 0.45); // Left side ends at 45% height

    // Close the path back to start
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

    // Create wave shape matching Figma Vector 18 exactly
    // This is positioned at left: -23, top: 673, width: 511.987, height: 272.812
    path.moveTo(0, size.height * 0.3); // Start from left side, about 1/3 down

    // Create smooth wave curves
    path.quadraticBezierTo(
      size.width * 0.2,
      size.height * 0.15, // First control point - curve up
      size.width * 0.4,
      size.height * 0.25, // First end point
    );
    path.quadraticBezierTo(
      size.width * 0.6,
      size.height * 0.35, // Second control point
      size.width * 0.8,
      size.height * 0.2, // Second end point
    );
    path.quadraticBezierTo(
      size.width * 0.9,
      size.height * 0.1, // Third control point - curve up more
      size.width,
      0, // End at top right
    );

    // Complete the shape
    path.lineTo(size.width, size.height); // Go to bottom right
    path.lineTo(0, size.height); // Go to bottom left
    path.close(); // Close the path

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
