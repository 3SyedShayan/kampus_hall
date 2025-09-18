import 'package:flutter/material.dart';
import '../models/society.dart';

class SocietyService {
  static final SocietyService _instance = SocietyService._internal();
  factory SocietyService() => _instance;
  SocietyService._internal();

  // Mock current user ID - in a real app this would come from authentication
  static const String currentUserId = 'user_123';

  // Mock data storage - in a real app this would be a database
  final List<Society> _societies = [
    Society(
      id: 'soc_1',
      title: 'Xup Studio',
      subtitle: 'Music Society',
      color: const Color(0xffB18CFE),
      description: 'A creative space for music enthusiasts to collaborate, learn, and perform together.',
      tags: ['music', 'creative', 'performance'],
      memberCount: 127,
      createdAt: DateTime.now().subtract(const Duration(days: 180)),
    ),
    Society(
      id: 'soc_2',
      title: 'Welfare So',
      subtitle: 'Social Impact',
      color: const Color(0xff64FCD9),
      description: 'Working together to make a positive impact in our community through various social initiatives.',
      tags: ['social', 'impact', 'volunteer'],
      memberCount: 89,
      createdAt: DateTime.now().subtract(const Duration(days: 120)),
    ),
    Society(
      id: 'soc_3',
      title: 'Tech Club',
      subtitle: 'Technology',
      color: const Color(0xffEE719E),
      description: 'Exploring the latest in technology, coding workshops, and tech innovation projects.',
      tags: ['technology', 'coding', 'innovation'],
      memberCount: 156,
      createdAt: DateTime.now().subtract(const Duration(days: 90)),
    ),
    Society(
      id: 'soc_4',
      title: 'Green Earth',
      subtitle: 'Environmental',
      color: const Color(0xff4CAF50),
      description: 'Dedicated to environmental conservation and sustainable living practices.',
      tags: ['environment', 'sustainability', 'green'],
      memberCount: 67,
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
    ),
    Society(
      id: 'soc_5',
      title: 'Art Canvas',
      subtitle: 'Visual Arts',
      color: const Color(0xffFF8C82),
      description: 'A community for artists to showcase their work and learn new techniques.',
      tags: ['art', 'visual', 'creative'],
      memberCount: 94,
      createdAt: DateTime.now().subtract(const Duration(days: 45)),
    ),
    Society(
      id: 'soc_6',
      title: 'Sports Hub',
      subtitle: 'Athletics',
      color: const Color(0xffFFAB01),
      description: 'Bringing together sports enthusiasts for various athletic activities and competitions.',
      tags: ['sports', 'athletics', 'fitness'],
      memberCount: 203,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
  ];

  final List<UserSocietyMembership> _memberships = [
    UserSocietyMembership(
      societyId: 'soc_1',
      userId: currentUserId,
      joinedAt: DateTime.now().subtract(const Duration(days: 30)),
      role: 'member',
    ),
    UserSocietyMembership(
      societyId: 'soc_3',
      userId: currentUserId,
      joinedAt: DateTime.now().subtract(const Duration(days: 15)),
      role: 'admin',
    ),
  ];

  // Get all available societies
  List<Society> getAllSocieties() {
    return List.unmodifiable(_societies);
  }

  // Get societies that the current user has joined
  List<Society> getJoinedSocieties({String? userId}) {
    final targetUserId = userId ?? currentUserId;
    final userMemberships = _memberships
        .where((membership) => 
            membership.userId == targetUserId && 
            membership.isActive)
        .map((membership) => membership.societyId)
        .toSet();

    return _societies
        .where((society) => userMemberships.contains(society.id))
        .toList();
  }

  // Get societies that the user hasn't joined yet
  List<Society> getAvailableSocieties({String? userId}) {
    final targetUserId = userId ?? currentUserId;
    final userMemberships = _memberships
        .where((membership) => 
            membership.userId == targetUserId && 
            membership.isActive)
        .map((membership) => membership.societyId)
        .toSet();

    return _societies
        .where((society) => !userMemberships.contains(society.id))
        .toList();
  }

  // Check if user is member of a society
  bool isMemberOfSociety(String societyId, {String? userId}) {
    final targetUserId = userId ?? currentUserId;
    return _memberships.any((membership) =>
        membership.societyId == societyId &&
        membership.userId == targetUserId &&
        membership.isActive);
  }

  // Join a society
  Future<bool> joinSociety(String societyId, {String? userId}) async {
    final targetUserId = userId ?? currentUserId;
    
    // Check if already a member
    if (isMemberOfSociety(societyId, userId: targetUserId)) {
      return false;
    }

    // Check if society exists
    if (!_societies.any((society) => society.id == societyId)) {
      return false;
    }

    // Add membership
    _memberships.add(UserSocietyMembership(
      societyId: societyId,
      userId: targetUserId,
      joinedAt: DateTime.now(),
      role: 'member',
    ));

    // Update member count
    final societyIndex = _societies.indexWhere((s) => s.id == societyId);
    if (societyIndex != -1) {
      _societies[societyIndex] = _societies[societyIndex].copyWith(
        memberCount: _societies[societyIndex].memberCount + 1,
      );
    }

    return true;
  }

  // Leave a society
  Future<bool> leaveSociety(String societyId, {String? userId}) async {
    final targetUserId = userId ?? currentUserId;
    
    // Find and remove membership
    final membershipIndex = _memberships.indexWhere((membership) =>
        membership.societyId == societyId &&
        membership.userId == targetUserId &&
        membership.isActive);

    if (membershipIndex == -1) {
      return false;
    }

    _memberships.removeAt(membershipIndex);

    // Update member count
    final societyIndex = _societies.indexWhere((s) => s.id == societyId);
    if (societyIndex != -1) {
      _societies[societyIndex] = _societies[societyIndex].copyWith(
        memberCount: _societies[societyIndex].memberCount - 1,
      );
    }

    return true;
  }

  // Get society by ID
  Society? getSocietyById(String societyId) {
    try {
      return _societies.firstWhere((society) => society.id == societyId);
    } catch (e) {
      return null;
    }
  }

  // Get user's role in a society
  String? getUserRoleInSociety(String societyId, {String? userId}) {
    final targetUserId = userId ?? currentUserId;
    try {
      final membership = _memberships.firstWhere((membership) =>
          membership.societyId == societyId &&
          membership.userId == targetUserId &&
          membership.isActive);
      return membership.role;
    } catch (e) {
      return null;
    }
  }

  // Search societies by title or tags
  List<Society> searchSocieties(String query) {
    final lowercaseQuery = query.toLowerCase();
    return _societies.where((society) =>
        society.title.toLowerCase().contains(lowercaseQuery) ||
        society.subtitle.toLowerCase().contains(lowercaseQuery) ||
        society.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery))).toList();
  }
}