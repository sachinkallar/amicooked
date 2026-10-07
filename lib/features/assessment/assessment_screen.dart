import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/glass_card.dart';
import '../../services/scoring/cooked_models.dart';
import 'assessment_controller.dart';

class AssessmentScreen extends StatefulWidget {
  const AssessmentScreen({super.key});

  @override
  State<AssessmentScreen> createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen> {
  final FocusNode _keyboardFocusNode = FocusNode();
  bool _isAutoAdvancing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _keyboardFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _keyboardFocusNode.dispose();
    super.dispose();
  }

  void _handleOptionSelect(
    AssessmentController controller,
    String questionId,
    String optionId,
  ) async {
    if (_isAutoAdvancing) return;
    _isAutoAdvancing = true;

    controller.selectOption(questionId, optionId);

    // Brief delay for visual feedback before auto-advancing
    await Future.delayed(const Duration(milliseconds: 280));
    if (!mounted) return;

    if (controller.isLastQuestion) {
      _isAutoAdvancing = false;
      context.go('/calculating');
    } else {
      controller.nextQuestion();
      _isAutoAdvancing = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AssessmentController>(
      builder: (context, controller, child) {
        if (!controller.isInitialized) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.fireOrange),
          );
        }

        final currentQuestion = controller.currentQuestion;
        final selectedOptionId = controller.answers[currentQuestion.id];
        final screenWidth = MediaQuery.of(context).size.width;
        final isDesktop = screenWidth >= 700;

        return KeyboardListener(
          focusNode: _keyboardFocusNode,
          autofocus: true,
          onKeyEvent: (event) {
            if (event is KeyDownEvent) {
              if (event.logicalKey == LogicalKeyboardKey.digit1 && currentQuestion.options.isNotEmpty) {
                _handleOptionSelect(controller, currentQuestion.id, currentQuestion.options[0].id);
              } else if (event.logicalKey == LogicalKeyboardKey.digit2 && currentQuestion.options.length > 1) {
                _handleOptionSelect(controller, currentQuestion.id, currentQuestion.options[1].id);
              } else if (event.logicalKey == LogicalKeyboardKey.digit3 && currentQuestion.options.length > 2) {
                _handleOptionSelect(controller, currentQuestion.id, currentQuestion.options[2].id);
              } else if (event.logicalKey == LogicalKeyboardKey.digit4 && currentQuestion.options.length > 3) {
                _handleOptionSelect(controller, currentQuestion.id, currentQuestion.options[3].id);
              } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft && controller.canGoBack) {
                controller.previousQuestion();
              }
            }
          },
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 780),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top navigation: Back button & Question index
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (controller.canGoBack)
                      TextButton.icon(
                        onPressed: () => controller.previousQuestion(),
                        icon: const Icon(Icons.arrow_back_rounded, size: 18, color: AppColors.textSecondary),
                        label: Text(
                          'Back',
                          style: AppTypography.label(color: AppColors.textSecondary),
                        ),
                      )
                    else
                      TextButton.icon(
                        onPressed: () => context.go('/'),
                        icon: const Icon(Icons.close_rounded, size: 18, color: AppColors.textMuted),
                        label: Text(
                          'Exit',
                          style: AppTypography.label(color: AppColors.textMuted),
                        ),
                      ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceElevated,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Text(
                        'Question ${controller.currentIndex + 1} / ${controller.totalQuestions}',
                        style: AppTypography.mono(fontSize: 12, color: AppColors.fireAmber),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Smooth Progress Bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 8,
                    color: const Color(0xFF1A1A24),
                    child: AnimatedFractionallySizedBox(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutCubic,
                      alignment: Alignment.centerLeft,
                      widthFactor: controller.progress,
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: AppColors.fireGradient,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 36),

                // Category pill
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.fireOrange.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.fireOrange.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    currentQuestion.category.displayName,
                    style: AppTypography.mono(fontSize: 12, color: AppColors.fireOrange),
                  ),
                ),

                const SizedBox(height: 16),

                // Question Text
                Text(
                  currentQuestion.text,
                  style: AppTypography.headingLarge(
                    fontSize: isDesktop ? 30 : 22,
                  ),
                ),

                const SizedBox(height: 8),

                // Humorous meme subtitle
                Text(
                  currentQuestion.memeSubtitle,
                  style: AppTypography.bodyMedium(
                    color: AppColors.textMuted,
                  ),
                ),

                const SizedBox(height: 32),

                // Options list (4 items)
                Column(
                  children: currentQuestion.options.asMap().entries.map((entry) {
                    final index = entry.key;
                    final option = entry.value;
                    final isSelected = selectedOptionId == option.id;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: GlassCard(
                        isSelected: isSelected,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                        onTap: () => _handleOptionSelect(
                          controller,
                          currentQuestion.id,
                          option.id,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.fireOrange.withValues(alpha: 0.25)
                                    : AppColors.surfaceHighlight,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected ? AppColors.fireOrange : AppColors.border,
                                ),
                              ),
                              child: Text(
                                option.emoji,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                option.text,
                                style: AppTypography.label(
                                  fontSize: isDesktop ? 15 : 14,
                                  color: isSelected ? Colors.white : AppColors.textPrimary,
                                  weight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                ),
                              ),
                            ),
                            if (isDesktop) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '${index + 1}',
                                  style: AppTypography.mono(
                                    fontSize: 11,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 20),

                // Accessibility & Keyboard helper hint
                if (isDesktop)
                  Center(
                    child: Text(
                      '💡 Press 1–4 to pick an answer • ← arrow to go back',
                      style: AppTypography.bodySmall(fontSize: 12, color: AppColors.textMuted),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
