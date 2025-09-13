import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = '/chat';
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;

  // Society data that matches the home screen
  final List<Map<String, dynamic>> societies = [
    {
      'title': 'Xup Studio',
      'color': const Color(0xffB18CFE),
      'subtitle': 'Music Society',
      'icon': Icons.music_note,
      'members': 234,
      'lastMessage': 'Hey everyone! Studio session at 3 PM today',
      'lastMessageTime': '2 min ago',
      'unreadCount': 3,
    },
    {
      'title': 'Welfare So',
      'color': const Color(0xff64FCD9),
      'subtitle': 'Social Impact',
      'icon': Icons.volunteer_activism,
      'members': 456,
      'lastMessage': 'Food drive this weekend, need volunteers!',
      'lastMessageTime': '15 min ago',
      'unreadCount': 0,
    },
    {
      'title': 'Tech Club',
      'color': const Color(0xffEE719E),
      'subtitle': 'Technology',
      'icon': Icons.computer,
      'members': 189,
      'lastMessage': 'AI workshop registration is now open',
      'lastMessageTime': '1 hour ago',
      'unreadCount': 7,
    },
    {
      'title': 'Art Society',
      'color': const Color(0xffFF8C82),
      'subtitle': 'Creative Arts',
      'icon': Icons.palette,
      'members': 312,
      'lastMessage': 'Gallery exhibition next Friday',
      'lastMessageTime': '3 hours ago',
      'unreadCount': 1,
    },
    {
      'title': 'Science Club',
      'color': const Color(0xffFFAB01),
      'subtitle': 'Research & Discovery',
      'icon': Icons.science,
      'members': 278,
      'lastMessage': 'Lab results are in! Check the group files',
      'lastMessageTime': 'Yesterday',
      'unreadCount': 0,
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: 800.ms)..forward();
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1C1C1E),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const Expanded(
                          child: Text(
                            'Society Chats',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: Colors.white,
                              height: 1.33, // 32/24
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xff48484A).withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.search,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    const Text(
                      'JOINED SOCIETIES',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Color(0xffE5E5EA),
                        height: 1.38, // 18/13
                      ),
                    ),
                  ],
                ),
              ),

              // Society Chat List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  itemCount: societies.length,
                  itemBuilder: (context, index) {
                    final society = societies[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Material(
                        color: Colors.transparent,
                        child:
                            InkWell(
                                  onTap: () {
                                    // Navigate to individual chat
                                    Navigator.pushNamed(
                                      context,
                                      '/society-chat',
                                      arguments: society,
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(16),
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: const Color(0xff2C2C2E),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.1),
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        // Society Logo/Avatar
                                        Container(
                                          width: 56,
                                          height: 56,
                                          decoration: BoxDecoration(
                                            color: society['color'],
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                          child: Icon(
                                            society['icon'],
                                            color: Colors.white,
                                            size: 28,
                                          ),
                                        ),
                                        const SizedBox(width: 16),

                                        // Chat Info
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      society['title'],
                                                      style: const TextStyle(
                                                        fontFamily: 'Inter',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color: Colors.white,
                                                        height: 1.25, // 20/16
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    society['lastMessageTime'],
                                                    style: TextStyle(
                                                      fontFamily: 'Inter',
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 12,
                                                      color: Colors.white
                                                          .withOpacity(0.6),
                                                      height: 1.33, // 16/12
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                society['subtitle'],
                                                style: TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 14,
                                                  color: society['color'],
                                                  height: 1.29, // 18/14
                                                ),
                                              ),
                                              const SizedBox(height: 6),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      society['lastMessage'],
                                                      style: TextStyle(
                                                        fontFamily: 'Inter',
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 14,
                                                        color: Colors.white
                                                            .withOpacity(0.7),
                                                        height: 1.29, // 18/14
                                                      ),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  if (society['unreadCount'] >
                                                      0)
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                            left: 8,
                                                          ),
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 8,
                                                            vertical: 4,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: society['color'],
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                      ),
                                                      child: Text(
                                                        '${society['unreadCount']}',
                                                        style: const TextStyle(
                                                          fontFamily: 'Inter',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 12,
                                                          color: Colors.white,
                                                          height: 1.33, // 16/12
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                .animate()
                                .slideX(
                                  begin: 1,
                                  duration: (400 + (index * 100)).ms,
                                  curve: Curves.easeOutQuart,
                                )
                                .fadeIn(
                                  duration: (400 + (index * 100)).ms,
                                  curve: Curves.easeOut,
                                ),
                      ),
                    );
                  },
                ),
              ),

              // Bottom padding for navigation bar
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
