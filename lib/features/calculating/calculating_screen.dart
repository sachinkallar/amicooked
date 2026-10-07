import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/shiny_button.dart';
import '../assessment/assessment_controller.dart';

class CalculatingScreen extends StatefulWidget {
  const CalculatingScreen({super.key});

  @override
  State<CalculatingScreen> createState() => _CalculatingScreenState();
}

class _CalculatingScreenState extends State<CalculatingScreen>
    with SingleTickerProviderStateMixin {
  final List<String> _stages = [
    'Analyzing your financial mistakes...',
    'Reviewing your sleep schedule...',
    'Checking your Amazon history...',
    'Consulting absolutely no professionals...',
    'Measuring questionable life choices...',
    'Performing advanced mathematics...',
    'Mostly vibes.',
  ];

  int _currentStageIndex = 0;
  bool _isResultReady = false;
  Timer? _timer;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    // Finalize assessment computation safely after initial frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<AssessmentController>().finalizeAssessment();
      }
    });

    // Progression timer across stages (roughly 2.8s total)
    _timer = Timer.periodic(const Duration(milliseconds: 400), (timer) {
      if (!mounted) return;
      if (_currentStageIndex < _stages.length - 1) {
        setState(() {
          _currentStageIndex++;
        });
      } else {
        timer.cancel();
        setState(() {
          _isResultReady = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: GlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
          borderColor: _isResultReady
              ? AppColors.fireOrange.withValues(alpha: 0.6)
              : AppColors.border,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Animated icon / Radar scanner
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, _) {
                  return Container(
                    width: 90,
                    height: 90,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.surfaceElevated,
                      border: Border.all(
                        color: _isResultReady ? AppColors.fireRed : AppColors.fireOrange,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (_isResultReady ? AppColors.fireRed : AppColors.fireOrange)
                              .withValues(alpha: 0.25 * _pulseController.value + 0.1),
                          blurRadius: 28,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: Text(
                      _isResultReady ? '🔥' : '🧮',
                      style: const TextStyle(fontSize: 40),
                    ),
                  );
                },
              ),

              const SizedBox(height: 32),

              // Title Status
              Text(
                _isResultReady ? 'RESULT READY.' : 'CALCULATING THE DAMAGE...',
                style: AppTypography.headingMedium(
                  color: _isResultReady ? AppColors.fireOrange : AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              // Animated step text
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: Text(
                  _stages[_currentStageIndex],
                  key: ValueKey<int>(_currentStageIndex),
                  textAlign: TextAlign.center,
                  style: AppTypography.mono(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),

              const SizedBox(height: 36),

              // Progress bar or CTA Button
              if (!_isResultReady) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 6,
                    width: 240,
                    color: const Color(0xFF1E1E28),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(
                        begin: 0.0,
                        end: (_currentStageIndex + 1) / _stages.length,
                      ),
                      duration: const Duration(milliseconds: 300),
                      builder: (context, val, _) {
                        return FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: val,
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: AppColors.fireGradient,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ] else ...[
                ShinyButton(
                  text: '🔥 SHOW ME THE DAMAGE',
                  height: 56,
                  fontSize: 16,
                  onPressed: () => context.go('/result'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
