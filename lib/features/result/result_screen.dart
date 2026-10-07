import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/radial_score_gauge.dart';
import '../../core/widgets/shiny_button.dart';
import '../../services/scoring/cooked_models.dart';
import '../assessment/assessment_controller.dart';
import 'share_card_widget.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late ConfettiController _confettiController;
  bool _acceptedFate = false;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = context.read<AssessmentController>();
      final result = controller.latestResult;
      if (result != null && result.score <= 40) {
        _confettiController.play();
      }
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _shareResult(BuildContext context, CookedResult result) {
    final challengeUrl = 'https://amicooked.lol/challenge?score=${result.score}&tier=${result.tierSlug}';
    final shareText = '🔥 AM I COOKED? I got ${result.score}% (${result.tier})!\nThink you are more cooked than me? Try here: $challengeUrl';

    Clipboard.setData(ClipboardData(text: shareText));

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: AppColors.surfaceElevated,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: AppColors.border),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ShareCardWidget(result: result),
                const SizedBox(height: 20),
                Text(
                  '✅ Copied viral share link to clipboard!',
                  style: AppTypography.label(color: AppColors.fireAmber),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ShinyButton(
                        text: 'Challenge a Friend',
                        height: 48,
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          context.go('/challenge?score=${result.score}&tier=${result.tierSlug}');
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AssessmentController>();
    final result = controller.latestResult;

    if (result == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('💀', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            Text('No assessment results found', style: AppTypography.headingSmall()),
            const SizedBox(height: 12),
            ShinyButton(
              text: '🔥 Start Assessment',
              onPressed: () => context.go('/check'),
            ),
          ],
        ),
      );
    }

    final tier = CookedTier.fromScore(result.score);
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 800;

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        // Confetti for healthy / low-cooked winners
        ConfettiWidget(
          confettiController: _confettiController,
          blastDirectionality: BlastDirectionality.explosive,
          shouldLoop: false,
          colors: const [Colors.green, Colors.yellow, Colors.cyan, Colors.amber],
        ),

        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            children: [
              // Radial Gauge centerpiece
              RadialScoreGauge(
                targetScore: result.score,
                tier: tier,
                size: isDesktop ? 300 : 250,
              ),

              const SizedBox(height: 24),

              Text(
                result.tierSubtitle,
                textAlign: TextAlign.center,
                style: AppTypography.bodyLarge(
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 36),

              // Action buttons (Share & Challenge & Try Again)
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  ShinyButton(
                    text: '📤 SHARE MY SCORE',
                    height: 52,
                    fontSize: 15,
                    onPressed: () => _shareResult(context, result),
                  ),
                  ShinyButton(
                    text: '⚔️ CHALLENGE A FRIEND',
                    height: 52,
                    fontSize: 15,
                    variant: ShinyButtonVariant.outline,
                    onPressed: () => context.go('/challenge?score=${result.score}&tier=${result.tierSlug}'),
                  ),
                  ShinyButton(
                    text: '🔄 RETAKE TEST',
                    height: 52,
                    fontSize: 15,
                    variant: ShinyButtonVariant.secondary,
                    onPressed: () {
                      controller.resetAssessment();
                      context.go('/check');
                    },
                  ),
                ],
              ),

              const SizedBox(height: 48),

              // Category Cards breakdown
              _buildCategoryBreakdown(context, result, isDesktop),

              const SizedBox(height: 48),

              // Personalized Roast Card
              _buildRoastCard(result),

              const SizedBox(height: 48),

              // Emergency Plan
              _buildEmergencyPlan(result),

              const SizedBox(height: 60),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryBreakdown(
    BuildContext context,
    CookedResult result,
    bool isDesktop,
  ) {
    final categories = [
      {
        'title': '💰 FINANCES',
        'score': result.categoryScores.finance,
        'label': _getSeverityLabel(result.categoryScores.finance),
      },
      {
        'title': '💻 CAREER',
        'score': result.categoryScores.career,
        'label': _getSeverityLabel(result.categoryScores.career),
      },
      {
        'title': '😴 SLEEP',
        'score': result.categoryScores.sleep,
        'label': _getSeverityLabel(result.categoryScores.sleep),
      },
      {
        'title': '📱 SCREEN TIME',
        'score': result.categoryScores.spending,
        'label': _getSeverityLabel(result.categoryScores.spending),
      },
      {
        'title': '🧠 MENTAL BATTERY',
        'score': result.categoryScores.lifestyle,
        'label': _getSeverityLabel(result.categoryScores.lifestyle),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('📊', style: TextStyle(fontSize: 22)),
            const SizedBox(width: 8),
            Text('CATEGORY BREAKDOWN', style: AppTypography.headingSmall(fontSize: 18)),
          ],
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = isDesktop
                ? (constraints.maxWidth - 24) / 2
                : constraints.maxWidth;

            return Wrap(
              spacing: 24,
              runSpacing: 16,
              children: categories.map((cat) {
                final score = cat['score'] as int;
                final label = cat['label'] as String;
                final color = AppColors.getTierColor(score);

                return SizedBox(
                  width: cardWidth,
                  child: GlassCard(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(cat['title'] as String, style: AppTypography.label(fontSize: 14)),
                            ),
                            const SizedBox(width: 8),
                            Row(
                              children: [
                                Text(
                                  '$score%',
                                  style: AppTypography.mono(
                                    fontSize: 16,
                                    weight: FontWeight.w800,
                                    color: color,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: color.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    label,
                                    style: AppTypography.mono(
                                      fontSize: 10,
                                      weight: FontWeight.w700,
                                      color: color,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Container(
                            height: 6,
                            color: const Color(0xFF1E1E28),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: (score / 100.0).clamp(0.0, 1.0),
                              child: Container(
                                color: color,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  String _getSeverityLabel(int score) {
    if (score <= 25) return 'HEALTHY';
    if (score <= 50) return 'CONCERNING';
    if (score <= 75) return 'QUESTIONABLE';
    if (score <= 90) return 'CRITICAL';
    return 'SEEK HELP';
  }

  Widget _buildRoastCard(CookedResult result) {
    return GlassCard(
      padding: const EdgeInsets.all(28),
      borderColor: AppColors.fireOrange.withValues(alpha: 0.4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.fireRed.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text('🔥', style: TextStyle(fontSize: 22)),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('OFFICIAL ROAST', style: AppTypography.headingSmall(fontSize: 18)),
                  Text('Generated by our judgmental algorithm', style: AppTypography.bodySmall()),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Text(
              result.roast,
              style: AppTypography.bodyLarge(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyPlan(CookedResult result) {
    return GlassCard(
      padding: const EdgeInsets.all(28),
      borderColor: const Color(0xFFFFCC00).withValues(alpha: 0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFCC00).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text('🚨', style: TextStyle(fontSize: 22)),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('YOUR EMERGENCY PLAN', style: AppTypography.headingSmall(fontSize: 18)),
                  Text('Immediate steps before total catastrophe', style: AppTypography.bodySmall()),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Column(
            children: result.recommendations.map((rec) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      const Text('👉', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          rec,
                          style: AppTypography.label(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              '“You’ve got this. Probably.”',
              style: AppTypography.bodyMedium(
                color: AppColors.textMuted,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: ShinyButton(
              text: _acceptedFate ? '✅ FATE ACCEPTED' : '💀 I ACCEPT MY FATE',
              height: 48,
              variant: _acceptedFate ? ShinyButtonVariant.outline : ShinyButtonVariant.primary,
              onPressed: () {
                setState(() => _acceptedFate = true);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: AppColors.surfaceElevated,
                    content: Text(
                      'You have made peace with your questionable decisions. Good luck.',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
