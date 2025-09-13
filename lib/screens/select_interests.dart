import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:kampus_hall_3/screens/select_interests_screen.dart';

class SelectInterests extends StatefulWidget {
  static const routeName = '/select-interests-original';
  const SelectInterests({super.key});

  @override
  State<SelectInterests> createState() => _SelectInterestsState();
}

class _SelectInterestsState extends State<SelectInterests>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _imageScale;
  late final Animation<double> _contentFade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: 1500.ms)
      ..forward();

    _imageScale = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0, 0.6, curve: Curves.elasticOut),
    );

    _contentFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.4, 1, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _selectInterests() {
    // Handle select interests functionality

    Navigator.of(context).pushNamed(SelectInterestsScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff2C2C2E), // Grey 5/Dark from Figma
      body: SafeArea(
        child: Stack(
          children: [
            // Background decorative vector (positioned as per Figma)
            Positioned(
              left: 78,
              top: -291,
              child: Container(
                width: 594,
                height: 565,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.02),
                    borderRadius: BorderRadius.circular(300),
                  ),
                ),
              ),
            ),

            // Main content
            Column(
              children: [
                const SizedBox(height: 50), // Top spacing from Figma
                // Large circular image container (exact Figma dimensions)
                AnimatedBuilder(
                  animation: _imageScale,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _imageScale.value,
                      child: Container(
                        width: 281, // Figma: width: 281px
                        height:
                            287, // Figma: height: 287px (note: slightly taller than width)
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFFF0F0F0,
                          ), // Placeholder background
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Container(
                            color: const Color(0xFFF0F0F0),
                            child: Center(
                              child: Image.asset(
                                "assets/images/Select_Interests.png",
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(
                  height: 60,
                ), // Space between image and title (from Figma positioning)
                // Title with fade animation
                AnimatedBuilder(
                  animation: _contentFade,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _contentFade.value,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 49),
                        child: Text(
                          'Select Your Interests',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            fontSize: 27, // Figma: text-[27px]
                            color: Color(0xffEFEFEF), // White from Figma
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(
                  height: 25,
                ), // Space from Figma (504.76 - 452 = ~52, minus title height)
                // Decorative line with rotation (as per Figma)
                AnimatedBuilder(
                  animation: _contentFade,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _contentFade.value,
                      child: Transform.rotate(
                        angle:
                            0.31 * (3.14159 / 180), // 0.31 degrees in radians
                        child: Container(
                          width: 136.003, // Figma: w-[136.003px]
                          height: 0.738, // Figma: h-[0.738px]
                          decoration: BoxDecoration(
                            color: const Color(0xff85F0F7),
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(
                  height: 27,
                ), // Space from Figma (532 - 504.76 = ~27)
                // Description text with fade animation
                AnimatedBuilder(
                  animation: _contentFade,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _contentFade.value,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 56,
                        ), // Center align with 256px width
                        child: Text(
                          'Please Select All Your Interests, so you can be recommended courses/events based on it!',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.normal,
                            fontSize: 13, // Figma: text-[13px]
                            color: Color(0xffEFEFEF),
                            height: 1.4, // Line height for better readability
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                ),

                const Spacer(), // Push button to bottom
                // Select button with fade animation (exact Figma positioning)
                AnimatedBuilder(
                  animation: _contentFade,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _contentFade.value,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 80,
                        ), // Center with 221px width
                        child: Container(
                          width: 221, // Figma: w-[221px]
                          height: 52, // Figma: h-[52px]
                          decoration: BoxDecoration(
                            color: const Color(
                              0xff85F0F7,
                            ), // Cyan color from Figma
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: _selectInterests,
                              child: const Center(
                                child: Text(
                                  'Select',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20, // Figma: text-[20px]
                                    color: Colors.black,
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

                const SizedBox(
                  height: 60,
                ), // Bottom spacing from Figma (812 - 692 - 52 = 68)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
