import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/glass_card.dart';
import 'data/mini_calculators_data.dart';

class CalculatorsHubScreen extends StatefulWidget {
  const CalculatorsHubScreen({super.key});

  @override
  State<CalculatorsHubScreen> createState() => _CalculatorsHubScreenState();
}

class _CalculatorsHubScreenState extends State<CalculatorsHubScreen> {
  String _selectedCategory = 'All';
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 850;

    final filtered = MiniCalculatorsData.all.where((c) {
      final matchesCat = _selectedCategory == 'All' || c.category == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          c.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          c.subtitle.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCat && matchesSearch;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Title & Header
        Text(
          '🧮 MINI CALCULATORS',
          style: AppTypography.mono(fontSize: 12, color: AppColors.fireOrange),
        ),
        const SizedBox(height: 8),
        Text(
          'Specific Tools for Specific Disasters',
          textAlign: TextAlign.center,
          style: AppTypography.headingLarge(fontSize: isDesktop ? 36 : 28),
        ),
        const SizedBox(height: 12),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Text(
            'From 2 AM Swiggy regret to calculating your likelihood of dying an EMI debtor. Pick your poison.',
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium(),
          ),
        ),

        const SizedBox(height: 32),

        // Search Bar
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: TextField(
            onChanged: (val) => setState(() => _searchQuery = val.trim()),
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Search calculators (e.g. EMI, ghosting, sleep)...',
              hintStyle: TextStyle(color: AppColors.textMuted.withValues(alpha: 0.7), fontSize: 13),
              prefixIcon: const Icon(Icons.search_rounded, color: AppColors.fireOrange, size: 20),
              filled: true,
              fillColor: AppColors.surfaceElevated,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: const BorderSide(color: AppColors.border)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: const BorderSide(color: AppColors.border)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: const BorderSide(color: AppColors.fireOrange)),
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Category Filter Pills
        Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: ['All', 'Finance', 'Career', 'Lifestyle'].map((cat) {
            final isSelected = _selectedCategory == cat;
            return GestureDetector(
              onTap: () => setState(() => _selectedCategory = cat),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.fireOrange : AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppColors.fireOrange : AppColors.border,
                  ),
                ),
                child: Text(
                  cat,
                  style: AppTypography.label(
                    fontSize: 13,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 36),

        // Grid of calculators
        LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = isDesktop ? (constraints.maxWidth - 20) / 2 : constraints.maxWidth;
            return Wrap(
              spacing: 20,
              runSpacing: 20,
              children: filtered.map((calc) {
                return SizedBox(
                  width: cardWidth,
                  child: GlassCard(
                    padding: const EdgeInsets.all(24),
                    onTap: () => context.go('/calculators/${calc.slug}'),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(calc.emoji, style: const TextStyle(fontSize: 32)),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceHighlight,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Text(
                                calc.category,
                                style: AppTypography.mono(fontSize: 11, color: AppColors.fireAmber),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(calc.title, style: AppTypography.headingSmall(fontSize: 18)),
                        const SizedBox(height: 8),
                        Text(calc.subtitle, style: AppTypography.bodySmall()),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            Text(
                              'Launch Calculator →',
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

        const SizedBox(height: 48),

        // Disclaimer
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Text(
            '⚠️ Disclaimer: These calculators are created for internet entertainment and emotional reality checks. Nothing here constitutes formal financial, medical, or psychological counsel.',
            style: AppTypography.bodySmall(fontSize: 12, color: AppColors.textMuted),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
