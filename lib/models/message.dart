import 'package:flutter/material.dart';

class Message {
  final String id;
  final String societyId;
  final String senderId;
  final String senderName;
  final String content;
  final DateTime timestamp;
  final MessageType type;
  final bool isRead;

  const Message({
    required this.id,
    required this.societyId,
    required this.senderId,
    required this.senderName,
    required this.content,
    required this.timestamp,
    this.type = MessageType.text,
    this.isRead = false,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] ?? '',
      societyId: json['societyId'] ?? '',
      senderId: json['senderId'] ?? '',
      senderName: json['senderName'] ?? '',
      content: json['content'] ?? '',
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      type: MessageType.values.firstWhere(
        (e) => e.toString() == 'MessageType.${json['type']}',
        orElse: () => MessageType.text,
      ),
      isRead: json['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'societyId': societyId,
      'senderId': senderId,
      'senderName': senderName,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'type': type.toString().split('.').last,
      'isRead': isRead,
    };
  }

  Message copyWith({
    String? id,
    String? societyId,
    String? senderId,
    String? senderName,
    String? content,
    DateTime? timestamp,
    MessageType? type,
    bool? isRead,
  }) {
    return Message(
      id: id ?? this.id,
      societyId: societyId ?? this.societyId,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
    );
  }
}

enum MessageType {
  text,
  image,
  file,
  event,
}

class SocietyChatInfo {
  final String societyId;
  final String societyTitle;
  final Color societyColor;
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final int unreadCount;
  final int memberCount;

  const SocietyChatInfo({
    required this.societyId,
    required this.societyTitle,
    required this.societyColor,
    this.lastMessage,
    this.lastMessageTime,
    this.unreadCount = 0,
    this.memberCount = 0,
  });

  SocietyChatInfo copyWith({
    String? societyId,
    String? societyTitle,
    Color? societyColor,
    String? lastMessage,
    DateTime? lastMessageTime,
    int? unreadCount,
    int? memberCount,
  }) {
    return SocietyChatInfo(
      societyId: societyId ?? this.societyId,
      societyTitle: societyTitle ?? this.societyTitle,
      societyColor: societyColor ?? this.societyColor,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      unreadCount: unreadCount ?? this.unreadCount,
      memberCount: memberCount ?? this.memberCount,
    );
  }
}