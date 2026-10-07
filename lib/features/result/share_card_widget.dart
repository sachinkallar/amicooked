import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../services/scoring/cooked_models.dart';

class ShareCardWidget extends StatelessWidget {
  final CookedResult result;

  const ShareCardWidget({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final tierColor = AppColors.getTierColor(result.score);

    return Container(
      width: 380,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: const Color(0xFF0F0F14),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: tierColor.withValues(alpha: 0.5), width: 2),
        boxShadow: [
          BoxShadow(
            color: tierColor.withValues(alpha: 0.25),
            blurRadius: 30,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.8),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Header Logo & URL
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text('🔥', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 6),
                  Text(
                    'AM I COOKED?',
                    style: AppTypography.headingSmall(fontSize: 14),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  'amicooked.lol',
                  style: AppTypography.mono(fontSize: 11, color: AppColors.textMuted),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Big Score Circle
          Container(
            width: 140,
            height: 140,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surface,
              border: Border.all(color: tierColor, width: 4),
              boxShadow: [
                BoxShadow(
                  color: tierColor.withValues(alpha: 0.35),
                  blurRadius: 24,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${result.score}%',
                  style: AppTypography.scoreDisplay(
                    fontSize: 44,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'COOKED',
                  style: AppTypography.mono(
                    fontSize: 11,
                    weight: FontWeight.w800,
                    color: tierColor,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Tier Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: tierColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: tierColor.withValues(alpha: 0.4)),
            ),
            child: Text(
              result.tier,
              style: AppTypography.label(
                fontSize: 14,
                weight: FontWeight.w800,
                color: tierColor,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Punchline
          Text(
            result.tierSubtitle,
            textAlign: TextAlign.center,
            style: AppTypography.bodySmall(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 20),
          const Divider(color: AppColors.border),
          const SizedBox(height: 12),

          // Mini breakdown preview
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMiniCat(
                '💰 Money',
                '${result.categoryScores.finance}%',
                AppColors.getTierColor(result.categoryScores.finance),
              ),
              _buildMiniCat(
                '😴 Sleep',
                '${result.categoryScores.sleep}%',
                AppColors.getTierColor(result.categoryScores.sleep),
              ),
              _buildMiniCat(
                '💻 Career',
                '${result.categoryScores.career}%',
                AppColors.getTierColor(result.categoryScores.career),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Challenge Footer
          Text(
            'THINK YOU ARE MORE COOKED? PROVE IT.',
            style: AppTypography.mono(fontSize: 10, color: AppColors.fireAmber),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniCat(String title, String val, Color color) {
    return Column(
      children: [
        Text(title, style: AppTypography.bodySmall(fontSize: 11)),
        const SizedBox(height: 2),
        Text(val, style: AppTypography.mono(fontSize: 14, color: color, weight: FontWeight.w800)),
      ],
    );
  }
}
