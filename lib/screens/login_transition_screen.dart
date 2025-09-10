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
      if (args != null && args is String) {
        setState(() {
          _email = args;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
    final imagePath = _getUniversityImage();
    final width = MediaQuery.of(context).size.width;
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
                      width: width,
                      height:
                          250, // Much taller to match Figma - university image dominates the screen
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(imagePath),
                          fit: BoxFit.cover,
                          onError: (exception, stackTrace) {},
                        ),
                      ),
                      // Fallback: Create university building matching Figma design
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFF87CEEB), // Sky blue background
                              Color(0xFF4A90E2), // Lighter blue at bottom
                            ],
                          ),
                        ),
                        child: Stack(
                          children: [
                            // Left red brick building
                            Positioned(
                              bottom: 0,
                              left: 0,
                              width: 150,
                              height: 300,
                              child: Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFFD2691E), // Sandy brown
                                      Color(0xFF8B4513), // Saddle brown
                                    ],
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    // Windows rows for left building
                                    for (int row = 0; row < 12; row++)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 4,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            for (int col = 0; col < 4; col++)
                                              Container(
                                                width: 12,
                                                height: 8,
                                                color: Colors.white.withOpacity(
                                                  0.9,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),

                            // Central blue glass tower (matches Figma)
                            Positioned(
                              bottom: 0,
                              left: 150,
                              width: 75,
                              height: 380,
                              child: Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFF1E90FF), // Dodger blue
                                      Color(0xFF4169E1), // Royal blue
                                    ],
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    // Glass panels pattern
                                    for (int i = 0; i < 20; i++)
                                      Container(
                                        margin: const EdgeInsets.all(1),
                                        height: 15,
                                        color: Colors.white.withOpacity(0.7),
                                      ),
                                  ],
                                ),
                              ),
                            ),

                            // Right red brick building
                            Positioned(
                              bottom: 0,
                              right: 0,
                              width: 150,
                              height: 300,
                              child: Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFFD2691E), // Sandy brown
                                      Color(0xFF8B4513), // Saddle brown
                                    ],
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    // Windows rows for right building
                                    for (int row = 0; row < 12; row++)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 4,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            for (int col = 0; col < 4; col++)
                                              Container(
                                                width: 12,
                                                height: 8,
                                                color: Colors.white.withOpacity(
                                                  0.9,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                  ],
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
                top: 350, // Position logo much lower on the image area
                left: 150, // Figma: x: 150
                child: Transform.scale(
                  scale: _logoScale.value,
                  child: Container(
                    width: 75, // Figma: width: 75
                    height: 75, // Figma: height: 75
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

          // Login title positioned exactly as in Figma
          Positioned(
            top: 312, // Figma: top: 312px
            left: 21, // Figma: left: 21px
            child: AnimatedBuilder(
              animation: _contentFade,
              builder: (context, child) {
                return Opacity(
                  opacity: _contentFade.value,
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Color(0xffEFEFEF),
                    ),
                  ),
                );
              },
            ),
          ),

          // Email 365 field - positioned exactly as in Figma
          Positioned(
            top: 374, // Figma: calc(50% - 14px) ≈ 374px for 812px screen height
            left: 21, // Figma: calc(50% - 166.5px) ≈ 21px for 375px screen width
            child: AnimatedBuilder(
              animation: _contentFade,
              builder: (context, child) {
                return Opacity(
                  opacity: _contentFade.value,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                        width: 332.5, // Figma width
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
                          _email ?? 'your.email@university.edu.pk',
                          style: TextStyle(
                            color: _email != null ? Colors.white : Colors.white54,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Password field - positioned exactly as in Figma
          Positioned(
            top: 454, // Figma: calc(50% + 66px) ≈ 454px for 812px screen height
            left: 21, // Figma: calc(50% - 166.5px) ≈ 21px for 375px screen width
            child: AnimatedBuilder(
              animation: _contentFade,
              builder: (context, child) {
                return Opacity(
                  opacity: _contentFade.value,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Password',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Color(0xffEFEFEF),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 332.5, // Figma width
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
                            Expanded(
                              child: TextField(
                                obscureText: true,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                                decoration: const InputDecoration(
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
                            // Show/hide icon positioned as in Figma
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
                    ],
                  ),
                );
              },
            ),
          ),

          // Login button positioned exactly as in Figma
          Positioned(
            top: 539, // Figma: top: 539px
            left: 21, // Figma: left: 21px
            child: AnimatedBuilder(
              animation: _contentFade,
              builder: (context, child) {
                return Opacity(
                  opacity: _contentFade.value,
                  child: Container(
                    width: 332, // Figma: width: 332px
                    height: 52, // Figma: height: 52px
                    decoration: BoxDecoration(
                      color: const Color(0xff85F0F7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: _login,
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
                );
              },
            ),
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
    Path path = Path();
    path.moveTo(0, 0); // top-left
    path.lineTo(size.width, 0); // top-right
    path.lineTo(size.width, 100); // 100px below top-right
    path.lineTo(0, size.height); // bottom-left
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
// class _DiagonalImageClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     final path = Path();

//     // The Figma design shows the university image covering most of the screen
//     // with just a SUBTLE diagonal cut at the bottom where it meets the dark area
//     path.moveTo(0, 0); // Start at top-left corner
//     path.lineTo(size.width, 0); // Go across full width at top
//     path.lineTo(
//       size.width,
//       size.height * 0.85,
//     ); // Right side - most of the height

//     // Very subtle diagonal cut at bottom - not a dramatic perspective effect
//     path.quadraticBezierTo(
//       size.width * 0.7,
//       size.height * 0.88, // Slight curve
//       0,
//       size.height * 0.82, // Left side ends slightly higher
//     );

//     // Close the path back to start
//     path.close();

//     return path;
//   }

//   @override
//   bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
// }

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
