import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/shiny_button.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 800;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 820),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Text(
                    'ABOUT & METHODOLOGY',
                    style: AppTypography.mono(fontSize: 12, color: AppColors.fireOrange),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'The Science of Being Cooked',
                    textAlign: TextAlign.center,
                    style: AppTypography.headingLarge(fontSize: isDesktop ? 36 : 28),
                  ),
                  const SizedBox(height: 12),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 580),
                    child: Text(
                      'How our completely unqualified algorithm calculates the exact temperature of your life.',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyMedium(),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 48),

            // Methodology Card
            GlassCard(
              padding: const EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('🔬', style: TextStyle(fontSize: 26)),
                      const SizedBox(width: 12),
                      Text('Algorithmic Methodology', style: AppTypography.headingSmall()),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Our proprietary Cooked Index™ evaluates five critical dimensions of modern adult dysfunction:',
                    style: AppTypography.bodyMedium(),
                  ),
                  const SizedBox(height: 16),
                  _buildPillar(
                    '💰 Financial Liquidity & EMI Delusion (28%)',
                    'Measures how fast you convert hard-earned money into Swiggy delivery fees, Apple subscriptions, and PayLater obligations.',
                  ),
                  _buildPillar(
                    '💻 Career Burnout & Himalayan Escapism (22%)',
                    'Calculates the ratio of times you consider quitting to start a goat farm versus actually updating your resume.',
                  ),
                  _buildPillar(
                    '😴 Sleep Debt & Circadian Ruin (20%)',
                    'Evaluates blue light exposure from 11:30 PM to 3:00 AM and how often your phone falls directly onto your face.',
                  ),
                  _buildPillar(
                    '📱 Screen-Time & Brainrot Saturation (15%)',
                    'Measures conscious waking hours donated to algorithmic short-form video dopamine loops.',
                  ),
                  _buildPillar(
                    '🧠 Existential Procrastination & "Monday" Myths (15%)',
                    'Tracks how many times you’ve planned to start your life tomorrow.',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // AI Reasoning Engine info
            GlassCard(
              padding: const EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('🤖', style: TextStyle(fontSize: 26)),
                      const SizedBox(width: 12),
                      Text('Pluggable Reasoning Engine', style: AppTypography.headingSmall()),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'AM I COOKED is architected with a decoupled reasoning layer. By default, it runs on our instant, deterministic Offline Meme Engine that works 100% locally with zero latency.\n\n'
                    'Users and developers can also plug in serverless inference via Hugging Face (such as Qwen 2.5 or Llama 3) for dynamic LLM roasts, with zero disruption fallback if API quotas are reached.',
                    style: AppTypography.bodyMedium(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Legal & Medical Disclaimer
            GlassCard(
              padding: const EdgeInsets.all(28),
              borderColor: AppColors.fireRed.withValues(alpha: 0.3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('⚠️', style: TextStyle(fontSize: 26)),
                      const SizedBox(width: 12),
                      Text('Mandatory Reality Check', style: AppTypography.headingSmall()),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'This web application is strictly for entertainment, comedic introspection, and viral amusement. None of the scores, emergency plans, or financial calculators constitute licensed financial advice, psychological diagnosis, or medical counsel.\n\n'
                    'If your finances, mental health, or sleep schedule are in actual crisis, please seek out qualified human professionals, put your phone in another room, and drink a large glass of water.',
                    style: AppTypography.bodySmall(fontSize: 13, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 48),

            Center(
              child: ShinyButton(
                text: '🔥 Enough Reading. Judge Me Now.',
                height: 56,
                fontSize: 16,
                onPressed: () => context.go('/check'),
              ),
            ),

            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildPillar(String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTypography.label(fontSize: 14, color: AppColors.fireAmber)),
            const SizedBox(height: 4),
            Text(desc, style: AppTypography.bodySmall(color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
