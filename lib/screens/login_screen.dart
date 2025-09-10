import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'login_transition_screen.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _submitted = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _continue() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _submitted = true);
      Future.delayed(400.ms, () {
        Navigator.of(context).pushNamed(
          LoginTransitionScreen.routeName,
          arguments: _emailController.text.trim(),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff2C2C2E), // Dark theme from Figma
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 21),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.25),
                  // Company logo section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logomark (circular dots)
                      Container(
                        width: 38,
                        height: 48,
                        decoration: const BoxDecoration(
                          color: Color(0xff85F0F7),
                        ),
                        child: CustomPaint(painter: _LogomarkPainter()),
                      ),
                      const SizedBox(width: 10),
                      // Logotext
                      const Text(
                        'Kampus Hall',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Color(0xffEFEFEF),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(duration: 800.ms),
                  const SizedBox(height: 133), // 332 - 199 = 133
                  // Login title
                  const Text(
                    'Login',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Color(0xffEFEFEF),
                    ),
                  ).animate().fadeIn(duration: 600.ms, delay: 200.ms),
                  const SizedBox(height: 60), // 392 - 332 = 60
                  // Email input section
                  const Text(
                    'Enter Email Address',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ).animate().fadeIn(duration: 600.ms, delay: 400.ms),
                  const SizedBox(height: 8),
                  // Email input field with underline
                  Column(
                        children: [
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(bottom: 8),
                              hintText: 'your.email@university.edu.pk',
                              hintStyle: TextStyle(
                                color: Colors.white54,
                                fontSize: 16,
                              ),
                            ),
                            validator: (v) {
                              if (v == null || v.trim().isEmpty)
                                return 'Enter email';
                              if (!v.contains('@')) return 'Invalid email';
                              return null;
                            },
                            onFieldSubmitted: (_) => _continue(),
                          ),
                          // Underline
                          Container(
                            height: 1,
                            width: 332.5,
                            color: const Color(0xff85F0F7),
                          ),
                        ],
                      )
                      .animate(target: _submitted ? 1 : 0)
                      .shimmer(duration: 1.seconds)
                      .animate()
                      .fadeIn(duration: 600.ms, delay: 600.ms),
                  const SizedBox(height: 43), // 459 - 416 = 43
                  // Login button
                  Container(
                        width: 332,
                        height: 52,
                        decoration: BoxDecoration(
                          color: const Color(0xff85F0F7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: _submitted ? null : _continue,
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
                      )
                      .animate()
                      .slideY(
                        begin: 0.4,
                        end: 0,
                        duration: 500.ms,
                        curve: Curves.easeOut,
                        delay: 800.ms,
                      )
                      .fadeIn(delay: 800.ms),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LogomarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xff2C2C2E)
      ..style = PaintingStyle.fill;

    // Draw the dot pattern to create the logomark
    final dotRadius = 3.0;
    final spacing = 8.0;

    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 4; j++) {
        final x = 6 + (i * spacing);
        final y = 6 + (j * spacing);
        canvas.drawCircle(Offset(x, y), dotRadius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
