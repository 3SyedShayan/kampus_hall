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

  // Dummy data for events
  final List<Map<String, dynamic>> events = [
    {
      'title': 'How to Read?',
      'color': const Color(0xffFF8C82),
      'description': 'Spot the mistakes in reading techniques',
    },
    {
      'title': 'Material in Industry',
      'color': const Color(0xffEE719E),
      'description': 'Chemistry workshop for beginners',
    },
    {
      'title': 'AI Workshop',
      'color': const Color(0xffB18CFE),
      'description': 'Learn about artificial intelligence',
    },
    {
      'title': 'Music Therapy',
      'color': const Color(0xffFFAB01),
      'description': 'Healing through music sessions',
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
                          const Expanded(
                            child: Text(
                              'You have 1 Event to Attend today',
                              style: TextStyle(
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
                                          child: Icon(
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

                    const SizedBox(height: 42),

                    // Happening Today Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
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
                          const SizedBox(height: 20),
                          // 6-card grid layout (3 rows, 2 columns)
                          Column(
                            children: [
                              // Row 1
                              Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        _showEventModal(context, {
                                          'title': 'How to Read?',
                                          'description':
                                              'Spot the mistakes in reading techniques and improve your comprehension skills.',
                                          'color': const Color(0xFFFF8C82),
                                        });
                                      },
                                      child: Container(
                                        height: 236,
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
                                            // Image
                                            Positioned(
                                              right: 5,
                                              top: 70,
                                              child: Container(
                                                width: 100,
                                                height: 100,
                                                child: Image.asset(
                                                  'assets/images/vectors/read.png',
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                            // Title
                                            const Positioned(
                                              left: 15,
                                              top: 20,
                                              child: SizedBox(
                                                width: 115,
                                                child: Text(
                                                  'How to Read?',
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
                                              bottom: 15,
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
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        _showEventModal(context, {
                                          'title': 'Material in Industry',
                                          'description':
                                              'Chemistry workshop for beginners exploring materials.',
                                          'color': const Color(0xFFEE719E),
                                        });
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
                                            // Image
                                            Positioned(
                                              right: 5,
                                              bottom: 90,
                                              child: Container(
                                                width: 110,
                                                height: 110,
                                                child: Image.asset(
                                                  'assets/images/vectors/chemistry.png',
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                            // Title
                                            const Positioned(
                                              left: 15,
                                              top: 20,
                                              child: SizedBox(
                                                width: 115,
                                                child: Text(
                                                  'Material in Industry',
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
                                              top: 100,
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
                                            // Diamond badge
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
                                                        Icons.circle,
                                                        size: 12,
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
                              const SizedBox(height: 15),
                              // Row 2
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 271,
                                      margin: const EdgeInsets.only(right: 15),
                                      decoration: BoxDecoration(
                                        color: const Color(
                                          0xFFFE6250,
                                        ), // Salmon
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Stack(
                                        children: [
                                          // Image
                                          Positioned(
                                            right: 5,
                                            top: 70,
                                            child: Container(
                                              width: 110,
                                              height: 110,
                                              child: Image.asset(
                                                'assets/images/vectors/music.png',
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                          // Title
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
                                          // Diamond badge
                                          Positioned(
                                            left: 15,
                                            bottom: 15,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(
                                                  0.32,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
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
                                                      Icons.circle,
                                                      size: 12,
                                                      color: Color(0xFFFE6250),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  const Text(
                                                    '3',
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
                                          // Date badge
                                          Positioned(
                                            right: 15,
                                            bottom: 15,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(
                                                  0.32,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(100),
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
                                  Expanded(
                                    child: Container(
                                      height: 249,
                                      decoration: BoxDecoration(
                                        color: const Color(
                                          0xFFFFAB01,
                                        ), // Yellow
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Stack(
                                        children: [
                                          // Image
                                          Positioned(
                                            right: 10,
                                            top: 30,
                                            child: Container(
                                              width: 120,
                                              height: 120,
                                              child: Image.asset(
                                                'assets/images/vectors/find.png',
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                          // Title
                                          const Positioned(
                                            left: 15,
                                            top: 160,
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
                                            bottom: 50,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(
                                                  0.32,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(100),
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
                                          // Diamond badge
                                          Positioned(
                                            right: 15,
                                            bottom: 20,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(
                                                  0.32,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
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
                                                      Icons.circle,
                                                      size: 12,
                                                      color: Color(0xFFFFAB01),
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
                                ],
                              ),
                              const SizedBox(height: 15),
                              // Row 3
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 271,
                                      margin: const EdgeInsets.only(right: 15),
                                      decoration: BoxDecoration(
                                        color: const Color(
                                          0xFFB18CFE,
                                        ), // Violet
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Stack(
                                        children: [
                                          // Image
                                          Positioned(
                                            right: 5,
                                            top: 70,
                                            child: Container(
                                              width: 110,
                                              height: 110,
                                              child: Image.asset(
                                                'assets/images/vectors/puzzle.png',
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                          // Title
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
                                          // Diamond badge
                                          Positioned(
                                            left: 15,
                                            bottom: 15,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(
                                                  0.32,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
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
                                                      Icons.circle,
                                                      size: 12,
                                                      color: Color(0xFFB18CFE),
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
                                  Expanded(
                                    child: Container(
                                      height: 236,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEE719E), // Pink
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Stack(
                                        children: [
                                          // Image
                                          Positioned(
                                            right: 10,
                                            top: 40,
                                            child: Container(
                                              width: 100,
                                              height: 100,
                                              child: Image.asset(
                                                'assets/images/vectors/clock.png',
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                          // Title
                                          const Positioned(
                                            left: 15,
                                            top: 150,
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
                                          // Date badge
                                          Positioned(
                                            left: 15,
                                            bottom: 50,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(
                                                  0.32,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(100),
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
                                          // Diamond badge
                                          Positioned(
                                            right: 15,
                                            bottom: 20,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(
                                                  0.32,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
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
                                                      Icons.circle,
                                                      size: 12,
                                                      color: Color(0xFFEE719E),
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

  Widget _buildNavItem(String title, IconData icon, bool isActive) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (title == 'Chats') {
            // Navigate to main navigation with chat tab selected
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/main',
              (route) => false,
              arguments: {'initialIndex': 1}, // 1 is the chat tab index
            );
          }
          // Add other navigation logic here for other tabs if needed
        },
        child: Container(
          height: 54,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Opacity(
                opacity: isActive ? 1.0 : 0.72,
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              const SizedBox(height: 4),
              Opacity(
                opacity: isActive ? 1.0 : 0.72,
                child: Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.normal,
                    fontSize: 11,
                    color: Colors.white,
                    height: 1.18, // 13/11
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
                              // Illustration placeholder
                              Center(
                                child: Container(
                                  width: 300,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Icon(
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
                child: Container(
                  padding: const EdgeInsets.all(15),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
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
                            '2ND MARCH, 3:30 PM',
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
                            GestureDetector(
                              onTap: () {
                                // Show join effect
                                ScaffoldMessenger.of(context).clearSnackBars();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Joined ${event['title']}!'),
                                    backgroundColor:
                                        event['color'] ??
                                        const Color(0xff64FCD9),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 7,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.32),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: const Text(
                                  'JOIN',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: Colors.white,
                                    letterSpacing: 0.2,
                                    height: 1.38,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

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
                          children: [
                            // First headline
                            Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: const Color(0xff48484A),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    // Icon
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: const Color(0xff64FCD9),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.location_on,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 10),

                                    // Text
                                    const Expanded(
                                      child: Text(
                                        'The European capitals',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.normal,
                                          fontSize: 15,
                                          color: Colors.white,
                                          height: 1.33,
                                        ),
                                      ),
                                    ),

                                    // More button
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 7,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.32),
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                      ),
                                      child: const Text(
                                        'MORE',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: Colors.white,
                                          letterSpacing: 0.2,
                                          height: 1.38,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Second headline
                            Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: const Color(0xff48484A),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    // Icon
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: const Color(0xffFFAB01),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.terrain,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 10),

                                    // Text
                                    const Expanded(
                                      child: Text(
                                        'History of the Mughals',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.normal,
                                          fontSize: 15,
                                          color: Colors.white,
                                          height: 1.33,
                                        ),
                                      ),
                                    ),

                                    // More button
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 7,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.32),
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                      ),
                                      child: const Text(
                                        'MORE',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: Colors.white,
                                          letterSpacing: 0.2,
                                          height: 1.38,
                                        ),
                                      ),
                                    ),
                                  ],
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
