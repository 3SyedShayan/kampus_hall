import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SocietyChatScreen extends StatefulWidget {
  static const routeName = '/society-chat';
  const SocietyChatScreen({super.key});

  @override
  State<SocietyChatScreen> createState() => _SocietyChatScreenState();
}

class _SocietyChatScreenState extends State<SocietyChatScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: 800.ms)..forward();
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
  }

  @override
  void dispose() {
    _controller.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildEventCard({
    required String title,
    required String time,
    required String location,
    required Color backgroundColor,
    required Color textColor,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: textColor,
                        height: 1.33, // 24/18
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      time,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: textColor.withOpacity(0.7),
                        height: 1.0, // 12/12
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: Colors.white, size: 32),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                Icons.location_on,
                size: 16,
                color: textColor.withOpacity(0.6),
              ),
              const SizedBox(width: 4),
              Text(
                location,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: textColor.withOpacity(0.6),
                  height: 1.0, // 12/12
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(48),
                ),
                child: Text(
                  'JOIN NOW',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                    color: backgroundColor,
                    height: 1.2, // 12/10
                    letterSpacing: 0.4,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessage({
    required String message,
    required String time,
    required bool isMe,
    required Color societyColor,
    String? senderName,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!isMe) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: societyColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.person, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isMe ? societyColor : const Color(0xff2C2C2E),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isMe && senderName != null) ...[
                    Text(
                      senderName,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: societyColor,
                        height: 1.33, // 16/12
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                  Text(
                    message,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                      color: Colors.white,
                      height: 1.25, // 20/16
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.normal,
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.6),
                      height: 1.0, // 12/12
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isMe) ...[
            const SizedBox(width: 8),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xff48484A),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.person, color: Colors.white, size: 20),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> society =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      backgroundColor: const Color(0xff1C1C1E),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color(0xff2C2C2E),
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.white.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: society['color'],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        society['icon'],
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            society['title'],
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white,
                              height: 1.25, // 20/16
                            ),
                          ),
                          Text(
                            '${society['members']} members',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.6),
                              height: 1.33, // 16/12
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.more_vert,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),

              // Chat Messages
              Expanded(
                child: ListView(
                  controller: _scrollController,
                  children: [
                    const SizedBox(height: 16),

                    // Event Card
                    _buildEventCard(
                      title: society['title'] == 'Xup Studio'
                          ? 'Music Jam Session'
                          : society['title'] == 'Tech Club'
                          ? 'AI Workshop'
                          : society['title'] == 'Art Society'
                          ? 'Gallery Exhibition'
                          : society['title'] == 'Science Club'
                          ? 'Lab Experiment'
                          : 'Community Meeting',
                      time: 'Today at 3:00 PM',
                      location: society['title'] == 'Xup Studio'
                          ? 'Music Room'
                          : society['title'] == 'Tech Club'
                          ? 'Computer Lab'
                          : society['title'] == 'Art Society'
                          ? 'Art Gallery'
                          : society['title'] == 'Science Club'
                          ? 'Science Lab'
                          : 'Main Hall',
                      backgroundColor: society['color'],
                      textColor: Colors.white,
                      icon: society['icon'],
                    ),

                    const SizedBox(height: 16),

                    // Sample Messages
                    _buildMessage(
                      message:
                          'Hey everyone! Don\'t forget about our event today',
                      time: '10:30 AM',
                      isMe: false,
                      societyColor: society['color'],
                      senderName: 'Sarah Wilson',
                    ),
                    _buildMessage(
                      message: 'Looking forward to it! 🎉',
                      time: '10:35 AM',
                      isMe: true,
                      societyColor: society['color'],
                    ),
                    _buildMessage(
                      message: 'Should we bring anything specific?',
                      time: '10:40 AM',
                      isMe: false,
                      societyColor: society['color'],
                      senderName: 'Mike Chen',
                    ),
                    _buildMessage(
                      message:
                          'Just bring your enthusiasm! Everything else is provided',
                      time: '10:45 AM',
                      isMe: false,
                      societyColor: society['color'],
                      senderName: 'Sarah Wilson',
                    ),
                    _buildMessage(
                      message: 'Perfect! See you all there',
                      time: '10:50 AM',
                      isMe: true,
                      societyColor: society['color'],
                    ),

                    const SizedBox(height: 100),
                  ],
                ),
              ),

              // Message Input
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xff2C2C2E),
                  border: Border(
                    top: BorderSide(
                      color: Colors.white.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xff48484A),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: TextField(
                          controller: _messageController,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Type a message...',
                            hintStyle: TextStyle(
                              color: Color(0xffE5E5EA),
                              fontSize: 16,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 12),
                          ),
                          maxLines: null,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () {
                        // Send message logic here
                        _messageController.clear();
                      },
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: society['color'],
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: const Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
