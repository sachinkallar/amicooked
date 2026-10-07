import 'package:flutter/material.dart';
import '../../services/llm/llm_service.dart';
import '../storage/local_storage_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'shiny_button.dart';

class AISettingsDialog extends StatefulWidget {
  const AISettingsDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => const AISettingsDialog(),
    );
  }

  @override
  State<AISettingsDialog> createState() => _AISettingsDialogState();
}

class _AISettingsDialogState extends State<AISettingsDialog> {
  final LLMService _llmService = LLMService();
  late bool _enabled;
  late TextEditingController _tokenController;
  late TextEditingController _modelController;

  @override
  void initState() {
    super.initState();
    _enabled = LocalStorageService.getHfEnabled();
    _tokenController = TextEditingController(text: LocalStorageService.getHfToken() ?? '');
    _modelController = TextEditingController(text: _llmService.hfModel);
  }

  @override
  void dispose() {
    _tokenController.dispose();
    _modelController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final token = _tokenController.text.trim();
    await LocalStorageService.saveHfSettings(enabled: _enabled, token: token);
    _llmService.configureHuggingFace(
      enabled: _enabled,
      apiKey: token.isEmpty ? null : token,
      model: _modelController.text.trim().isNotEmpty
          ? _modelController.text.trim()
          : 'Qwen/Qwen2.5-72B-Instruct',
    );
    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.surfaceElevated,
          content: Text(
            _enabled
                ? '🤖 Hugging Face AI Reasoning enabled!'
                : '⚡ Using Offline Meme Engine (Default)',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surfaceElevated,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: AppColors.border),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.fireOrange.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text('🧠', style: TextStyle(fontSize: 24)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AI Reasoning Engine',
                          style: AppTypography.headingSmall(),
                        ),
                        Text(
                          'Optional free LLM roast generation',
                          style: AppTypography.bodySmall(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceHighlight,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Enable Hugging Face API', style: AppTypography.label()),
                          Text(
                            'When off, app uses instant offline templates.',
                            style: AppTypography.bodySmall(),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _enabled,
                      activeThumbColor: AppColors.fireOrange,
                      onChanged: (val) => setState(() => _enabled = val),
                    ),
                  ],
                ),
              ),
              if (_enabled) ...[
                const SizedBox(height: 16),
                Text('Hugging Face User Access Token (Free)', style: AppTypography.label(fontSize: 13)),
                const SizedBox(height: 6),
                TextField(
                  controller: _tokenController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'hf_xxxxxxxxxxxxxxxxxxxxxxxxx',
                    hintStyle: TextStyle(color: AppColors.textMuted.withValues(alpha: 0.7)),
                    filled: true,
                    fillColor: AppColors.surface,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.fireOrange),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text('Model ID (Serverless Inference)', style: AppTypography.label(fontSize: 13)),
                const SizedBox(height: 6),
                TextField(
                  controller: _modelController,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Qwen/Qwen2.5-72B-Instruct',
                    hintStyle: TextStyle(color: AppColors.textMuted.withValues(alpha: 0.7)),
                    filled: true,
                    fillColor: AppColors.surface,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.fireOrange),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '💡 If token is empty or API limits are hit, app automatically falls back to offline templates without interrupting you.',
                  style: AppTypography.bodySmall(fontSize: 12, color: AppColors.fireAmber),
                ),
              ],
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Cancel', style: TextStyle(color: AppColors.textMuted)),
                  ),
                  const SizedBox(width: 12),
                  ShinyButton(
                    text: 'Save Settings',
                    height: 44,
                    fontSize: 14,
                    onPressed: _save,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
