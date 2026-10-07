import 'package:flutter_test/flutter_test.dart';
import 'package:amicooked/services/scoring/scoring_engine.dart';
import 'package:amicooked/services/scoring/cooked_models.dart';
import 'package:amicooked/features/assessment/questions_data.dart';
import 'package:amicooked/features/calculators/data/mini_calculators_data.dart';
import 'package:amicooked/features/calculators/models/mini_calculator_model.dart';

void main() {
  group('ScoringEngine Unit Tests', () {
    const engine = ScoringEngine();

    test('Empty answers produces valid bounded baseline result', () {
      final result = engine.calculateCookedScore({});
      expect(result.score, greaterThanOrEqualTo(0));
      expect(result.score, lessThanOrEqualTo(100));
      expect(result.tier, isNotEmpty);
      expect(result.roast, isNotEmpty);
      expect(result.recommendations.length, inInclusiveRange(3, 5));
    });

    test('All best/wholesome answers produces RAW 🥩 tier (score <= 20)', () {
      final bestAnswers = <String, String>{};
      for (final q in QuestionsData.allQuestions) {
        bestAnswers[q.id] = q.options.first.id;
      }

      final result = engine.calculateCookedScore(bestAnswers);
      expect(result.score, lessThanOrEqualTo(20));
      expect(result.tierSlug, 'raw');
      expect(result.tier, contains('RAW'));
      expect(result.categoryScores.finance, lessThanOrEqualTo(20));
      expect(result.categoryScores.sleep, lessThanOrEqualTo(20));
    });

    test('All worst/degenerate answers produces critical score (>= 85)', () {
      final worstAnswers = <String, String>{};
      for (final q in QuestionsData.allQuestions) {
        worstAnswers[q.id] = q.options.last.id;
      }

      final result = engine.calculateCookedScore(worstAnswers);
      expect(result.score, greaterThanOrEqualTo(85));
      expect(result.score, lessThanOrEqualTo(100));
      expect(
        result.tierSlug == 'absolutely-cooked' || result.tierSlug == 'call-fire-brigade',
        isTrue,
      );
      expect(result.categoryScores.finance, greaterThanOrEqualTo(80));
      expect(result.categoryScores.sleep, greaterThanOrEqualTo(80));
    });

    test('Scoring is strictly deterministic for identical inputs', () {
      final sampleAnswers = {
        'q1_bank_app': 'q1_3',
        'q2_payday_math': 'q2_3',
        'q5_sleep_hours': 'q5_4',
        'q7_screen_time': 'q7_3',
      };

      final run1 = engine.calculateCookedScore(sampleAnswers);
      final run2 = engine.calculateCookedScore(sampleAnswers);

      expect(run1.score, equals(run2.score));
      expect(run1.tier, equals(run2.tier));
      expect(run1.categoryScores.finance, equals(run2.categoryScores.finance));
      expect(run1.categoryScores.sleep, equals(run2.categoryScores.sleep));
      expect(run1.roast, equals(run2.roast));
      expect(run1.recommendations, equals(run2.recommendations));
    });

    test('Category scores are isolated properly', () {
      // Only pick terrible finance answers, but perfect sleep answers
      final answers = <String, String>{};
      for (final q in QuestionsData.allQuestions) {
        if (q.category == CookedCategory.finance) {
          answers[q.id] = q.options.last.id; // worst
        } else if (q.category == CookedCategory.sleep) {
          answers[q.id] = q.options.first.id; // best
        }
      }

      final result = engine.calculateCookedScore(answers);
      expect(result.categoryScores.finance, greaterThan(result.categoryScores.sleep));
    });
  });

  group('Mini Calculators Unit Tests', () {
    test('All 10 mini calculators exist and have valid slugs', () {
      expect(MiniCalculatorsData.all.length, equals(10));
      for (final calc in MiniCalculatorsData.all) {
        expect(calc.slug, isNotEmpty);
        expect(calc.title, isNotEmpty);
        expect(calc.fields, isNotEmpty);
      }
    });

    test('Can I Afford This returns high cooked score when bank balance < item price', () {
      final calc = MiniCalculatorsData.getBySlug('can-i-afford-this');
      expect(calc, isNotNull);

      final result = calc!.compute({
        'item_price': 50000,
        'bank_balance': 2000,
        'days_until_payday': 20,
        'monthly_bills': 1000,
      });

      expect(result.cookedScore, greaterThanOrEqualTo(90));
      expect(result.verdictTitle, contains('CALL THE EMBASSY'));
    });

    test('Sleep Cooked Score calculates severe sleep debt', () {
      final calc = MiniCalculatorsData.getBySlug('sleep-cooked-score');
      expect(calc, isNotNull);

      final result = calc!.compute({
        'sleep_hours': 3,
        'bed_phone_min': 120,
        'caffeine_cups': 5,
      });

      expect(result.cookedScore, greaterThan(75));
      expect(result.verdictEmoji, contains('🧟'));
    });

    test('Every mini calculator executes with default field values without errors', () {
      for (final calc in MiniCalculatorsData.all) {
        final defaultInputs = <String, dynamic>{};
        for (final field in calc.fields) {
          if (field.type == CalculatorFieldType.dropdown) {
            defaultInputs[field.key] = field.defaultString ?? field.dropdownOptions?.first.value;
          } else {
            defaultInputs[field.key] = field.defaultValue ?? 0;
          }
        }

        final res = calc.compute(defaultInputs);
        expect(res.cookedScore, inInclusiveRange(0, 100), reason: 'Failed for ${calc.slug}');
        expect(res.verdictTitle, isNotEmpty);
        expect(res.verdictDescription, isNotEmpty);
      }
    });
  });
}
