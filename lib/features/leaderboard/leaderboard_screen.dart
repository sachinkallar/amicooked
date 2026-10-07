import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/shiny_button.dart';
import '../assessment/assessment_controller.dart';
import 'leaderboard_models.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final ILeaderboardRepository _repo = LocalLeaderboardRepository();
  String _selectedCategory = 'overall';
  List<LeaderboardEntry> _entries = [];
  bool _isLoading = true;

  final List<Map<String, String>> _categories = [
    {'id': 'overall', 'title': 'Most Cooked Today', 'emoji': '🔥'},
    {'id': 'financial', 'title': 'Financially Cooked', 'emoji': '💰'},
    {'id': 'sleep', 'title': 'Sleep-Deprived Champion', 'emoji': '😴'},
    {'id': 'career', 'title': 'Career Crisis Champion', 'emoji': '💻'},
    {'id': 'impulse', 'title': 'Biggest Impulse Buyer', 'emoji': '🛒'},
  ];

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    setState(() => _isLoading = true);
    final list = await _repo.getEntries(category: _selectedCategory);
    if (mounted) {
      setState(() {
        _entries = list;
        _isLoading = false;
      });
    }
  }

  void _openSubmitDialog() {
    final controller = context.read<AssessmentController>();
    final result = controller.latestResult;
    final nicknameController = TextEditingController();
    final confessionController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: AppColors.surfaceElevated,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: AppColors.border),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Padding(
            padding: const EdgeInsets.all(26),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('🏆', style: TextStyle(fontSize: 26)),
                    const SizedBox(width: 12),
                    Text('Join the Hall of Shame', style: AppTypography.headingSmall()),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  result != null
                      ? 'Submitting your Cooked Score of ${result.score}% to the leaderboard.'
                      : 'You haven’t taken the test yet. A baseline score of 88% will be recorded.',
                  style: AppTypography.bodySmall(),
                ),
                const SizedBox(height: 18),
                Text('Anonymous Nickname', style: AppTypography.label(fontSize: 13)),
                const SizedBox(height: 6),
                TextField(
                  controller: nicknameController,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'e.g. BrokeBoi2026 or CaffeineGhoul',
                    hintStyle: TextStyle(color: AppColors.textMuted.withValues(alpha: 0.7)),
                    filled: true,
                    fillColor: AppColors.surface,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
                  ),
                ),
                const SizedBox(height: 14),
                Text('Your Questionable Confession', style: AppTypography.label(fontSize: 13)),
                const SizedBox(height: 6),
                TextField(
                  controller: confessionController,
                  maxLines: 2,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'e.g. Ate cereal with cold tap water because milk had expired.',
                    hintStyle: TextStyle(color: AppColors.textMuted.withValues(alpha: 0.7)),
                    filled: true,
                    fillColor: AppColors.surface,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: Text('Cancel', style: TextStyle(color: AppColors.textMuted)),
                    ),
                    const SizedBox(width: 12),
                    ShinyButton(
                      text: 'Submit Confession',
                      height: 44,
                      fontSize: 13,
                      onPressed: () async {
                        final nick = nicknameController.text.trim();
                        final conf = confessionController.text.trim();
                        if (nick.isEmpty) return;

                        final entry = LeaderboardEntry(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          nickname: nick,
                          avatar: '💀',
                          cookedScore: result?.score ?? 88,
                          badge: result?.tier ?? 'PRETTY COOKED 🍗',
                          category: _selectedCategory,
                          confession: conf.isEmpty ? 'Surviving purely on vibes and bad decisions.' : conf,
                          timestamp: DateTime.now(),
                        );

                        await _repo.submitEntry(entry);
                        if (!mounted) return;
                        if (ctx.mounted) {
                          Navigator.of(ctx).pop();
                        }
                        _loadEntries();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: AppColors.surfaceElevated,
                            content: Text('🎉 Your shame has been immortalized on the leaderboard!'),
                          ),
                        );
                      },
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 800;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '🏆 THE HALL OF FLAME',
          style: AppTypography.mono(fontSize: 12, color: AppColors.fireOrange),
        ),
        const SizedBox(height: 8),
        Text(
          'The Most Cooked People on Earth',
          textAlign: TextAlign.center,
          style: AppTypography.headingLarge(fontSize: isDesktop ? 36 : 28),
        ),
        const SizedBox(height: 10),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 580),
          child: Text(
            'A live tribute to mankind’s worst financial, biological, and career disasters.',
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium(),
          ),
        ),

        const SizedBox(height: 32),

        // Category Pills
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: _categories.map((cat) {
            final isSelected = _selectedCategory == cat['id'];
            return GestureDetector(
              onTap: () {
                setState(() => _selectedCategory = cat['id']!);
                _loadEntries();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.fireOrange : AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppColors.fireOrange : AppColors.border,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(cat['emoji']!, style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 6),
                    Text(
                      cat['title']!,
                      style: AppTypography.label(
                        fontSize: 13,
                        color: isSelected ? Colors.white : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 28),

        // Submit button
        ShinyButton(
          text: '💀 Submit My Shame to Leaderboard',
          height: 46,
          fontSize: 14,
          variant: ShinyButtonVariant.outline,
          onPressed: () => _openSubmitDialog(),
        ),

        const SizedBox(height: 40),

        // Leaderboard List
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.all(40),
            child: CircularProgressIndicator(color: AppColors.fireOrange),
          )
        else
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 820),
            child: Column(
              children: _entries.asMap().entries.map((item) {
                final index = item.key;
                final entry = item.value;
                final isPodium = index < 3;
                final color = AppColors.getTierColor(entry.cookedScore);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: GlassCard(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    borderColor: isPodium ? color.withValues(alpha: 0.6) : AppColors.border,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Rank
                        Container(
                          width: 36,
                          height: 36,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isPodium ? color.withValues(alpha: 0.2) : AppColors.surfaceHighlight,
                            shape: BoxShape.circle,
                            border: Border.all(color: isPodium ? color : AppColors.border),
                          ),
                          child: Text(
                            '#${index + 1}',
                            style: AppTypography.mono(
                              fontSize: 13,
                              weight: FontWeight.w800,
                              color: isPodium ? color : AppColors.textMuted,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Avatar
                        Text(entry.avatar, style: const TextStyle(fontSize: 26)),
                        const SizedBox(width: 14),

                        // Nickname + Confession
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    entry.nickname,
                                    style: AppTypography.label(fontSize: 16, weight: FontWeight.w700),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: color.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      entry.badge,
                                      style: AppTypography.mono(fontSize: 10, color: color, weight: FontWeight.w700),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '“${entry.confession}”',
                                style: AppTypography.bodySmall(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 14),

                        // Score
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${entry.cookedScore}%',
                              style: AppTypography.scoreDisplay(
                                fontSize: 26,
                                color: color,
                              ),
                            ),
                            Text(
                              'COOKED',
                              style: AppTypography.mono(fontSize: 9, color: AppColors.textMuted),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

        const SizedBox(height: 40),
      ],
    );
  }
}
