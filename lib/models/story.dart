import 'package:flutter/material.dart';

class Story {
  final String id;
  final String title;
  final String content;
  final String imageUrl;
  final DateTime timestamp;
  final String authorName;
  final String authorAvatarUrl;
  final bool isViewed;

  Story({
    required this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.timestamp,
    required this.authorName,
    required this.authorAvatarUrl,
    this.isViewed = false,
  });

  Story copyWith({
    String? id,
    String? title,
    String? content,
    String? imageUrl,
    DateTime? timestamp,
    String? authorName,
    String? authorAvatarUrl,
    bool? isViewed,
  }) {
    return Story(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      timestamp: timestamp ?? this.timestamp,
      authorName: authorName ?? this.authorName,
      authorAvatarUrl: authorAvatarUrl ?? this.authorAvatarUrl,
      isViewed: isViewed ?? this.isViewed,
    );
  }
}

class StoryGroup {
  final String groupId;
  final String groupTitle;
  final Color color;
  final IconData icon;
  final String? imageUrl; // Optional image URL for groups like PAF
  final List<Story> stories;
  final bool hasUnviewedStories;

  StoryGroup({
    required this.groupId,
    required this.groupTitle,
    required this.color,
    required this.icon,
    this.imageUrl,
    required this.stories,
    required this.hasUnviewedStories,
  });

  StoryGroup copyWith({
    String? groupId,
    String? groupTitle,
    Color? color,
    IconData? icon,
    String? imageUrl,
    List<Story>? stories,
    bool? hasUnviewedStories,
  }) {
    return StoryGroup(
      groupId: groupId ?? this.groupId,
      groupTitle: groupTitle ?? this.groupTitle,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      imageUrl: imageUrl ?? this.imageUrl,
      stories: stories ?? this.stories,
      hasUnviewedStories: hasUnviewedStories ?? this.hasUnviewedStories,
    );
  }
}
