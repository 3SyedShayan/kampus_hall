import 'package:flutter/material.dart';

class Society {
  final String id;
  final String title;
  final String subtitle;
  final Color color;
  final String description;
  final List<String> tags;
  final String imageUrl;
  final int memberCount;
  final bool isPublic;
  final DateTime createdAt;

  const Society({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.color,
    this.description = '',
    this.tags = const [],
    this.imageUrl = '',
    this.memberCount = 0,
    this.isPublic = true,
    required this.createdAt,
  });

  factory Society.fromJson(Map<String, dynamic> json) {
    return Society(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      color: Color(json['color'] ?? 0xFFB18CFE),
      description: json['description'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      imageUrl: json['imageUrl'] ?? '',
      memberCount: json['memberCount'] ?? 0,
      isPublic: json['isPublic'] ?? true,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'color': color.value,
      'description': description,
      'tags': tags,
      'imageUrl': imageUrl,
      'memberCount': memberCount,
      'isPublic': isPublic,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Society copyWith({
    String? id,
    String? title,
    String? subtitle,
    Color? color,
    String? description,
    List<String>? tags,
    String? imageUrl,
    int? memberCount,
    bool? isPublic,
    DateTime? createdAt,
  }) {
    return Society(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      color: color ?? this.color,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      imageUrl: imageUrl ?? this.imageUrl,
      memberCount: memberCount ?? this.memberCount,
      isPublic: isPublic ?? this.isPublic,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class UserSocietyMembership {
  final String societyId;
  final String userId;
  final DateTime joinedAt;
  final String role; // 'member', 'admin', 'moderator'
  final bool isActive;

  const UserSocietyMembership({
    required this.societyId,
    required this.userId,
    required this.joinedAt,
    this.role = 'member',
    this.isActive = true,
  });

  factory UserSocietyMembership.fromJson(Map<String, dynamic> json) {
    return UserSocietyMembership(
      societyId: json['societyId'] ?? '',
      userId: json['userId'] ?? '',
      joinedAt: DateTime.parse(json['joinedAt'] ?? DateTime.now().toIso8601String()),
      role: json['role'] ?? 'member',
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'societyId': societyId,
      'userId': userId,
      'joinedAt': joinedAt.toIso8601String(),
      'role': role,
      'isActive': isActive,
    };
  }
}