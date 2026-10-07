import 'dart:convert';

enum CookedCategory {
  finance,
  career,
  sleep,
  spending,
  lifestyle,
}

extension CookedCategoryExtension on CookedCategory {
  String get displayName {
    switch (this) {
      case CookedCategory.finance:
        return '💰 FINANCES';
      case CookedCategory.career:
        return '💻 CAREER';
      case CookedCategory.sleep:
        return '😴 SLEEP';
      case CookedCategory.spending:
        return '📱 SCREEN TIME';
      case CookedCategory.lifestyle:
        return '🧠 MENTAL BATTERY';
    }
  }

  String get shortName {
    switch (this) {
      case CookedCategory.finance:
        return 'Finance';
      case CookedCategory.career:
        return 'Career';
      case CookedCategory.sleep:
        return 'Sleep';
      case CookedCategory.spending:
        return 'Screen Time';
      case CookedCategory.lifestyle:
        return 'Mental Battery';
    }
  }
}

class CategoryScores {
  final int finance;
  final int career;
  final int sleep;
  final int spending;
  final int lifestyle;

  const CategoryScores({
    required this.finance,
    required this.career,
    required this.sleep,
    required this.spending,
    required this.lifestyle,
  });

  Map<String, int> toMap() => {
        'finance': finance,
        'career': career,
        'sleep': sleep,
        'spending': spending,
        'lifestyle': lifestyle,
      };

  factory CategoryScores.fromMap(Map<String, dynamic> map) {
    return CategoryScores(
      finance: (map['finance'] as num?)?.toInt() ?? 50,
      career: (map['career'] as num?)?.toInt() ?? 50,
      sleep: (map['sleep'] as num?)?.toInt() ?? 50,
      spending: (map['spending'] as num?)?.toInt() ?? 50,
      lifestyle: (map['lifestyle'] as num?)?.toInt() ?? 50,
    );
  }

  int getForCategory(CookedCategory category) {
    switch (category) {
      case CookedCategory.finance:
        return finance;
      case CookedCategory.career:
        return career;
      case CookedCategory.sleep:
        return sleep;
      case CookedCategory.spending:
        return spending;
      case CookedCategory.lifestyle:
        return lifestyle;
    }
  }
}

class CookedTier {
  final String title;
  final String emoji;
  final String slug;
  final String subtitle;
  final int minScore;
  final int maxScore;

  const CookedTier({
    required this.title,
    required this.emoji,
    required this.slug,
    required this.subtitle,
    required this.minScore,
    required this.maxScore,
  });

  static const List<CookedTier> all = [
    CookedTier(
      title: 'RAW',
      emoji: '🥩',
      slug: 'raw',
      subtitle: 'Suspiciously well-adjusted. Are you even human?',
      minScore: 0,
      maxScore: 20,
    ),
    CookedTier(
      title: 'LIGHTLY TOASTED',
      emoji: '🍞',
      slug: 'lightly-toasted',
      subtitle: 'A few poor decisions, but still salvageable.',
      minScore: 21,
      maxScore: 40,
    ),
    CookedTier(
      title: 'GETTING WARM',
      emoji: '🌡️',
      slug: 'getting-warm',
      subtitle: 'The kitchen is heating up and your habits are suspect.',
      minScore: 41,
      maxScore: 60,
    ),
    CookedTier(
      title: 'PRETTY COOKED',
      emoji: '🍗',
      slug: 'pretty-cooked',
      subtitle: 'Golden brown, seasoned with panic, smelling like regret.',
      minScore: 61,
      maxScore: 80,
    ),
    CookedTier(
      title: 'ABSOLUTELY COOKED',
      emoji: '💀',
      slug: 'absolutely-cooked',
      subtitle: 'Charred beyond recognition. Seek adult supervision.',
      minScore: 81,
      maxScore: 95,
    ),
    CookedTier(
      title: 'CALL THE FIRE BRIGADE',
      emoji: '🚒🔥',
      slug: 'call-fire-brigade',
      subtitle: 'The smoke detectors are screaming. It’s over for you.',
      minScore: 96,
      maxScore: 100,
    ),
  ];

  static CookedTier fromScore(int score) {
    final clamped = score.clamp(0, 100);
    return all.firstWhere(
      (t) => clamped >= t.minScore && clamped <= t.maxScore,
      orElse: () => all.last,
    );
  }

  static CookedTier fromSlug(String slug) {
    return all.firstWhere(
      (t) => t.slug == slug,
      orElse: () => all[4], // default absolutely cooked
    );
  }
}

class QuestionOption {
  final String id;
  final String text;
  final String emoji;
  final int points; // 0 to 10
  final CookedCategory category;
  final String? roastTag;

  const QuestionOption({
    required this.id,
    required this.text,
    required this.emoji,
    required this.points,
    required this.category,
    this.roastTag,
  });
}

class AssessmentQuestion {
  final String id;
  final String text;
  final CookedCategory category;
  final String memeSubtitle;
  final List<QuestionOption> options;

  const AssessmentQuestion({
    required this.id,
    required this.text,
    required this.category,
    required this.memeSubtitle,
    required this.options,
  });
}

class CookedResult {
  final int score;
  final String tier;
  final String tierSlug;
  final String tierSubtitle;
  final CategoryScores categoryScores;
  final String roast;
  final List<String> recommendations;
  final Map<String, String> answers;
  final DateTime createdAt;

  const CookedResult({
    required this.score,
    required this.tier,
    required this.tierSlug,
    required this.tierSubtitle,
    required this.categoryScores,
    required this.roast,
    required this.recommendations,
    required this.answers,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        'score': score,
        'tier': tier,
        'tierSlug': tierSlug,
        'tierSubtitle': tierSubtitle,
        'categoryScores': categoryScores.toMap(),
        'roast': roast,
        'recommendations': recommendations,
        'answers': answers,
        'createdAt': createdAt.toIso8601String(),
      };

  factory CookedResult.fromMap(Map<String, dynamic> map) {
    return CookedResult(
      score: (map['score'] as num?)?.toInt() ?? 50,
      tier: (map['tier'] as String?) ?? 'PRETTY COOKED 🍗',
      tierSlug: (map['tierSlug'] as String?) ?? 'pretty-cooked',
      tierSubtitle: (map['tierSubtitle'] as String?) ?? '',
      categoryScores: CategoryScores.fromMap(
        map['categoryScores'] as Map<String, dynamic>? ?? {},
      ),
      roast: (map['roast'] as String?) ?? '',
      recommendations: (map['recommendations'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      answers: (map['answers'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, v.toString()),
          ) ??
          {},
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  String toJson() => jsonEncode(toMap());
  factory CookedResult.fromJson(String json) =>
      CookedResult.fromMap(jsonDecode(json) as Map<String, dynamic>);
}
