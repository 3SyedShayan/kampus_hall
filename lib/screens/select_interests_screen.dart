import 'package:flutter/material.dart';
import 'main_navigation_screen.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SelectInterestsScreen extends StatefulWidget {
  static const routeName = '/select-interests';
  const SelectInterestsScreen({super.key});

  @override
  State<SelectInterestsScreen> createState() => _SelectInterestsScreenState();
}

class _SelectInterestsScreenState extends State<SelectInterestsScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _contentFade;

  // Available interests from Figma design
  final List<String> availableInterests = [
    'ARTIFICIAL INTELLIGENCE',
    'LITERATURE',
    'FASHION',
    'ROBOTICS',
    'PHOTOGRAPHY',
    'GRAPHICS DESIGNING',
    'FIRST AID',
    'PUBLIC SPEAKING',
    'VISUAL ARTS',
    'SPORTS',
    'PERFORMING ARTS',
    'TECHNOLOGY',
    'FINANCE & INVESTMENT',
    'FOOD',
    'MEDICAL CONFERENCES',
    'STARTUPS',
    'VOLUNTEERING & SOCIAL IMPACT',
  ];

  // Track selected interests
  Set<String> selectedInterests = {};

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: 1000.ms)
      ..forward();

    _contentFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 1, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _selectInterests() {
    if (selectedInterests.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select at least one interest'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Selected ${selectedInterests.length} interests successfully!',
        ),
        backgroundColor: const Color(0xff85F0F7),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    // Navigate to main navigation screen after successful selection
    Future.delayed(const Duration(milliseconds: 1500), () {
      Navigator.pushNamedAndRemoveUntil(
        context,
        MainNavigationScreen.routeName,
        (route) => false,
      );
    });
  }

  void _toggleInterest(String interest) {
    setState(() {
      if (selectedInterests.contains(interest)) {
        selectedInterests.remove(interest);
      } else {
        selectedInterests.add(interest);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff2C2C2E), // Grey 5/Dark from Figma
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 80), // Top spacing
              // Title with fade animation
              AnimatedBuilder(
                animation: _contentFade,
                builder: (context, child) {
                  return Opacity(
                    opacity: _contentFade.value,
                    child: const Text(
                      'Select Your Interests',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: 27, // Figma: text-[27px]
                        color: Color(0xffEFEFEF), // White from Figma
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              // Decorative line
              AnimatedBuilder(
                animation: _contentFade,
                builder: (context, child) {
                  return Opacity(
                    opacity: _contentFade.value,
                    child: Container(
                      width: 136, // Figma: w-[136.003px]
                      height: 2,
                      decoration: BoxDecoration(
                        color: const Color(0xff85F0F7),
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 40),
              Expanded(
                child: AnimatedBuilder(
                  animation: _contentFade,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _contentFade.value,
                      child: SingleChildScrollView(
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 12,
                          children: availableInterests.map((interest) {
                            final isSelected = selectedInterests.contains(
                              interest,
                            );
                            return GestureDetector(
                              onTap: () => _toggleInterest(interest),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xff85F0F7).withOpacity(0.3)
                                      : Colors.white.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(100),
                                  border: isSelected
                                      ? Border.all(
                                          color: const Color(0xff85F0F7),
                                          width: 2,
                                        )
                                      : null,
                                ),
                                child: Text(
                                  interest,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: isSelected
                                        ? const Color(0xff85F0F7)
                                        : Colors.white,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Select button with fade animation
              AnimatedBuilder(
                animation: _contentFade,
                builder: (context, child) {
                  return Opacity(
                    opacity: _contentFade.value,
                    child: Container(
                      width: 221, // Figma: w-[221px]
                      height: 52, // Figma: h-[52px]
                      decoration: BoxDecoration(
                        color: const Color(0xff85F0F7), // Cyan color from Figma
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
                  );
                },
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
