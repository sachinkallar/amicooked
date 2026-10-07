import 'dart:convert';
import 'package:http/http.dart' as http;
import '../scoring/cooked_models.dart';
import '../roast/roast_generator.dart';

abstract class LLMProvider {
  String get name;
  Future<String> generateRoast({
    required int score,
    required CategoryScores categoryScores,
    required List<String> roastTags,
    required Map<String, String> answers,
  });
}

class LocalRoastProvider implements LLMProvider {
  @override
  String get name => 'Offline Meme Engine';

  @override
  Future<String> generateRoast({
    required int score,
    required CategoryScores categoryScores,
    required List<String> roastTags,
    required Map<String, String> answers,
  }) async {
    return RoastGenerator.generateRoast(
      score: score,
      categoryScores: categoryScores,
      roastTags: roastTags,
      answers: answers,
    );
  }
}

class HuggingFaceInferenceProvider implements LLMProvider {
  final String apiToken;
  final String model;

  HuggingFaceInferenceProvider({
    required this.apiToken,
    this.model = 'Qwen/Qwen2.5-72B-Instruct',
  });

  @override
  String get name => 'Hugging Face Free Inference ($model)';

  @override
  Future<String> generateRoast({
    required int score,
    required CategoryScores categoryScores,
    required List<String> roastTags,
    required Map<String, String> answers,
  }) async {
    final prompt = """
You are the savage yet funny AI behind the viral app "AM I COOKED?".
The user just completed a test and got a Cooked Score of $score% (0 is raw/healthy, 100 is completely ruined).
Category Breakdown:
- Finance Cooked: ${categoryScores.finance}%
- Career Burnout: ${categoryScores.career}%
- Sleep Deprivation: ${categoryScores.sleep}%
- Screen Time: ${categoryScores.spending}%
- Mental Battery: ${categoryScores.lifestyle}%
Key traits identified: ${roastTags.join(', ')}.

Write a short, hilarious, personalized internet-culture roast (2-3 punchy paragraphs) addressing them.
Make it witty, playful, meme-infused, relatable, and finish with a memorable one-liner. Avoid actual abuse or offensive slurs.
""";

    final endpoint = Uri.parse('https://api-inference.huggingface.co/models/$model');

    final response = await http
        .post(
          endpoint,
          headers: {
            'Authorization': 'Bearer $apiToken',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'inputs': prompt,
            'parameters': {
              'max_new_tokens': 250,
              'temperature': 0.85,
              'return_full_text': false,
            },
          }),
        )
        .timeout(const Duration(seconds: 8));

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded is List && decoded.isNotEmpty && decoded[0]['generated_text'] != null) {
        return (decoded[0]['generated_text'] as String).trim();
      } else if (decoded is Map && decoded['generated_text'] != null) {
        return (decoded['generated_text'] as String).trim();
      }
    }

    throw Exception('Hugging Face API returned status ${response.statusCode}: ${response.body}');
  }
}

class LLMService {
  static final LLMService _instance = LLMService._internal();
  factory LLMService() => _instance;
  LLMService._internal();

  LLMProvider _provider = LocalRoastProvider();
  bool _useHuggingFace = false;
  String? _hfApiKey;
  String _hfModel = 'Qwen/Qwen2.5-72B-Instruct';

  LLMProvider get currentProvider => _provider;
  bool get isHuggingFaceEnabled => _useHuggingFace;
  String? get hfApiKey => _hfApiKey;
  String get hfModel => _hfModel;

  void configureHuggingFace({
    required bool enabled,
    String? apiKey,
    String? model,
  }) {
    _useHuggingFace = enabled;
    if (apiKey != null) _hfApiKey = apiKey;
    if (model != null) _hfModel = model;

    if (_useHuggingFace && _hfApiKey != null && _hfApiKey!.trim().isNotEmpty) {
      _provider = HuggingFaceInferenceProvider(
        apiToken: _hfApiKey!.trim(),
        model: _hfModel,
      );
    } else {
      _provider = LocalRoastProvider();
    }
  }

  /// Generates roast using active provider, with guaranteed local fallback.
  Future<String> generateRoast({
    required int score,
    required CategoryScores categoryScores,
    required List<String> roastTags,
    required Map<String, String> answers,
  }) async {
    try {
      if (_useHuggingFace && _provider is HuggingFaceInferenceProvider) {
        return await _provider.generateRoast(
          score: score,
          categoryScores: categoryScores,
          roastTags: roastTags,
          answers: answers,
        );
      }
    } catch (_) {
      // Fallback seamlessly on any failure
    }

    return LocalRoastProvider().generateRoast(
      score: score,
      categoryScores: categoryScores,
      roastTags: roastTags,
      answers: answers,
    );
  }
}
