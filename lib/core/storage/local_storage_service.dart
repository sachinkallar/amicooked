import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/scoring/cooked_models.dart';

class LocalStorageService {
  static const String keyAssessment = 'am-i-cooked:assessment';
  static const String keyLatestResult = 'am-i-cooked:latest-result';
  static const String keyHistory = 'am-i-cooked:history';
  static const String keyHfToken = 'am-i-cooked:hf-token';
  static const String keyHfEnabled = 'am-i-cooked:hf-enabled';

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
    } catch (_) {
      // Fallback if shared_preferences fails
    }
  }

  // --- Assessment In-Progress Answers ---
  static Future<void> saveAssessmentProgress(Map<String, String> answers) async {
    try {
      if (_prefs == null) await init();
      await _prefs?.setString(keyAssessment, jsonEncode(answers));
    } catch (_) {}
  }

  static Map<String, String> getAssessmentProgress() {
    try {
      final str = _prefs?.getString(keyAssessment);
      if (str == null || str.isEmpty) return {};
      final decoded = jsonDecode(str);
      if (decoded is Map) {
        return decoded.map((k, v) => MapEntry(k.toString(), v.toString()));
      }
    } catch (_) {}
    return {};
  }

  static Future<void> clearAssessmentProgress() async {
    try {
      if (_prefs == null) await init();
      await _prefs?.remove(keyAssessment);
    } catch (_) {}
  }

  // --- Latest Result ---
  static Future<void> saveLatestResult(CookedResult result) async {
    try {
      if (_prefs == null) await init();
      await _prefs?.setString(keyLatestResult, result.toJson());
      await appendToHistory(result);
    } catch (_) {}
  }

  static CookedResult? getLatestResult() {
    try {
      final str = _prefs?.getString(keyLatestResult);
      if (str == null || str.isEmpty) return null;
      return CookedResult.fromJson(str);
    } catch (_) {
      return null;
    }
  }

  // --- History (Max 10) ---
  static Future<void> appendToHistory(CookedResult result) async {
    try {
      final history = getHistory();
      // Prepend newest result
      final updated = [result, ...history.where((r) => r.createdAt != result.createdAt)];
      final capped = updated.take(10).toList();
      final encodedList = capped.map((r) => r.toMap()).toList();
      await _prefs?.setString(keyHistory, jsonEncode(encodedList));
    } catch (_) {}
  }

  static List<CookedResult> getHistory() {
    try {
      final str = _prefs?.getString(keyHistory);
      if (str == null || str.isEmpty) return [];
      final decoded = jsonDecode(str);
      if (decoded is List) {
        return decoded
            .map((item) {
              try {
                return CookedResult.fromMap(item as Map<String, dynamic>);
              } catch (_) {
                return null;
              }
            })
            .whereType<CookedResult>()
            .toList();
      }
    } catch (_) {}
    return [];
  }

  // --- Hugging Face Token & Setting ---
  static String? getHfToken() => _prefs?.getString(keyHfToken);
  static bool getHfEnabled() => _prefs?.getBool(keyHfEnabled) ?? false;

  static Future<void> saveHfSettings({required bool enabled, String? token}) async {
    try {
      if (_prefs == null) await init();
      await _prefs?.setBool(keyHfEnabled, enabled);
      if (token != null) {
        await _prefs?.setString(keyHfToken, token);
      }
    } catch (_) {}
  }
}
