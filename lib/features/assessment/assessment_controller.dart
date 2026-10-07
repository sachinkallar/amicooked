import 'package:flutter/foundation.dart';
import '../../core/storage/local_storage_service.dart';
import '../../services/scoring/cooked_models.dart';
import '../../services/scoring/scoring_engine.dart';
import '../../services/llm/llm_service.dart';
import 'questions_data.dart';

class AssessmentController extends ChangeNotifier {
  final ScoringEngine _scoringEngine = const ScoringEngine();
  final LLMService _llmService = LLMService();

  int _currentIndex = 0;
  Map<String, String> _answers = {};
  bool _isInitialized = false;
  bool _isCalculating = false;
  CookedResult? _latestResult;

  int get currentIndex => _currentIndex;
  Map<String, String> get answers => _answers;
  bool get isInitialized => _isInitialized;
  bool get isCalculating => _isCalculating;
  CookedResult? get latestResult => _latestResult;

  int get totalQuestions => QuestionsData.allQuestions.length;
  AssessmentQuestion get currentQuestion =>
      QuestionsData.allQuestions[_currentIndex.clamp(0, totalQuestions - 1)];

  double get progress => (_currentIndex + 1) / totalQuestions;
  bool get canGoBack => _currentIndex > 0;
  bool get isLastQuestion => _currentIndex == totalQuestions - 1;
  bool get isCurrentAnswered => _answers.containsKey(currentQuestion.id);

  AssessmentController() {
    init();
  }

  Future<void> init() async {
    if (_isInitialized) return;
    final saved = LocalStorageService.getAssessmentProgress();
    if (saved.isNotEmpty) {
      _answers = Map<String, String>.from(saved);
      // Resume at the first unanswered question or last
      final unansweredIndex = QuestionsData.allQuestions.indexWhere(
        (q) => !_answers.containsKey(q.id),
      );
      if (unansweredIndex != -1) {
        _currentIndex = unansweredIndex;
      } else {
        _currentIndex = totalQuestions - 1;
      }
    }
    _latestResult = LocalStorageService.getLatestResult();
    _isInitialized = true;
    notifyListeners();
  }

  void selectOption(String questionId, String optionId) {
    _answers[questionId] = optionId;
    LocalStorageService.saveAssessmentProgress(_answers);
    notifyListeners();
  }

  bool nextQuestion() {
    if (_currentIndex < totalQuestions - 1) {
      _currentIndex++;
      notifyListeners();
      return true;
    }
    return false;
  }

  bool previousQuestion() {
    if (_currentIndex > 0) {
      _currentIndex--;
      notifyListeners();
      return true;
    }
    return false;
  }

  void goToQuestion(int index) {
    if (index >= 0 && index < totalQuestions) {
      _currentIndex = index;
      notifyListeners();
    }
  }

  Future<CookedResult> finalizeAssessment() async {
    _isCalculating = true;
    notifyListeners();

    // 1. Calculate base deterministic score
    final baseResult = _scoringEngine.calculateCookedScore(_answers);

    // 2. Check if LLM roast enhancement is enabled
    String finalRoast = baseResult.roast;
    try {
      final roastTags = <String>[];
      for (final q in QuestionsData.allQuestions) {
        final optId = _answers[q.id];
        if (optId != null) {
          final opt = q.options.cast<QuestionOption?>().firstWhere(
                (o) => o?.id == optId,
                orElse: () => null,
              );
          if (opt?.roastTag != null) roastTags.add(opt!.roastTag!);
        }
      }

      finalRoast = await _llmService.generateRoast(
        score: baseResult.score,
        categoryScores: baseResult.categoryScores,
        roastTags: roastTags,
        answers: _answers,
      );
    } catch (_) {
      finalRoast = baseResult.roast;
    }

    final enrichedResult = CookedResult(
      score: baseResult.score,
      tier: baseResult.tier,
      tierSlug: baseResult.tierSlug,
      tierSubtitle: baseResult.tierSubtitle,
      categoryScores: baseResult.categoryScores,
      roast: finalRoast,
      recommendations: baseResult.recommendations,
      answers: Map<String, String>.from(_answers),
      createdAt: DateTime.now(),
    );

    _latestResult = enrichedResult;
    await LocalStorageService.saveLatestResult(enrichedResult);
    await LocalStorageService.clearAssessmentProgress();

    _isCalculating = false;
    notifyListeners();
    return enrichedResult;
  }

  void resetAssessment() {
    _currentIndex = 0;
    _answers.clear();
    LocalStorageService.clearAssessmentProgress();
    notifyListeners();
  }

  void setLatestResult(CookedResult result) {
    _latestResult = result;
    notifyListeners();
  }
}
