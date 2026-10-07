import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/shiny_button.dart';
import '../../services/scoring/cooked_models.dart';

class ChallengeScreen extends StatelessWidget {
  final int challengerScore;
  final String challengerTierSlug;

  const ChallengeScreen({
    super.key,
    this.challengerScore = 87,
    this.challengerTierSlug = 'absolutely-cooked',
  });

  @override
  Widget build(BuildContext context) {
    final tier = CookedTier.fromSlug(challengerTierSlug);
    final color = AppColors.getTierColor(challengerScore);
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 800;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 680),
        child: Column(
          children: [
            const SizedBox(height: 16),

            // Challenge Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: AppColors.fireRed.withValues(alpha: 0.4)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('⚔️', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                  Text(
                    'YOU HAVE BEEN OFFICIALLY CHALLENGED',
                    style: AppTypography.mono(fontSize: 11, color: AppColors.fireRed),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Headline
            Text(
              'YOUR FRIEND THINKS THEY’RE MORE COOKED THAN YOU.',
              textAlign: TextAlign.center,
              style: AppTypography.headingLarge(fontSize: isDesktop ? 34 : 26),
            ),

            const SizedBox(height: 12),

            Text(
              'They took the assessment and scored a horrifying $challengerScore%. Do you have what it takes to beat their bad life decisions?',
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium(),
            ),

            const SizedBox(height: 36),

            // Friend's Score Spotlight Card
            GlassCard(
              padding: const EdgeInsets.all(32),
              borderColor: color.withValues(alpha: 0.6),
              child: Column(
                children: [
                  Text(
                    'THEIR SCORE',
                    style: AppTypography.mono(fontSize: 12, color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '$challengerScore',
                        style: AppTypography.scoreDisplay(
                          fontSize: 72,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '%',
                        style: AppTypography.headingLarge(fontSize: 36, color: color),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: color.withValues(alpha: 0.4)),
                    ),
                    child: Text(
                      '${tier.emoji} ${tier.title}',
                      style: AppTypography.label(
                        fontSize: 14,
                        color: color,
                        weight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '“${tier.subtitle}”',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodySmall(fontSize: 13, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 36),

            // Primary Call to Action
            ShinyButton(
              text: '🔥 PROVE THEM WRONG (TAKE TEST)',
              height: 56,
              fontSize: 16,
              onPressed: () => context.go('/check'),
            ),

            const SizedBox(height: 16),

            ShinyButton(
              text: '🧮 Or Try a Mini Calculator',
              height: 50,
              fontSize: 15,
              variant: ShinyButtonVariant.outline,
              onPressed: () => context.go('/calculators'),
            ),

            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}
