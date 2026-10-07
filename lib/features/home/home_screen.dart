import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/shiny_button.dart';
import '../../services/scoring/cooked_models.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 800;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 24),

        // Live viral ticker badge
        _buildViralBadge(),

        const SizedBox(height: 28),

        // Massive Hero Title
        _buildHeroSection(context, isDesktop),

        const SizedBox(height: 64),

        // "How it works" section
        _buildHowItWorks(context, isDesktop),

        const SizedBox(height: 72),

        // Cooked Tier Spectrum
        _buildTiersSpectrum(context, isDesktop),

        const SizedBox(height: 72),

        // Featured Mini Calculators Grid
        _buildMiniCalculatorsPreview(context, isDesktop),

        const SizedBox(height: 60),

        // Bottom Final Call to Action
        _buildBottomBanner(context),
      ],
    );
  }

  Widget _buildViralBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.fireOrange.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: AppColors.fireOrange.withValues(alpha: 0.15),
            blurRadius: 16,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.fireOrange,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '🔥 OVER 1,480,200 LIVES JUDGED • AVERAGE SCORE: 81% COOKED',
            style: AppTypography.mono(fontSize: 11, color: AppColors.fireAmber),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, bool isDesktop) {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Colors.white, Color(0xFFFFF0E6), AppColors.fireAmber],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(bounds),
          child: Text(
            'AM I COOKED?',
            textAlign: TextAlign.center,
            style: AppTypography.heroTitle(
              fontSize: isDesktop ? 76 : 46,
            ),
          ),
        ),
        const SizedBox(height: 18),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Text(
            'A scientifically questionable assessment of how badly you’re doing in life, finances, sleep, and questionable 2 AM decisions.',
            textAlign: TextAlign.center,
            style: AppTypography.bodyLarge(
              fontSize: isDesktop ? 20 : 16,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        const SizedBox(height: 36),
        Wrap(
          spacing: 16,
          runSpacing: 14,
          alignment: WrapAlignment.center,
          children: [
            ShinyButton(
              text: '🔥 CHECK HOW COOKED I AM',
              height: 58,
              fontSize: 16,
              onPressed: () => context.go('/check'),
            ),
            ShinyButton(
              text: '🧮 TRY A MINI CALCULATOR',
              height: 58,
              fontSize: 16,
              variant: ShinyButtonVariant.outline,
              onPressed: () => context.go('/calculators'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHowItWorks(BuildContext context, bool isDesktop) {
    final steps = [
      {
        'num': '01',
        'title': 'ANSWER',
        'desc': 'Tell us about your questionable financial, sleep, and career decisions.',
        'icon': '📝',
      },
      {
        'num': '02',
        'title': 'GET JUDGED',
        'desc': 'Our extremely unqualified algorithmic vibes engine analyzes the damage.',
        'icon': '⚖️',
      },
      {
        'num': '03',
        'title': 'ACCEPT YOUR FATE',
        'desc': 'Receive your 0–100% score, personalized savage roast, and emergency plan.',
        'icon': '💀',
      },
    ];

    return Column(
      children: [
        Text(
          'HOW IT WORKS',
          style: AppTypography.mono(fontSize: 12, color: AppColors.fireOrange),
        ),
        const SizedBox(height: 8),
        Text(
          'Three Steps to Existential Clarity',
          style: AppTypography.headingLarge(fontSize: isDesktop ? 34 : 26),
        ),
        const SizedBox(height: 36),
        LayoutBuilder(
          builder: (context, constraints) {
            if (isDesktop) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: steps.map((s) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: _buildStepCard(s),
                    ),
                  );
                }).toList(),
              );
            } else {
              return Column(
                children: steps.map((s) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildStepCard(s),
                  );
                }).toList(),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildStepCard(Map<String, String> step) {
    return GlassCard(
      padding: const EdgeInsets.all(26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                step['icon']!,
                style: const TextStyle(fontSize: 32),
              ),
              Text(
                step['num']!,
                style: AppTypography.mono(
                  fontSize: 22,
                  weight: FontWeight.w900,
                  color: AppColors.fireOrange.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            step['title']!,
            style: AppTypography.headingSmall(fontSize: 20),
          ),
          const SizedBox(height: 8),
          Text(
            step['desc']!,
            style: AppTypography.bodyMedium(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildTiersSpectrum(BuildContext context, bool isDesktop) {
    return GlassCard(
      padding: EdgeInsets.all(isDesktop ? 36 : 24),
      child: Column(
        children: [
          Text(
            'THE OFFICIAL COOKED SPECTRUM',
            style: AppTypography.mono(fontSize: 12, color: AppColors.fireAmber),
          ),
          const SizedBox(height: 10),
          Text(
            'Where will you land?',
            style: AppTypography.headingMedium(fontSize: isDesktop ? 28 : 22),
          ),
          const SizedBox(height: 28),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: CookedTier.all.map((tier) {
              final color = AppColors.getTierColor(tier.minScore);
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: color.withValues(alpha: 0.3)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${tier.minScore}–${tier.maxScore}%',
                      style: AppTypography.mono(fontSize: 11, color: AppColors.textMuted),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${tier.emoji} ${tier.title}',
                      style: AppTypography.label(fontSize: 13, color: color, weight: FontWeight.w700),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniCalculatorsPreview(BuildContext context, bool isDesktop) {
    final teasers = [
      {
        'title': '💰 Can I Afford This?',
        'desc': 'Input price vs bank balance vs days until salary. Brace for impact.',
        'slug': 'can-i-afford-this',
      },
      {
        'title': '🍔 Can I Afford Food Delivery?',
        'desc': '₹60 biryani + ₹150 delivery fees = instant financial downfall.',
        'slug': 'can-i-afford-food-delivery',
      },
      {
        'title': '😴 Sleep Cooked Score',
        'desc': 'Calculate your sleep debt and how many days until total delirium.',
        'slug': 'sleep-cooked-score',
      },
      {
        'title': '💳 Should I Buy This on EMI?',
        'desc': 'Exposing the psychological trap of "It’s only ₹1,299 a month".',
        'slug': 'should-i-buy-this-on-emi',
      },
    ];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SPECIALIZED TOOLS',
                    style: AppTypography.mono(fontSize: 12, color: AppColors.fireOrange),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '10 Viral Mini Calculators',
                    style: AppTypography.headingLarge(fontSize: isDesktop ? 32 : 24),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () => context.go('/calculators'),
              child: Row(
                children: [
                  Text('View All 10', style: TextStyle(color: AppColors.fireOrange, fontWeight: FontWeight.w700)),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_forward_rounded, size: 16, color: AppColors.fireOrange),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = isDesktop ? (constraints.maxWidth - 20) / 2 : constraints.maxWidth;
            return Wrap(
              spacing: 20,
              runSpacing: 20,
              children: teasers.map((t) {
                return SizedBox(
                  width: cardWidth,
                  child: GlassCard(
                    onTap: () => context.go('/calculators/${t['slug']}'),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(t['title']!, style: AppTypography.headingSmall(fontSize: 18)),
                        const SizedBox(height: 8),
                        Text(t['desc']!, style: AppTypography.bodySmall()),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Text(
                              'Calculate damage →',
                              style: AppTypography.label(
                                fontSize: 13,
                                color: AppColors.fireOrange,
                                weight: FontWeight.w700,
                              ),
                            ),
                          ],
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

  Widget _buildBottomBanner(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
      borderColor: AppColors.fireOrange.withValues(alpha: 0.5),
      child: Column(
        children: [
          const Text('💀', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 16),
          Text(
            'Ready to Face the Truth?',
            textAlign: TextAlign.center,
            style: AppTypography.headingLarge(fontSize: 32),
          ),
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 540),
            child: Text(
              'Takes 2 minutes. Completely anonymous. Zero financial advice. 100% emotional damage.',
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium(),
            ),
          ),
          const SizedBox(height: 28),
          ShinyButton(
            text: '🔥 START MY ASSESSMENT NOW',
            height: 56,
            fontSize: 16,
            onPressed: () => context.go('/check'),
          ),
        ],
      ),
    );
  }
}
