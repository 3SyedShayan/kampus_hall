import 'package:flutter/material.dart';
import '../models/story.dart';

class StoryService {
  static final StoryService _instance = StoryService._internal();
  factory StoryService() => _instance;
  StoryService._internal();

  // Mock story data
  final List<StoryGroup> _storyGroups = [
    StoryGroup(
      groupId: 'ai_stories',
      groupTitle: 'Artificial I.',
      color: const Color(0xffB18CFE),
      icon: Icons.psychology,
      hasUnviewedStories: true,
      stories: [
        Story(
          id: 'ai_1',
          title: 'AI Workshop',
          content:
              'Join us for an exciting AI workshop today! Learn about machine learning and neural networks.',
          imageUrl:
              'https://via.placeholder.com/400x800/B18CFE/FFFFFF?text=AI+Workshop',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          authorName: 'AI Society',
          authorAvatarUrl:
              'https://via.placeholder.com/40x40/B18CFE/FFFFFF?text=AI',
        ),
        Story(
          id: 'ai_2',
          title: 'New Research',
          content:
              'Check out the latest breakthroughs in artificial intelligence research from our members!',
          imageUrl:
              'https://via.placeholder.com/400x800/B18CFE/FFFFFF?text=Research',
          timestamp: DateTime.now().subtract(const Duration(hours: 5)),
          authorName: 'Dr. Sarah AI',
          authorAvatarUrl:
              'https://via.placeholder.com/40x40/B18CFE/FFFFFF?text=SA',
        ),
        Story(
          id: 'ai_3',
          title: 'Tech Demo',
          content:
              'Amazing demo of our latest AI project! See how we built a chatbot from scratch.',
          imageUrl:
              'https://via.placeholder.com/400x800/B18CFE/FFFFFF?text=Demo',
          timestamp: DateTime.now().subtract(const Duration(hours: 8)),
          authorName: 'Tech Team',
          authorAvatarUrl:
              'https://via.placeholder.com/40x40/B18CFE/FFFFFF?text=TT',
        ),
      ],
    ),
    StoryGroup(
      groupId: 'science_stories',
      groupTitle: 'Science',
      color: const Color(0xffEE719E),
      icon: Icons.science,
      hasUnviewedStories: true,
      stories: [
        Story(
          id: 'sci_1',
          title: 'Lab Experiment',
          content:
              'Today we conducted an amazing chemistry experiment! The results were incredible.',
          imageUrl:
              'https://via.placeholder.com/400x800/EE719E/FFFFFF?text=Lab+Experiment',
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
          authorName: 'Science Club',
          authorAvatarUrl:
              'https://via.placeholder.com/40x40/EE719E/FFFFFF?text=SC',
        ),
        Story(
          id: 'sci_2',
          title: 'Field Trip',
          content:
              'Amazing field trip to the research facility! Learned so much about modern science.',
          imageUrl:
              'https://via.placeholder.com/400x800/EE719E/FFFFFF?text=Field+Trip',
          timestamp: DateTime.now().subtract(const Duration(hours: 6)),
          authorName: 'Dr. Emma Science',
          authorAvatarUrl:
              'https://via.placeholder.com/40x40/EE719E/FFFFFF?text=ES',
        ),
      ],
    ),
    StoryGroup(
      groupId: 'english_stories',
      groupTitle: 'English',
      color: const Color(0xffFF8C82),
      icon: Icons.book,
      hasUnviewedStories: false,
      stories: [
        Story(
          id: 'eng_1',
          title: 'Poetry Reading',
          content:
              'Beautiful poetry reading session yesterday. So many talented writers in our community!',
          imageUrl:
              'https://via.placeholder.com/400x800/FF8C82/FFFFFF?text=Poetry',
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          authorName: 'Literature Club',
          authorAvatarUrl:
              'https://via.placeholder.com/40x40/FF8C82/FFFFFF?text=LC',
          isViewed: true,
        ),
      ],
    ),
    StoryGroup(
      groupId: 'music_stories',
      groupTitle: 'Music',
      color: const Color(0xffFFAB01),
      icon: Icons.music_note,
      hasUnviewedStories: true,
      stories: [
        Story(
          id: 'mus_1',
          title: 'Concert Night',
          content:
              'What an amazing concert night! The energy was incredible and everyone had a blast.',
          imageUrl:
              'https://via.placeholder.com/400x800/FFAB01/FFFFFF?text=Concert',
          timestamp: DateTime.now().subtract(const Duration(hours: 3)),
          authorName: 'Music Society',
          authorAvatarUrl:
              'https://via.placeholder.com/40x40/FFAB01/FFFFFF?text=MS',
        ),
        Story(
          id: 'mus_2',
          title: 'New Song',
          content:
              'Check out this new song our band just recorded! We\'re so excited to share it with you.',
          imageUrl:
              'https://via.placeholder.com/400x800/FFAB01/FFFFFF?text=New+Song',
          timestamp: DateTime.now().subtract(const Duration(hours: 7)),
          authorName: 'The Melodics',
          authorAvatarUrl:
              'https://via.placeholder.com/40x40/FFAB01/FFFFFF?text=TM',
        ),
      ],
    ),
    StoryGroup(
      groupId: 'math_stories',
      groupTitle: 'Math',
      color: const Color(0xff64FCD9),
      icon: Icons.calculate,
      hasUnviewedStories: false,
      stories: [
        Story(
          id: 'math_1',
          title: 'Problem Solving',
          content:
              'Today we solved some challenging mathematical problems. The solutions were elegant!',
          imageUrl:
              'https://via.placeholder.com/400x800/64FCD9/FFFFFF?text=Math+Problems',
          timestamp: DateTime.now().subtract(const Duration(days: 2)),
          authorName: 'Math Club',
          authorAvatarUrl:
              'https://via.placeholder.com/40x40/64FCD9/FFFFFF?text=MC',
          isViewed: true,
        ),
      ],
    ),
  ];

  List<StoryGroup> getAllStoryGroups() {
    return List.from(_storyGroups);
  }

  StoryGroup? getStoryGroupById(String groupId) {
    try {
      return _storyGroups.firstWhere((group) => group.groupId == groupId);
    } catch (e) {
      return null;
    }
  }

  void markStoryAsViewed(String storyId) {
    for (int i = 0; i < _storyGroups.length; i++) {
      final group = _storyGroups[i];
      final updatedStories = group.stories.map((story) {
        if (story.id == storyId) {
          return story.copyWith(isViewed: true);
        }
        return story;
      }).toList();

      // Check if all stories in group are viewed
      final hasUnviewedStories = updatedStories.any((story) => !story.isViewed);

      _storyGroups[i] = group.copyWith(
        stories: updatedStories,
        hasUnviewedStories: hasUnviewedStories,
      );
    }
  }

  void markAllStoriesInGroupAsViewed(String groupId) {
    for (int i = 0; i < _storyGroups.length; i++) {
      final group = _storyGroups[i];
      if (group.groupId == groupId) {
        final updatedStories = group.stories
            .map((story) => story.copyWith(isViewed: true))
            .toList();
        _storyGroups[i] = group.copyWith(
          stories: updatedStories,
          hasUnviewedStories: false,
        );
        break;
      }
    }
  }
}
