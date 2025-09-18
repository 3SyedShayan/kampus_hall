import '../models/message.dart';
import '../services/society_service.dart';

class MessageService {
  static final MessageService _instance = MessageService._internal();
  factory MessageService() => _instance;
  MessageService._internal();

  final SocietyService _societyService = SocietyService();

  // Mock current user ID - in a real app this would come from authentication
  static const String currentUserId = 'user_123';

  // Mock message storage - in a real app this would be a database
  final List<Message> _messages = [
    Message(
      id: 'msg_1',
      societyId: 'soc_1', // Xup Studio
      senderId: 'user_456',
      senderName: 'Alex Music',
      content: 'Hey everyone! Studio session at 3 PM today',
      timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
    ),
    Message(
      id: 'msg_2',
      societyId: 'soc_1',
      senderId: 'user_789',
      senderName: 'Sarah Beats',
      content: 'Bring your instruments!',
      timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
    ),
    Message(
      id: 'msg_3',
      societyId: 'soc_1',
      senderId: 'user_101',
      senderName: 'Mike Harmony',
      content: 'Can\'t wait to jam together 🎵',
      timestamp: DateTime.now().subtract(const Duration(seconds: 30)),
    ),
    Message(
      id: 'msg_4',
      societyId: 'soc_3', // Tech Club
      senderId: 'user_202',
      senderName: 'Lisa Code',
      content: 'AI workshop registration is now open',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    Message(
      id: 'msg_5',
      societyId: 'soc_3',
      senderId: 'user_303',
      senderName: 'David AI',
      content: 'Who\'s excited about machine learning?',
      timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
    ),
    Message(
      id: 'msg_6',
      societyId: 'soc_3',
      senderId: 'user_404',
      senderName: 'Emma Neural',
      content: 'I\'ll be there! Already registered',
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
    Message(
      id: 'msg_7',
      societyId: 'soc_3',
      senderId: 'user_505',
      senderName: 'Ryan Data',
      content: 'Check out this cool AI project I found',
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
    ),
    Message(
      id: 'msg_8',
      societyId: 'soc_3',
      senderId: 'user_606',
      senderName: 'Sophie Model',
      content: 'The workshop materials are available now',
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
    ),
    Message(
      id: 'msg_9',
      societyId: 'soc_3',
      senderId: 'user_707',
      senderName: 'Jack Algorithm',
      content: 'Thanks for sharing! This looks amazing',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    Message(
      id: 'msg_10',
      societyId: 'soc_3',
      senderId: 'user_808',
      senderName: 'Zoe Binary',
      content: 'See you all at the workshop!',
      timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
    ),
  ];

  // Track read status per user per society
  final Map<String, Set<String>> _readMessages = {
    currentUserId: <String>{}, // User has read no messages initially
  };

  // Get all messages for a specific society
  List<Message> getMessagesForSociety(String societyId) {
    return _messages.where((message) => message.societyId == societyId).toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  // Get the last message for a society
  Message? getLastMessageForSociety(String societyId) {
    final messages = getMessagesForSociety(societyId);
    return messages.isNotEmpty ? messages.last : null;
  }

  // Get unread message count for a society
  int getUnreadCountForSociety(String societyId, {String? userId}) {
    final targetUserId = userId ?? currentUserId;
    final readMessageIds = _readMessages[targetUserId] ?? <String>{};

    return _messages
        .where(
          (message) =>
              message.societyId == societyId &&
              !readMessageIds.contains(message.id) &&
              message.senderId != targetUserId,
        ) // Don't count own messages as unread
        .length;
  }

  // Mark messages as read for a society
  void markMessagesAsRead(String societyId, {String? userId}) {
    final targetUserId = userId ?? currentUserId;
    final readMessageIds = _readMessages[targetUserId] ?? <String>{};

    final societyMessages = _messages
        .where((message) => message.societyId == societyId)
        .map((message) => message.id);

    readMessageIds.addAll(societyMessages);
    _readMessages[targetUserId] = readMessageIds;
  }

  // Get chat info for all joined societies
  List<SocietyChatInfo> getJoinedSocietyChats({String? userId}) {
    final joinedSocieties = _societyService.getJoinedSocieties(userId: userId);

    return joinedSocieties.map((society) {
      final lastMessage = getLastMessageForSociety(society.id);
      final unreadCount = getUnreadCountForSociety(society.id, userId: userId);

      return SocietyChatInfo(
        societyId: society.id,
        societyTitle: society.title,
        societyColor: society.color,
        lastMessage: lastMessage?.content,
        lastMessageTime: lastMessage?.timestamp,
        unreadCount: unreadCount,
        memberCount: society.memberCount,
      );
    }).toList()..sort((a, b) {
      // Sort by last message time, most recent first
      if (a.lastMessageTime == null && b.lastMessageTime == null) return 0;
      if (a.lastMessageTime == null) return 1;
      if (b.lastMessageTime == null) return -1;
      return b.lastMessageTime!.compareTo(a.lastMessageTime!);
    });
  }

  // Send a new message
  Future<bool> sendMessage(
    String societyId,
    String content, {
    String? userId,
  }) async {
    final targetUserId = userId ?? currentUserId;

    // Check if user is member of the society
    if (!_societyService.isMemberOfSociety(societyId, userId: targetUserId)) {
      return false;
    }

    final message = Message(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      societyId: societyId,
      senderId: targetUserId,
      senderName: 'You', // In a real app, get from user profile
      content: content,
      timestamp: DateTime.now(),
    );

    _messages.add(message);

    // Mark own message as read
    final readMessageIds = _readMessages[targetUserId] ?? <String>{};
    readMessageIds.add(message.id);
    _readMessages[targetUserId] = readMessageIds;

    return true;
  }

  // Get total unread count across all societies
  int getTotalUnreadCount({String? userId}) {
    final joinedSocieties = _societyService.getJoinedSocieties(userId: userId);
    return joinedSocieties
        .map((society) => getUnreadCountForSociety(society.id, userId: userId))
        .fold(0, (total, count) => total + count);
  }

  // Get count of societies with unread messages
  int getUnreadSocietiesCount({String? userId}) {
    final joinedSocieties = _societyService.getJoinedSocieties(userId: userId);
    return joinedSocieties
        .where(
          (society) => getUnreadCountForSociety(society.id, userId: userId) > 0,
        )
        .length;
  }

  // Format time for display
  String formatMessageTime(DateTime? timestamp) {
    if (timestamp == null) return '';

    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}
