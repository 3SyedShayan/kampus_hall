import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';
import '../models/society.dart';
import '../services/society_service.dart';
import '../services/story_service.dart';
import '../models/story.dart';
import 'society_chat_screen.dart';
import 'story_viewer_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;

  // Society service instance
  final SocietyService _societyService = SocietyService();
  final StoryService _storyService = StoryService();

  // Dynamic societies data
  List<Society> _allSocieties = [];
  List<StoryGroup> _storyGroups = [];

  // Event state management
  Set<String> _joinedEvents = {};
  int _eventsToAttend = 1; // Initial counter value

  // Comprehensive dummy data for events in "Happening Today"
  final List<Map<String, dynamic>> events = [
    {
      'title': 'Around the World Explorer Series',
      'color': const Color(0xff64FCD9),
      'description':
          'Embark on a virtual journey across continents and cultures. Wear your explorer\'s helmet and be prepared to fly to exciting and exotic locations with renowned travel expert Noor Syeda. Discover hidden gems, learn about diverse traditions, and expand your global perspective through immersive storytelling and interactive experiences.',
      'image': 'assets/images/vectors/read.png',
      'date': '2ND MARCH, 3:30 PM',
      'headlines': [
        {
          'icon': Icons.location_on,
          'text': 'The European Capitals',
          'color': const Color(0xff64FCD9),
        },
        {
          'icon': Icons.terrain,
          'text': 'Hidden Mountain Villages',
          'color': const Color(0xff64FCD9),
        },
        {
          'icon': Icons.local_dining,
          'text': 'Street Food Adventures',
          'color': const Color(0xff64FCD9),
        },
      ],
    },
    {
      'title': 'Advanced Chemistry Laboratory',
      'color': const Color(0xffFF6B6B),
      'description':
          'Dive deep into the fascinating world of chemical reactions and molecular structures. This hands-on session combines theoretical knowledge with practical experiments, covering organic synthesis, analytical techniques, and modern laboratory methods. Perfect for students passionate about chemistry and scientific discovery.',
      'image': 'assets/images/vectors/chemistry.png',
      'date': '3RD MARCH, 2:00 PM',
      'headlines': [
        {
          'icon': Icons.science,
          'text': 'Organic Synthesis Workshop',
          'color': const Color(0xffFF6B6B),
        },
        {
          'icon': Icons.analytics,
          'text': 'Spectroscopy Techniques',
          'color': const Color(0xffFF6B6B),
        },
        {
          'icon': Icons.local_fire_department,
          'text': 'Safety Protocols & Best Practices',
          'color': const Color(0xffFF6B6B),
        },
      ],
    },
    {
      'title': 'Mathematics Masterclass',
      'color': const Color(0xff4ECDC4),
      'description':
          'Unlock the power of advanced mathematical concepts through innovative teaching methods. From calculus to linear algebra, this comprehensive session covers problem-solving strategies, real-world applications, and exam preparation techniques. Led by top mathematics faculty with interactive problem-solving sessions.',
      'image': 'assets/images/vectors/puzzle.png',
      'date': '4TH MARCH, 4:00 PM',
      'headlines': [
        {
          'icon': Icons.calculate,
          'text': 'Calculus Problem Solving',
          'color': const Color(0xff4ECDC4),
        },
        {
          'icon': Icons.functions,
          'text': 'Linear Algebra Applications',
          'color': const Color(0xff4ECDC4),
        },
        {
          'icon': Icons.trending_up,
          'text': 'Statistics & Data Analysis',
          'color': const Color(0xff4ECDC4),
        },
      ],
    },
    {
      'title': 'Biology Research Symposium',
      'color': const Color(0xffFFE66D),
      'description':
          'Explore the intricate mechanisms of life through cutting-edge biological research. This session covers cellular biology, genetics, ecology, and biotechnology applications. Featuring guest researchers, interactive microscopy sessions, and discussions on current biological discoveries and their impact on medicine and environment.',
      'image': 'assets/images/vectors/find.png',
      'date': '5TH MARCH, 1:30 PM',
      'headlines': [
        {
          'icon': Icons.biotech,
          'text': 'CRISPR Gene Editing',
          'color': const Color(0xffFFE66D),
        },
        {
          'icon': Icons.eco,
          'text': 'Ecosystem Conservation',
          'color': const Color(0xffFFE66D),
        },
        {
          'icon': Icons.medical_services,
          'text': 'Medical Biotechnology',
          'color': const Color(0xffFFE66D),
        },
      ],
    },
    {
      'title': 'Digital Innovation Workshop',
      'color': const Color(0xff9B59B6),
      'description':
          'Step into the future of technology with hands-on workshops covering AI, machine learning, and digital transformation. Learn about emerging technologies, their applications in various industries, and how to leverage them for innovation. Includes coding sessions, project demonstrations, and networking with industry professionals.',
      'image': 'assets/images/vectors/clock.png',
      'date': '6TH MARCH, 10:00 AM',
      'headlines': [
        {
          'icon': Icons.computer,
          'text': 'AI & Machine Learning',
          'color': const Color(0xff9B59B6),
        },
        {
          'icon': Icons.code,
          'text': 'Full-Stack Development',
          'color': const Color(0xff9B59B6),
        },
        {
          'icon': Icons.cloud,
          'text': 'Cloud Computing Solutions',
          'color': const Color(0xff9B59B6),
        },
      ],
    },
    {
      'title': 'Creative Arts & Design Studio',
      'color': const Color(0xffE74C3C),
      'description':
          'Unleash your artistic potential through comprehensive creative workshops covering digital design, traditional arts, and multimedia production. Learn from professional artists and designers, explore various mediums, and create portfolio-worthy projects. Perfect for both beginners and advanced artists looking to expand their skills.',
      'image': 'assets/images/vectors/music.png',
      'date': '7TH MARCH, 3:00 PM',
      'headlines': [
        {
          'icon': Icons.brush,
          'text': 'Digital Illustration Techniques',
          'color': const Color(0xffE74C3C),
        },
        {
          'icon': Icons.video_camera_back,
          'text': 'Video Production Workshop',
          'color': const Color(0xffE74C3C),
        },
        {
          'icon': Icons.palette,
          'text': 'Color Theory & Composition',
          'color': const Color(0xffE74C3C),
        },
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: 800.ms)..forward();

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    // Load society and story data
    _loadSocietyData();
    _loadStoryData();
  }

  void _loadSocietyData() {
    setState(() {
      _allSocieties = _societyService.getAllSocieties();
    });
  }

  void _loadStoryData() {
    setState(() {
      _storyGroups = _storyService.getAllStoryGroups();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff2C2C2E), // Grey 5/Dark from Figma
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _fadeAnimation,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // Header with event notification
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'You have $_eventsToAttend Event${_eventsToAttend != 1 ? 's' : ''} to Attend today',
                              style: const TextStyle(
                                fontFamily: 'Albert Sans',
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: Colors.white,
                                height: 1.27, // 28/22
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: const Text(
                              '3:30 PM',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Colors.white,
                                height: 1.29, // 22/17
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 42),

                    // Stories Section
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'STORIES',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: Color(0xffE5E5EA),
                                  height: 1.38, // 18/13
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 15),
                                child: const Text(
                                  'See all →',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13,
                                    color: Color(0xffE5E5EA),
                                    height: 1.38, // 18/13
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 98,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.only(right: 15),
                              itemCount: _storyGroups.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(width: 15),
                              itemBuilder: (context, index) {
                                final storyGroup = _storyGroups[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      StoryViewerScreen.routeName,
                                      arguments: {
                                        'groupId': storyGroup.groupId,
                                      },
                                    ).then((_) {
                                      // Refresh story data when returning from story viewer
                                      _loadStoryData();
                                    });
                                  },
                                  child: Container(
                                    width: 90,
                                    height: 98,
                                    decoration: BoxDecoration(
                                      color: const Color(0xff3A3A3C),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: storyGroup.color,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color:
                                                  storyGroup.hasUnviewedStories
                                                  ? const Color(
                                                      0xff85F0F7,
                                                    ) // Cyan for unviewed
                                                  : const Color(
                                                      0xff48484A,
                                                    ), // Gray for viewed
                                              width:
                                                  storyGroup.hasUnviewedStories
                                                  ? 3
                                                  : 2,
                                            ),
                                          ),
                                          child: storyGroup.imageUrl != null
                                              ? ClipOval(
                                                  child: Image.asset(
                                                    storyGroup.imageUrl!,
                                                    width: 46,
                                                    height: 46,
                                                    fit: BoxFit.cover,
                                                    errorBuilder:
                                                        (
                                                          context,
                                                          error,
                                                          stackTrace,
                                                        ) {
                                                          // Fallback to icon if image fails to load
                                                          return Icon(
                                                            storyGroup.icon,
                                                            color: Colors.white,
                                                            size: 24,
                                                          );
                                                        },
                                                  ),
                                                )
                                              : Icon(
                                                  storyGroup.icon,
                                                  color: Colors.white,
                                                  size: 24,
                                                ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          storyGroup.groupTitle,
                                          style: const TextStyle(
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.normal,
                                            fontSize: 15,
                                            color: Colors.white,
                                            height: 1.33, // 20/15
                                          ),
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 42),

                    // Societies & Groups Section
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'SOCIETIES & GROUPS',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Color(0xffE5E5EA),
                              height: 1.38, // 18/13
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 175,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.only(right: 15),
                              itemCount: _allSocieties.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(width: 15),
                              itemBuilder: (context, index) {
                                final society = _allSocieties[index];
                                final isJoined = _societyService
                                    .isMemberOfSociety(society.id);
                                return SizedBox(
                                  width: 227,
                                  height: 175,
                                  child: Stack(
                                    children: [
                                      // Society card (shorter height) - clickable if joined
                                      GestureDetector(
                                        onTap: isJoined
                                            ? () {
                                                Navigator.of(context).pushNamed(
                                                  SocietyChatScreen.routeName,
                                                  arguments: {
                                                    'societyId': society.id,
                                                    'societyTitle':
                                                        society.title,
                                                    'societyColor':
                                                        society.color,
                                                  },
                                                );
                                              }
                                            : null,
                                        child: Container(
                                          width: 227,
                                          height:
                                              156, // 175 - 19 = 156 (leaving space for button)
                                          decoration: BoxDecoration(
                                            color: society.color,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            // Enhanced visual indicator for joined societies
                                            border: isJoined
                                                ? Border.all(
                                                    color: const Color(
                                                      0xff85F0F7,
                                                    ), // Brand cyan color
                                                    width: 3,
                                                  )
                                                : Border.all(
                                                    color: Colors.white
                                                        .withOpacity(0.1),
                                                    width: 1,
                                                  ),
                                            // Add subtle shadow for joined societies
                                            boxShadow: isJoined
                                                ? [
                                                    BoxShadow(
                                                      color: const Color(
                                                        0xff85F0F7,
                                                      ).withOpacity(0.3),
                                                      blurRadius: 8,
                                                      spreadRadius: 1,
                                                      offset: const Offset(
                                                        0,
                                                        2,
                                                      ),
                                                    ),
                                                  ]
                                                : null,
                                          ),
                                          child: Stack(
                                            children: [
                                              // Society title
                                              Positioned(
                                                left: 15,
                                                top: 20,
                                                child: SizedBox(
                                                  width: 151,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        society.title,
                                                        style: const TextStyle(
                                                          fontFamily:
                                                              'Albert Sans',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 22,
                                                          color: Colors.white,
                                                          height: 1.27, // 28/22
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        society.subtitle,
                                                        style: TextStyle(
                                                          fontFamily: 'Inter',
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 12,
                                                          color: Colors.white
                                                              .withOpacity(0.8),
                                                          height: 1.33, // 16/12
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              // Decorative elements
                                              Positioned(
                                                right: -20,
                                                top: 20,
                                                child: Container(
                                                  width: 120,
                                                  height: 120,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white
                                                        .withOpacity(0.1),
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                              ),
                                              // Joined indicator
                                              if (isJoined)
                                                Positioned(
                                                  right: 10,
                                                  top: 10,
                                                  child: Container(
                                                    width: 24,
                                                    height: 24,
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                        0xff85F0F7,
                                                      ),
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        color: Colors.white,
                                                        width: 2,
                                                      ),
                                                    ),
                                                    child: const Icon(
                                                      Icons.check,
                                                      size: 14,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      // Join button hanging outside the card
                                      Positioned(
                                        left: 15,
                                        top:
                                            103, // This positions it to hang outside
                                        child: GestureDetector(
                                          onTap: () async {
                                            final societyTitle = society.title;
                                            final societyId = society.id;

                                            if (isJoined) {
                                              // Leave the society
                                              final success =
                                                  await _societyService
                                                      .leaveSociety(societyId);
                                              if (success) {
                                                _loadSocietyData(); // Refresh data
                                                if (mounted) {
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Left $societyTitle',
                                                      ),
                                                      duration: const Duration(
                                                        seconds: 2,
                                                      ),
                                                    ),
                                                  );
                                                }
                                              }
                                            } else {
                                              // Join the society
                                              final success =
                                                  await _societyService
                                                      .joinSociety(societyId);
                                              if (success) {
                                                _loadSocietyData(); // Refresh data
                                                if (mounted) {
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        '$societyTitle has been joined!',
                                                      ),
                                                      duration: const Duration(
                                                        seconds: 2,
                                                      ),
                                                    ),
                                                  );
                                                }
                                              }
                                            }
                                          },
                                          child: Container(
                                            width: 72,
                                            height: 72,
                                            decoration: BoxDecoration(
                                              color: Color.lerp(
                                                society.color,
                                                Colors.white,
                                                0.6, // 60% lighter than the card color
                                              ), // Lighter version of card color
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: const Color(
                                                  0xFF2C2C2E,
                                                ), // Dark outer border
                                                width: 1,
                                              ),
                                            ),
                                            child: Center(
                                              child: Container(
                                                width:
                                                    58, // Slightly smaller to show the light ring
                                                height: 58,
                                                decoration: BoxDecoration(
                                                  color: society
                                                      .color, // Card color for inner circle
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: const Color(
                                                      0xFF2C2C2E,
                                                    ), // Black border between light and background color
                                                    width: 1,
                                                  ),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    isJoined
                                                        ? 'JOINED'
                                                        : 'JOIN',
                                                    style: const TextStyle(
                                                      fontFamily: 'Inter',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 13,
                                                      color: Colors.white,
                                                      height: 1.38, // 18/13
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Happening Today Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'HAPPENING TODAY!',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Color(0xffE5E5EA),
                              height: 1.38, // 18/13
                            ),
                          ),
                          const SizedBox(height: 10),
                          // New layout based on Figma design
                          Column(
                            children: [
                              // Row 1: How to Read? + Material in Industry
                              Row(
                                children: [
                                  // How to Read? card (left, height 236)
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        _showEventModal(context, events[0]);
                                      },
                                      child: Container(
                                        height: 265,
                                        margin: const EdgeInsets.only(
                                          right: 15,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(
                                            0xFFFF8C82,
                                          ), // Peach
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Stack(
                                          children: [
                                            // Image positioned right and centered
                                            Positioned(
                                              right: -43,
                                              top: 63,
                                              child: SizedBox(
                                                width: 175,
                                                height: 175,
                                                child: Image.asset(
                                                  'assets/images/vectors/read.png',
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                            // Title
                                            Positioned(
                                              left: 15,
                                              top: 19,
                                              child: SizedBox(
                                                width: 115,
                                                child: Text(
                                                  events[0]['title'],
                                                  style: const TextStyle(
                                                    fontFamily: 'Albert Sans',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 22,
                                                    color: Colors.white,
                                                    height: 1.27, // 28/22
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // Date badge at bottom
                                            Positioned(
                                              left: 9,
                                              bottom: 10,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: Colors.white
                                                      .withOpacity(0.32),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        100,
                                                      ),
                                                ),
                                                child: const Text(
                                                  '3 MAY',
                                                  style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                    color: Colors.white,
                                                    height: 1.38, // 18/13
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Material in Industry card (right, height 271)
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        _showEventModal(context, events[1]);
                                      },
                                      child: Container(
                                        height: 271,
                                        decoration: BoxDecoration(
                                          color: const Color(
                                            0xFFEE719E,
                                          ), // Pink
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Stack(
                                          children: [
                                            // Image positioned right and top
                                            Positioned(
                                              right: -30,
                                              top: 60,
                                              child: SizedBox(
                                                width: 202,
                                                height: 202,
                                                child: Image.asset(
                                                  'assets/images/vectors/chemistry.png',
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                            // Title at top
                                            Positioned(
                                              left: 15,
                                              top: 20,
                                              child: SizedBox(
                                                width: 115,
                                                child: Text(
                                                  events[1]['title'],
                                                  style: const TextStyle(
                                                    fontFamily: 'Albert Sans',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 22,
                                                    color: Colors.white,
                                                    height: 1.27, // 28/22
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // Diamond badge at bottom
                                            Positioned(
                                              left: 15,
                                              bottom: 20,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: Colors.white
                                                      .withOpacity(0.32),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        100,
                                                      ),
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      width: 16,
                                                      height: 16,
                                                      decoration:
                                                          const BoxDecoration(
                                                            color: Colors.white,
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                      child: const Icon(
                                                        Icons.diamond,
                                                        size: 10,
                                                        color: Color(
                                                          0xFFEE719E,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 4),
                                                    const Text(
                                                      '5',
                                                      style: TextStyle(
                                                        fontFamily: 'Inter',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 13,
                                                        color: Colors.white,
                                                        height: 1.38, // 18/13
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
                                ],
                              ),
                              const SizedBox(height: 10),
                              // Row 2: Listen and learn + The Journalist
                              Row(
                                children: [
                                  // Listen and learn card (left, height 271)
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        _showEventModal(context, events[2]);
                                      },
                                      child: Container(
                                        height: 271,
                                        margin: const EdgeInsets.only(
                                          right: 15,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(
                                            0xFFFE6250,
                                          ), // Salmon
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Stack(
                                          children: [
                                            // Image positioned right and top
                                            Positioned(
                                              right: -47,
                                              top: 60,
                                              child: SizedBox(
                                                width: 202,
                                                height: 202,
                                                child: Image.asset(
                                                  'assets/images/vectors/find.png',
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                            // Title at top
                                            const Positioned(
                                              left: 15,
                                              top: 20,
                                              child: SizedBox(
                                                width: 115,
                                                child: Text(
                                                  'Listen and learn',
                                                  style: TextStyle(
                                                    fontFamily: 'Albert Sans',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 22,
                                                    color: Colors.white,
                                                    height: 1.27, // 28/22
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // Date badge at bottom
                                            Positioned(
                                              left: 15,
                                              bottom: 20,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: Colors.white
                                                      .withOpacity(0.32),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        100,
                                                      ),
                                                ),
                                                child: const Text(
                                                  '6 MAY',
                                                  style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                    color: Colors.white,
                                                    height: 1.38, // 18/13
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  // The Journalist card (right, height 249)
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        _showEventModal(context, events[3]);
                                      },
                                      child: Container(
                                        height: 269,
                                        decoration: BoxDecoration(
                                          color: const Color(
                                            0xFFFFAB01,
                                          ), // Yellow
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Stack(
                                          children: [
                                            // Image positioned right and top
                                            Positioned(
                                              right: -57,
                                              top: 60,
                                              child: SizedBox(
                                                width: 202,
                                                height: 202,
                                                child: Image.asset(
                                                  'assets/images/vectors/music.png',
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                            // Title at bottom
                                            const Positioned(
                                              left: 15,
                                              bottom: 162,
                                              child: SizedBox(
                                                width: 115,
                                                child: Text(
                                                  'The Journalist',
                                                  style: TextStyle(
                                                    fontFamily: 'Albert Sans',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 22,
                                                    color: Colors.white,
                                                    height: 1.27, // 28/22
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // Date badge
                                            Positioned(
                                              left: 15,
                                              top: 20,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: Colors.white
                                                      .withOpacity(0.32),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        100,
                                                      ),
                                                ),
                                                child: const Text(
                                                  '5 MAY',
                                                  style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                    color: Colors.white,
                                                    height: 1.38, // 18/13
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // Diamond badge at bottom right
                                            Positioned(
                                              right: 130,
                                              bottom: 20,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: Colors.white
                                                      .withOpacity(0.32),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        100,
                                                      ),
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      width: 16,
                                                      height: 16,
                                                      decoration:
                                                          const BoxDecoration(
                                                            color: Colors.white,
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                      child: const Icon(
                                                        Icons.diamond,
                                                        size: 10,
                                                        color: Color(
                                                          0xFFFFAB01,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 4),
                                                    const Text(
                                                      '6',
                                                      style: TextStyle(
                                                        fontFamily: 'Inter',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 13,
                                                        color: Colors.white,
                                                        height: 1.38, // 18/13
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
                                ],
                              ),
                              const SizedBox(height: 10),
                              // Row 3: Problem Solving + Listen and learn
                              Row(
                                children: [
                                  // Problem Solving card (left, height 271)
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        _showEventModal(context, events[4]);
                                      },
                                      child: Container(
                                        height: 271,
                                        margin: const EdgeInsets.only(
                                          right: 15,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(
                                            0xFFB18CFE,
                                          ), // Violet
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Stack(
                                          children: [
                                            // Image positioned right and top
                                            Positioned(
                                              right: -57,
                                              top: 100,
                                              child: SizedBox(
                                                width: 202,
                                                height: 202,
                                                child: Image.asset(
                                                  'assets/images/vectors/puzzle.png',
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                            // Title at top
                                            const Positioned(
                                              left: 15,
                                              top: 20,
                                              child: SizedBox(
                                                width: 115,
                                                child: Text(
                                                  'Problem Solving',
                                                  style: TextStyle(
                                                    fontFamily: 'Albert Sans',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 22,
                                                    color: Colors.white,
                                                    height: 1.27, // 28/22
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // Diamond badge at bottom
                                            Positioned(
                                              left: 15,
                                              bottom: 150,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: Colors.white
                                                      .withOpacity(0.32),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        100,
                                                      ),
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      width: 16,
                                                      height: 16,
                                                      decoration:
                                                          const BoxDecoration(
                                                            color: Colors.white,
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                      child: const Icon(
                                                        Icons.diamond,
                                                        size: 10,
                                                        color: Color(
                                                          0xFFB18CFE,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 4),
                                                    const Text(
                                                      '100',
                                                      style: TextStyle(
                                                        fontFamily: 'Inter',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 13,
                                                        color: Colors.white,
                                                        height: 1.38, // 18/13
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
                                  // Listen and learn card (right, height 236)
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        _showEventModal(context, events[5]);
                                      },
                                      child: Container(
                                        height: 266,
                                        decoration: BoxDecoration(
                                          color: const Color(
                                            0xFFEE719E,
                                          ), // Pink
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Stack(
                                          children: [
                                            // Image positioned right and top
                                            Positioned(
                                              right: -43,
                                              top: 95,
                                              child: SizedBox(
                                                width: 170,
                                                height: 170,
                                                child: Image.asset(
                                                  'assets/images/vectors/clock.png',
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                            // Title at bottom
                                            const Positioned(
                                              left: 15,
                                              bottom: 155,
                                              child: SizedBox(
                                                width: 115,
                                                child: Text(
                                                  'Listen and learn',
                                                  style: TextStyle(
                                                    fontFamily: 'Albert Sans',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 22,
                                                    color: Colors.white,
                                                    height: 1.27, // 28/22
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // Date badge at top
                                            Positioned(
                                              left: 15,
                                              top: 20,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: Colors.white
                                                      .withOpacity(0.32),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        100,
                                                      ),
                                                ),
                                                child: const Text(
                                                  '6 MAY',
                                                  style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                    color: Colors.white,
                                                    height: 1.38, // 18/13
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 100), // Space for bottom navigation
                  ],
                ),
              ),
            );
          },
        ),
      ),
      // Bottom Navigation Bar
      // bottomNavigationBar: Container(
      //   height: 83,
      //   decoration: BoxDecoration(
      //     color: const Color(0xff48484A).withOpacity(0.72),
      //     boxShadow: [
      //       BoxShadow(
      //         color: Colors.black.withOpacity(0.3),
      //         offset: const Offset(0, -0.5),
      //         blurRadius: 0,
      //       ),
      //     ],
      //   ),
      //   child: Column(
      //     children: [
      //       Expanded(
      //         child: Row(
      //           children: [
      //             _buildNavItem('Discover', Icons.explore, true),
      //             _buildNavItem('Search', Icons.search, false),
      //             _buildNavItem('Chats', Icons.chat_bubble_outline, false),
      //             _buildNavItem('Profile', Icons.person_outline, false),
      //           ],
      //         ),
      //       ),
      //       // Home indicator
      //       Container(
      //         margin: const EdgeInsets.only(bottom: 8),
      //         width: 134,
      //         height: 5,
      //         decoration: BoxDecoration(
      //           color: Colors.white.withOpacity(0.48),
      //           borderRadius: BorderRadius.circular(100),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }

  void _showEventModal(BuildContext context, Map<String, dynamic> event) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.95,
          decoration: BoxDecoration(
            color: const Color(0xff2C2C2E),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: Column(
            children: [
              // Header Image Section with Close Button
              Expanded(
                flex: 4,
                child: Stack(
                  children: [
                    // Background Image Area with Wavy Bottom
                    ClipPath(
                      clipper: WavyBottomClipper(),
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const Color(0xff64FCD9).withOpacity(0.8),
                              const Color(0xff64FCD9).withOpacity(0.6),
                              const Color(0xff64FCD9).withOpacity(0.4),
                            ],
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                          child: Stack(
                            children: [
                              // Event image
                              Center(
                                child: Container(
                                  width: 300,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: event['image'] != null
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          child: Image.asset(
                                            event['image'],
                                            width: 300,
                                            height: 200,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : Icon(
                                          Icons.public,
                                          size: 100,
                                          color: Colors.white.withOpacity(0.5),
                                        ),
                                ),
                              ),
                              // Gradient overlay at bottom (for depth)
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                height: 80,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        const Color(
                                          0xff64FCD9,
                                        ).withOpacity(0.1),
                                        const Color(
                                          0xff2C2C2E,
                                        ).withOpacity(0.3),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Close Button
                    Positioned(
                      top: 32,
                      left: 20,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.white,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                'Close',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.white,
                                  height: 1.33,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Content Section
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    // Fixed Header Section (Date, Title, Join Button)
                    Container(
                      padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Date badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.32),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Text(
                              event['date'] ?? '2ND MARCH, 3:30 PM',
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Colors.white,
                                letterSpacing: 0.2,
                                height: 1.38,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Title and Join Button Row
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  event['title'] ?? 'Around the world',
                                  style: const TextStyle(
                                    fontFamily: 'Albert Sans',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                    color: Colors.white,
                                    height: 1.27,
                                  ),
                                ),
                              ),
                              // Join button with tap effect
                              StatefulBuilder(
                                builder: (context, setModalState) {
                                  final eventId = event['title'] ?? '';
                                  final isJoined = _joinedEvents.contains(
                                    eventId,
                                  );

                                  return GestureDetector(
                                    onTap: () {
                                      if (!isJoined) {
                                        // Join the event
                                        setModalState(() {
                                          _joinedEvents.add(eventId);
                                        });
                                        setState(() {
                                          _eventsToAttend++;
                                        });

                                        // Show join effect with animation
                                        ScaffoldMessenger.of(
                                          context,
                                        ).clearSnackBars();
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Row(
                                              children: [
                                                const Icon(
                                                  Icons.check_circle,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    'Successfully joined ${event['title']}!',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            backgroundColor:
                                                event['color'] ??
                                                const Color(0xff64FCD9),
                                            duration: const Duration(
                                              seconds: 3,
                                            ),
                                            behavior: SnackBarBehavior.floating,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 18,
                                        vertical: 7,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isJoined
                                            ? (event['color'] ??
                                                  const Color(0xff64FCD9))
                                            : Colors.white.withOpacity(0.32),
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                        border: isJoined
                                            ? Border.all(
                                                color: Colors.white.withOpacity(
                                                  0.3,
                                                ),
                                                width: 1,
                                              )
                                            : null,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (isJoined)
                                            const Padding(
                                              padding: EdgeInsets.only(
                                                right: 4,
                                              ),
                                              child: Icon(
                                                Icons.check,
                                                color: Colors.white,
                                                size: 14,
                                              ),
                                            ),
                                          Text(
                                            isJoined ? 'Joined' : 'JOIN',
                                            style: const TextStyle(
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                              color: Colors.white,
                                              letterSpacing: 0.2,
                                              height: 1.38,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),

                    // Scrollable Content Section (Description and Headlines)
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Description
                              Text(
                                event['description'] ??
                                    'Wear your explorer\'s helmet and be prepared to fly to exciting and exotic locations with Noor Syeda.',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.normal,
                                  fontSize: 17,
                                  color: Colors.white.withOpacity(0.72),
                                  height: 1.29,
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Main Headlines Section
                              const Text(
                                'MAIN HEADLINES',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: Color(0xffE5E5EA),
                                  letterSpacing: 0.5,
                                  height: 1.38,
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Headlines List
                              Column(
                                children: event['headlines'] != null
                                    ? (event['headlines'] as List<dynamic>).map<
                                        Widget
                                      >((headline) {
                                        return Column(
                                          children: [
                                            Container(
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: const Color(0xff48484A),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                  10,
                                                ),
                                                child: Row(
                                                  children: [
                                                    // Icon
                                                    Container(
                                                      width: 40,
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            headline['color'] ??
                                                            event['color'],
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                      ),
                                                      child: Icon(
                                                        headline['icon'] ??
                                                            Icons.info,
                                                        color: Colors.white,
                                                        size: 24,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),

                                                    // Text
                                                    Expanded(
                                                      child: Text(
                                                        headline['text'] ??
                                                            'Event Detail',
                                                        style: const TextStyle(
                                                          fontFamily: 'Inter',
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize: 15,
                                                          color: Colors.white,
                                                          height: 1.33,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                          ],
                                        );
                                      }).toList()
                                    : [
                                        Container(
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: const Color(0xff48484A),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: const Center(
                                            child: Text(
                                              'No headlines available',
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 15,
                                                color: Colors.white70,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Custom clipper for wavy bottom effect
class WavyBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    // Start from top left corner
    path.moveTo(0, 0);

    // Draw to top right corner
    path.lineTo(size.width, 0);

    // Draw down the right side, leaving space for waves
    path.lineTo(size.width, size.height - 30);

    // Create smooth wavy bottom using cubic curves for better smoothness
    var waveHeight = 25.0;
    var waveLength = size.width / 3;

    // First wave (right side)
    path.cubicTo(
      size.width - waveLength * 0.5,
      size.height - waveHeight - 10,
      size.width - waveLength * 0.5,
      size.height + 5,
      size.width - waveLength,
      size.height - waveHeight / 2,
    );

    // Second wave (center)
    path.cubicTo(
      size.width - waveLength * 1.5,
      size.height - waveHeight - 15,
      size.width - waveLength * 1.5,
      size.height + 10,
      size.width - waveLength * 2,
      size.height - waveHeight,
    );

    // Third wave (left side)
    path.cubicTo(
      size.width - waveLength * 2.5,
      size.height - waveHeight - 5,
      size.width - waveLength * 2.5,
      size.height + 5,
      0,
      size.height - 20,
    );

    // Close the path back to start
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
