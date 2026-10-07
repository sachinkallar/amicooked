import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'fire_particles.dart';
import 'shiny_button.dart';
import 'ai_settings_dialog.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final String currentRoute;
  final bool showFloatingCta;

  const AppScaffold({
    super.key,
    required this.body,
    this.currentRoute = '/',
    this.showFloatingCta = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1000;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: FireParticlesBackground(
        child: Column(
          children: [
            // Sticky top navigation bar
            _buildNavbar(context, isDesktop),

            // Scrollable page content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1200),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: isDesktop ? 32 : 16,
                            vertical: isDesktop ? 32 : 16,
                          ),
                          child: body,
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),
                    _buildFooter(context, isDesktop),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: (!isDesktop && showFloatingCta && currentRoute != '/check')
          ? Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ShinyButton(
                text: '🔥 CHECK MY SCORE',
                height: 52,
                fontSize: 15,
                onPressed: () => context.go('/check'),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildNavbar(BuildContext context, bool isDesktop) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.85),
        border: const Border(bottom: BorderSide(color: AppColors.border)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Brand Logo
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => context.go('/'),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: AppColors.fireGradient,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.fireOrange.withValues(alpha: 0.4),
                                blurRadius: 12,
                              ),
                            ],
                          ),
                          child: const Text('🔥', style: TextStyle(fontSize: 18)),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'AM I COOKED?',
                          style: AppTypography.headingSmall(fontSize: 19),
                        ),
                      ],
                    ),
                  ),
                ),

                // Desktop Nav Links
                if (isDesktop) ...[
                  Flexible(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildNavLink(context, 'Home', '/', currentRoute == '/'),
                          const SizedBox(width: 6),
                          _buildNavLink(context, 'Check Me', '/check', currentRoute == '/check'),
                          const SizedBox(width: 6),
                          _buildNavLink(
                            context,
                            'Calculators',
                            '/calculators',
                            currentRoute.startsWith('/calculators'),
                          ),
                          const SizedBox(width: 6),
                          _buildNavLink(
                            context,
                            'Leaderboard',
                            '/leaderboard',
                            currentRoute == '/leaderboard',
                          ),
                          const SizedBox(width: 6),
                          _buildNavLink(context, 'About', '/about', currentRoute == '/about'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Row(
                    children: [
                      // AI Config button
                      IconButton(
                        tooltip: 'Configure AI / Offline Roast Engine',
                        icon: const Icon(Icons.psychology_outlined, color: AppColors.textSecondary),
                        onPressed: () => AISettingsDialog.show(context),
                      ),
                      const SizedBox(width: 10),
                      ShinyButton(
                        text: '🔥 CHECK MY SCORE',
                        height: 42,
                        fontSize: 13,
                        onPressed: () => context.go('/check'),
                      ),
                    ],
                  ),
                ] else ...[
                  // Mobile menu action
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.psychology_outlined, color: AppColors.textSecondary),
                        onPressed: () => AISettingsDialog.show(context),
                      ),
                      IconButton(
                        icon: const Icon(Icons.menu_rounded, color: AppColors.textPrimary, size: 28),
                        onPressed: () => _openMobileMenu(context),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavLink(BuildContext context, String title, String route, bool isActive) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.go(route),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? AppColors.surfaceHighlight : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isActive ? AppColors.fireOrange.withValues(alpha: 0.4) : Colors.transparent,
            ),
          ),
          child: Text(
            title,
            style: AppTypography.label(
              fontSize: 14,
              color: isActive ? AppColors.fireOrange : AppColors.textSecondary,
              weight: isActive ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  void _openMobileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textMuted,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 24),
                _buildMobileDrawerItem(ctx, '🔥 Home', '/'),
                _buildMobileDrawerItem(ctx, '🎯 Check My Score', '/check'),
                _buildMobileDrawerItem(ctx, '🧮 Mini Calculators (10)', '/calculators'),
                _buildMobileDrawerItem(ctx, '🏆 Leaderboard', '/leaderboard'),
                _buildMobileDrawerItem(ctx, 'ℹ️ About & Methodology', '/about'),
                const SizedBox(height: 16),
                ShinyButton(
                  text: '🔥 START ASSESSMENT',
                  width: double.infinity,
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    context.go('/check');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMobileDrawerItem(BuildContext context, String title, String route) {
    return ListTile(
      title: Text(
        title,
        style: AppTypography.headingSmall(fontSize: 17),
      ),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textMuted),
      onTap: () {
        Navigator.of(context).pop();
        context.go(route);
      },
    );
  }

  Widget _buildFooter(BuildContext context, bool isDesktop) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF070709),
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 60 : 20,
        vertical: 40,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text('🔥', style: TextStyle(fontSize: 22)),
                            const SizedBox(width: 8),
                            Text('AM I COOKED?', style: AppTypography.headingSmall(fontSize: 18)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'A scientifically questionable assessment of how badly you’re doing.',
                          style: AppTypography.bodySmall(),
                        ),
                      ],
                    ),
                  ),
                  if (isDesktop) ...[
                    Row(
                      children: [
                        _buildFooterLink(context, 'Home', '/'),
                        const SizedBox(width: 24),
                        _buildFooterLink(context, 'Check Me', '/check'),
                        const SizedBox(width: 24),
                        _buildFooterLink(context, 'Calculators', '/calculators'),
                        const SizedBox(width: 24),
                        _buildFooterLink(context, 'Leaderboard', '/leaderboard'),
                        const SizedBox(width: 24),
                        _buildFooterLink(context, 'About', '/about'),
                      ],
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 32),
              const Divider(color: AppColors.border),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '⚠️ Entertainment only. Not financial, medical, or life advice. If you are actually cooked, please consult an adult.',
                      style: AppTypography.bodySmall(fontSize: 11, color: AppColors.textMuted),
                    ),
                  ),
                  Text(
                    '© 2026 AM I COOKED LABS',
                    style: AppTypography.mono(fontSize: 11, color: AppColors.textMuted),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooterLink(BuildContext context, String title, String route) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.go(route),
        child: Text(
          title,
          style: AppTypography.bodySmall(color: AppColors.textSecondary),
        ),
      ),
    );
  }
}
