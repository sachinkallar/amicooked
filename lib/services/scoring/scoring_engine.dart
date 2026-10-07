import '../roast/roast_generator.dart';
import 'cooked_models.dart';
import '../../features/assessment/questions_data.dart';

class ScoringWeights {
  final double finance;
  final double career;
  final double sleep;
  final double spending;
  final double lifestyle;

  const ScoringWeights({
    this.finance = 0.28,
    this.career = 0.22,
    this.sleep = 0.20,
    this.spending = 0.15,
    this.lifestyle = 0.15,
  });
}

class ScoringEngine {
  final ScoringWeights weights;

  const ScoringEngine({this.weights = const ScoringWeights()});

  /// Pure function that calculates a CookedResult from a map of questionId -> optionId
  CookedResult calculateCookedScore(Map<String, String> answers) {
    if (answers.isEmpty) {
      // Default baseline result
      final defaultCategory = const CategoryScores(
        finance: 50,
        career: 50,
        sleep: 50,
        spending: 50,
        lifestyle: 50,
      );
      final tier = CookedTier.fromScore(50);
      return CookedResult(
        score: 50,
        tier: '${tier.title} ${tier.emoji}',
        tierSlug: tier.slug,
        tierSubtitle: tier.subtitle,
        categoryScores: defaultCategory,
        roast: RoastGenerator.generateRoast(
          score: 50,
          categoryScores: defaultCategory,
          roastTags: [],
          answers: answers,
        ),
        recommendations: RoastGenerator.generateEmergencyPlan(
          score: 50,
          categoryScores: defaultCategory,
          roastTags: [],
        ),
        answers: answers,
        createdAt: DateTime.now(),
      );
    }

    // Category accumulators: sum of earned points and maximum possible points
    final categoryEarned = <CookedCategory, int>{
      CookedCategory.finance: 0,
      CookedCategory.career: 0,
      CookedCategory.sleep: 0,
      CookedCategory.spending: 0,
      CookedCategory.lifestyle: 0,
    };

    final categoryMax = <CookedCategory, int>{
      CookedCategory.finance: 0,
      CookedCategory.career: 0,
      CookedCategory.sleep: 0,
      CookedCategory.spending: 0,
      CookedCategory.lifestyle: 0,
    };

    final roastTags = <String>[];

    // Map questions for quick lookup
    for (final question in QuestionsData.allQuestions) {
      final selectedOptionId = answers[question.id];

      // Find max points possible for this question
      int maxOptionPoints = 10;
      if (question.options.isNotEmpty) {
        maxOptionPoints = question.options
            .map((o) => o.points)
            .reduce((a, b) => a > b ? a : b);
      }

      categoryMax[question.category] =
          (categoryMax[question.category] ?? 0) + maxOptionPoints;

      if (selectedOptionId != null) {
        final option = question.options.cast<QuestionOption?>().firstWhere(
              (o) => o?.id == selectedOptionId,
              orElse: () => null,
            );
        if (option != null) {
          categoryEarned[question.category] =
              (categoryEarned[question.category] ?? 0) + option.points;
          if (option.roastTag != null) {
            roastTags.add(option.roastTag!);
          }
        }
      }
    }

    // Helper to calculate percentage for category (0 - 100)
    int calcCatScore(CookedCategory cat) {
      final maxP = categoryMax[cat] ?? 1;
      if (maxP <= 0) return 0;
      final earned = categoryEarned[cat] ?? 0;
      final pct = ((earned / maxP) * 100).round();
      return pct.clamp(0, 100);
    }

    final catScores = CategoryScores(
      finance: calcCatScore(CookedCategory.finance),
      career: calcCatScore(CookedCategory.career),
      sleep: calcCatScore(CookedCategory.sleep),
      spending: calcCatScore(CookedCategory.spending),
      lifestyle: calcCatScore(CookedCategory.lifestyle),
    );

    // Weighted composite score
    final rawWeighted = (catScores.finance * weights.finance) +
        (catScores.career * weights.career) +
        (catScores.sleep * weights.sleep) +
        (catScores.spending * weights.spending) +
        (catScores.lifestyle * weights.lifestyle);

    final finalScore = rawWeighted.round().clamp(0, 100);
    final tier = CookedTier.fromScore(finalScore);

    final roast = RoastGenerator.generateRoast(
      score: finalScore,
      categoryScores: catScores,
      roastTags: roastTags,
      answers: answers,
    );

    final recommendations = RoastGenerator.generateEmergencyPlan(
      score: finalScore,
      categoryScores: catScores,
      roastTags: roastTags,
    );

    return CookedResult(
      score: finalScore,
      tier: '${tier.title} ${tier.emoji}',
      tierSlug: tier.slug,
      tierSubtitle: tier.subtitle,
      categoryScores: catScores,
      roast: roast,
      recommendations: recommendations,
      answers: answers,
      createdAt: DateTime.now(),
    );
  }
}
