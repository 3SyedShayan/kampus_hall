import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/message_service.dart';
import '../models/message.dart';
import 'society_chat_screen.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = '/chat';
  const ChatScreen({super.key, this.refreshTrigger});

  final Object? refreshTrigger; // Add a trigger to force refresh

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;

  final MessageService _messageService = MessageService();
  List<SocietyChatInfo> _societyChats = [];
  Object? _lastRefreshTrigger;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: 800.ms)..forward();
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _loadChatData();
    _lastRefreshTrigger = widget.refreshTrigger;
  }

  @override
  void didUpdateWidget(ChatScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Refresh if the trigger changed
    if (widget.refreshTrigger != _lastRefreshTrigger) {
      _loadChatData();
      _lastRefreshTrigger = widget.refreshTrigger;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadChatData(); // Refresh data when dependencies change
  }

  void _loadChatData() {
    final newChats = _messageService.getJoinedSocietyChats();
    if (mounted) {
      setState(() {
        _societyChats = newChats;
      });
    }
  }

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return "";

    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return "${difference.inDays}d ago";
    } else if (difference.inHours > 0) {
      return "${difference.inHours}h ago";
    } else if (difference.inMinutes > 0) {
      return "${difference.inMinutes}m ago";
    } else {
      return "Just now";
    }
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
                child: _societyChats.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline,
                              size: 64,
                              color: Colors.white.withOpacity(0.3),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No Chats Yet',
                              style: TextStyle(
                                fontFamily: 'Albert Sans',
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white.withOpacity(0.7),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Join societies from the home screen\nto start chatting!',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.5),
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        itemCount: _societyChats.length,
                        itemBuilder: (context, index) {
                          final societyChat = _societyChats[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: Material(
                              color: Colors.transparent,
                              child:
                                  InkWell(
                                        onTap: () {
                                          // Mark messages as read and navigate to chat
                                          _messageService.markMessagesAsRead(
                                            societyChat.societyId,
                                          );
                                          Navigator.pushNamed(
                                            context,
                                            SocietyChatScreen.routeName,
                                            arguments: {
                                              'societyId':
                                                  societyChat.societyId,
                                              'societyTitle':
                                                  societyChat.societyTitle,
                                              'societyColor':
                                                  societyChat.societyColor,
                                            },
                                          ).then((_) {
                                            // Refresh chat data when returning from chat
                                            _loadChatData();
                                          });
                                        },
                                        borderRadius: BorderRadius.circular(16),
                                        child: Container(
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: const Color(0xff2C2C2E),
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            border: Border.all(
                                              color: Colors.white.withOpacity(
                                                0.1,
                                              ),
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
                                                  color:
                                                      societyChat.societyColor,
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                ),
                                                child: Icon(
                                                  Icons
                                                      .group, // Generic icon for now
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
                                                            societyChat
                                                                .societyTitle,
                                                            style: const TextStyle(
                                                              fontFamily:
                                                                  'Inter',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.white,
                                                              height:
                                                                  1.25, // 20/16
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          (societyChat
                                                                      .lastMessage
                                                                      ?.isNotEmpty ??
                                                                  false)
                                                              ? _formatTime(
                                                                  societyChat
                                                                      .lastMessageTime,
                                                                )
                                                              : "No messages",
                                                          style: TextStyle(
                                                            fontFamily: 'Inter',
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            fontSize: 12,
                                                            color: Colors.white
                                                                .withOpacity(
                                                                  0.6,
                                                                ),
                                                            height:
                                                                1.33, // 16/12
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      "${societyChat.memberCount} members",
                                                      style: TextStyle(
                                                        fontFamily: 'Inter',
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 14,
                                                        color: societyChat
                                                            .societyColor,
                                                        height: 1.29, // 18/14
                                                      ),
                                                    ),
                                                    const SizedBox(height: 6),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            societyChat
                                                                    .lastMessage ??
                                                                "No messages yet",
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Inter',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontSize: 14,
                                                              color: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                    0.7,
                                                                  ),
                                                              height:
                                                                  1.29, // 18/14
                                                            ),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                        if (societyChat
                                                                .unreadCount >
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
                                                              color: societyChat
                                                                  .societyColor,
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    12,
                                                                  ),
                                                            ),
                                                            child: Text(
                                                              '${societyChat.unreadCount}',
                                                              style: const TextStyle(
                                                                fontFamily:
                                                                    'Inter',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .white,
                                                                height:
                                                                    1.33, // 16/12
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
