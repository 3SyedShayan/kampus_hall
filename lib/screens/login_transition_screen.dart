import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:kampus_hall_3/screens/select_interests.dart';

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
    // Navigate to Select Interests screen
    Navigator.of(context).pushNamed(SelectInterests.routeName);
  }

  String _getUniversityImage() {
    if (_email == null) return 'assets/images/nust_cover.jpg';
    final lower = _email!.toLowerCase();
    if (lower.endsWith('@nust.edu.pk')) return 'assets/images/nust_cover.jpg';
    if (lower.endsWith('@fast.edu.pk')) return 'assets/images/fast_cover.jpg';
    return 'assets/images/nust_cover.jpg';
  }

  String _getUniversityLogo() {
    if (_email == null) return 'assets/images/logo.png';
    final lower = _email!.toLowerCase();
    if (lower.endsWith('@nust.edu.pk')) return 'assets/images/nust_logo.png';
    if (lower.endsWith('@fast.edu.pk')) return 'assets/images/fast_logo.png';
    return 'assets/images/logo.png';
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
                          onError: (exception, stackTrace) {
                            // Image failed to load, show fallback
                          },
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
                top: 175, // Position logo much lower on the image area
                left: width / 2 - 50, // Center the logo horizontally
                child: Transform.scale(
                  scale: _logoScale.value,
                  child: Center(
                    child: CircleAvatar(
                      radius:
                          50, // Set radius to accommodate your desired image size
                      backgroundColor: const Color.fromARGB(255, 51, 74, 75),
                      child: Image.asset(
                        _getUniversityLogo(),
                        width:
                            100, // Set both width and height for better control
                        height: 100,
                        fit: BoxFit
                            .contain, // Use contain to maintain aspect ratio
                      ),

                      //   Text(
                      //     _getUniversityLogo(),
                      //     style: const TextStyle(
                      //       fontFamily: 'Inter',
                      //       fontWeight: FontWeight.bold,
                      //       fontSize: 24,
                      //       color: Colors.white,
                      //     ),
                      //   ),
                      // ),
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
            left:
                21, // Figma: calc(50% - 166.5px) ≈ 21px for 375px screen width
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
                            color: _email != null
                                ? Colors.white
                                : Colors.white54,
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
            left:
                21, // Figma: calc(50% - 166.5px) ≈ 21px for 375px screen width
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
    path.lineTo(size.width, 220); // 220px below top-right
    path.lineTo(0, size.height); // bottom-left
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
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
