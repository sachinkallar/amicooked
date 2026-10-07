import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LeaderboardEntry {
  final String id;
  final String nickname;
  final String avatar;
  final int cookedScore;
  final String badge;
  final String category;
  final String confession;
  final DateTime timestamp;

  const LeaderboardEntry({
    required this.id,
    required this.nickname,
    required this.avatar,
    required this.cookedScore,
    required this.badge,
    required this.category,
    required this.confession,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'nickname': nickname,
        'avatar': avatar,
        'cookedScore': cookedScore,
        'badge': badge,
        'category': category,
        'confession': confession,
        'timestamp': timestamp.toIso8601String(),
      };

  factory LeaderboardEntry.fromMap(Map<String, dynamic> map) {
    return LeaderboardEntry(
      id: map['id'] ?? '',
      nickname: map['nickname'] ?? 'Anonymous Cooked Soul',
      avatar: map['avatar'] ?? '💀',
      cookedScore: (map['cookedScore'] as num?)?.toInt() ?? 85,
      badge: map['badge'] ?? 'PRETTY COOKED',
      category: map['category'] ?? 'overall',
      confession: map['confession'] ?? '',
      timestamp: map['timestamp'] != null
          ? DateTime.tryParse(map['timestamp']) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}

abstract class ILeaderboardRepository {
  Future<List<LeaderboardEntry>> getEntries({String category = 'overall'});
  Future<void> submitEntry(LeaderboardEntry entry);
}

class LocalLeaderboardRepository implements ILeaderboardRepository {
  static const String _storageKey = 'am-i-cooked:leaderboard-custom';

  static final List<LeaderboardEntry> _mockEntries = [
    LeaderboardEntry(
      id: 'm1',
      nickname: 'Rahul "Zero Liquid" V.',
      avatar: '💸',
      cookedScore: 99,
      badge: 'FIRE BRIGADE 🚒',
      category: 'financial',
      confession: 'Bought an iPhone 16 Pro Max on 24-month EMI with ₹120 in my bank account.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 18)),
    ),
    LeaderboardEntry(
      id: 'm2',
      nickname: 'SleepIsAMyth99',
      avatar: '🧟',
      cookedScore: 97,
      badge: 'ZOMBIE SUPREME 💀',
      category: 'sleep',
      confession: 'Have slept 11 total hours from Monday to Friday. Currently hearing colors.',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    LeaderboardEntry(
      id: 'm3',
      nickname: 'Ananya "347 Unread Chats"',
      avatar: '📱',
      cookedScore: 95,
      badge: 'CYBORG SCROLLER ☢️',
      category: 'overall',
      confession: '14 hours 22 minutes daily screen time. Phone fell on my teeth at 3 AM.',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    LeaderboardEntry(
      id: 'm4',
      nickname: 'Senior Staff Slack Lurker',
      avatar: '🐐',
      cookedScore: 94,
      badge: 'BURNOUT LEGEND 💥',
      category: 'career',
      confession: 'Pondered leaving tech to herd Himalayan yaks 4 times before lunch today.',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    LeaderboardEntry(
      id: 'm5',
      nickname: 'Swiggy Diamond Patron',
      avatar: '🛵',
      cookedScore: 92,
      badge: 'DELIVERY JUNKIE 🍔',
      category: 'impulse',
      confession: 'Ordered iced coffee from a café 400 meters away because it was drizzle outside.',
      timestamp: DateTime.now().subtract(const Duration(hours: 7)),
    ),
    LeaderboardEntry(
      id: 'm6',
      nickname: 'Priya "Starts Tomorrow"',
      avatar: '🗓️',
      cookedScore: 89,
      badge: 'PROCRASTINATOR 🔄',
      category: 'overall',
      confession: 'Have renewed gym membership 3 times without visiting once since 2023.',
      timestamp: DateTime.now().subtract(const Duration(hours: 12)),
    ),
    LeaderboardEntry(
      id: 'm7',
      nickname: 'Vikram No-Budget',
      avatar: '📉',
      cookedScore: 88,
      badge: 'BALANCE COWARD 🫣',
      category: 'financial',
      confession: 'Closed banking app after OTP screen because seeing remaining balance made me dizzy.',
      timestamp: DateTime.now().subtract(const Duration(hours: 16)),
    ),
  ];

  @override
  Future<List<LeaderboardEntry>> getEntries({String category = 'overall'}) async {
    final list = List<LeaderboardEntry>.from(_mockEntries);
    try {
      final prefs = await SharedPreferences.getInstance();
      final customJson = prefs.getString(_storageKey);
      if (customJson != null) {
        final decoded = jsonDecode(customJson) as List;
        for (final item in decoded) {
          list.add(LeaderboardEntry.fromMap(item as Map<String, dynamic>));
        }
      }
    } catch (_) {}

    // Filter by category if not overall
    final filtered = category == 'overall'
        ? list
        : list.where((e) => e.category == category || e.category == 'overall').toList();

    filtered.sort((a, b) => b.cookedScore.compareTo(a.cookedScore));
    return filtered;
  }

  @override
  Future<void> submitEntry(LeaderboardEntry entry) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final customJson = prefs.getString(_storageKey);
      final list = <Map<String, dynamic>>[];
      if (customJson != null) {
        list.addAll((jsonDecode(customJson) as List).cast<Map<String, dynamic>>());
      }
      list.insert(0, entry.toMap());
      await prefs.setString(_storageKey, jsonEncode(list.take(20).toList()));
    } catch (_) {}
  }
}
