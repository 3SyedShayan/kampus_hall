import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/story.dart';
import '../services/story_service.dart';

class StoryViewerScreen extends StatefulWidget {
  static const routeName = '/story-viewer';
  const StoryViewerScreen({super.key});

  @override
  State<StoryViewerScreen> createState() => _StoryViewerScreenState();
}

class _StoryViewerScreenState extends State<StoryViewerScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _progressController;
  List<AnimationController> _progressControllers = [];
  final StoryService _storyService = StoryService();

  List<StoryGroup> allGroups = [];
  int currentGroupIndex = 0;
  int currentStoryIndex = 0;
  bool isPaused = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    allGroups = _storyService.getAllStoryGroups();
    _setupProgressControllers();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      final String groupId = args['groupId'] as String;
      currentGroupIndex = allGroups.indexWhere(
        (group) => group.groupId == groupId,
      );
      if (currentGroupIndex == -1) currentGroupIndex = 0;
      _setupProgressControllers();
      _startStoryTimer();
    }
  }

  void _setupProgressControllers() {
    // Dispose old controllers before overwriting
    if (_progressControllers.isNotEmpty) {
      for (final controller in _progressControllers) {
        controller.dispose();
      }
    }
    _progressControllers = [];
    final currentGroup = allGroups[currentGroupIndex];
    for (int i = 0; i < currentGroup.stories.length; i++) {
      final controller = AnimationController(
        duration: const Duration(seconds: 10),
        vsync: this,
      );
      _progressControllers.add(controller);
    }
    _progressController = _progressControllers[currentStoryIndex];
  }

  void _startStoryTimer() {
    _progressController.reset();
    _progressController.forward().then((_) {
      if (!isPaused) {
        _nextStory();
      }
    });
  }

  void _nextStory() {
    final currentGroup = allGroups[currentGroupIndex];

    // Mark current story as viewed
    _storyService.markStoryAsViewed(currentGroup.stories[currentStoryIndex].id);

    if (currentStoryIndex < currentGroup.stories.length - 1) {
      // Next story in current group
      setState(() {
        currentStoryIndex++;
        _progressController = _progressControllers[currentStoryIndex];
      });
      _startStoryTimer();
    } else {
      // Move to next group
      if (currentGroupIndex < allGroups.length - 1) {
        setState(() {
          currentGroupIndex++;
          currentStoryIndex = 0;
          _setupProgressControllers();
          _progressController = _progressControllers[currentStoryIndex];
        });
        _startStoryTimer();
      } else {
        // All stories finished
        Navigator.pop(context);
      }
    }
  }

  void _previousStory() {
    if (currentStoryIndex > 0) {
      setState(() {
        currentStoryIndex--;
        _progressController = _progressControllers[currentStoryIndex];
      });
      _startStoryTimer();
    } else if (currentGroupIndex > 0) {
      setState(() {
        currentGroupIndex--;
        final prevGroup = allGroups[currentGroupIndex];
        currentStoryIndex = prevGroup.stories.length - 1;
        _setupProgressControllers();
        _progressController = _progressControllers[currentStoryIndex];
      });
      _startStoryTimer();
    }
  }

  void _pauseStory() {
    setState(() {
      isPaused = true;
      _progressController.stop();
    });
  }

  void _resumeStory() {
    setState(() {
      isPaused = false;
      _progressController.forward();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (final controller in _progressControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentGroup = allGroups[currentGroupIndex];
    final currentStory = currentGroup.stories[currentStoryIndex];

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapDown: (details) {
          final screenWidth = MediaQuery.of(context).size.width;
          if (details.globalPosition.dx < screenWidth / 2) {
            _previousStory();
          } else {
            _nextStory();
          }
        },
        onLongPressStart: (_) => _pauseStory(),
        onLongPressEnd: (_) => _resumeStory(),
        child: Stack(
          children: [
            // Background image/content
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    currentGroup.color.withOpacity(0.8),
                    currentGroup.color.withOpacity(0.4),
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    currentGroup.icon,
                    size: 120,
                    color: Colors.white.withOpacity(0.9),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      currentStory.title,
                      style: const TextStyle(
                        fontFamily: 'Albert Sans',
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        color: Colors.white,
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      currentStory.content,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Colors.white,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),

            // Top gradient overlay
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                  ),
                ),
              ),
            ),

            // Progress bars
            Positioned(
              top: MediaQuery.of(context).padding.top + 8,
              left: 8,
              right: 8,
              child: Row(
                children: List.generate(
                  currentGroup.stories.length,
                  (index) => Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      height: 3,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(1.5),
                      ),
                      child: Row(
                        children: [
                          if (index < currentStoryIndex)
                            // Completed stories
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(1.5),
                                ),
                              ),
                            )
                          else if (index == currentStoryIndex)
                            // Current story with animation
                            Expanded(
                              child: AnimatedBuilder(
                                animation: _progressController,
                                builder: (context, child) {
                                  return LinearProgressIndicator(
                                    value: _progressController.value,
                                    backgroundColor: Colors.transparent,
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                          Colors.white,
                                        ),
                                    minHeight: 3,
                                  );
                                },
                              ),
                            )
                          else
                            // Future stories
                            const Expanded(child: SizedBox()),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Header with user info and close button
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              left: 16,
              right: 16,
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: currentGroup.color,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      currentGroup.icon,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentStory.authorName,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          _formatTimestamp(currentStory.timestamp),
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),

            // Bottom instruction text
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 32,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isPaused
                          ? 'Release to continue'
                          : 'Tap sides to navigate • Hold to pause',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
