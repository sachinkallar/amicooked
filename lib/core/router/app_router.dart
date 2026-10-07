import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_typography.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/shiny_button.dart';
import '../../features/home/home_screen.dart';
import '../../features/assessment/assessment_screen.dart';
import '../../features/calculating/calculating_screen.dart';
import '../../features/result/result_screen.dart';
import '../../features/calculators/calculators_hub_screen.dart';
import '../../features/calculators/single_calculator_screen.dart';
import '../../features/leaderboard/leaderboard_screen.dart';
import '../../features/challenge/challenge_screen.dart';
import '../../features/about/about_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    errorBuilder: (context, state) => AppScaffold(
      currentRoute: state.uri.path,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('💀', style: TextStyle(fontSize: 54)),
              const SizedBox(height: 16),
              Text(
                'THE ALGORITHM HAS GIVEN UP 💀',
                textAlign: TextAlign.center,
                style: AppTypography.headingLarge(fontSize: 28),
              ),
              const SizedBox(height: 12),
              Text(
                'Even our questionable mathematics couldn’t find this page.',
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium(),
              ),
              const SizedBox(height: 28),
              ShinyButton(
                text: '🔥 RETURN TO SAFETY',
                onPressed: () => context.go('/'),
              ),
            ],
          ),
        ),
      ),
    ),
    routes: [
      // / Home
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: AppScaffold(
            currentRoute: '/',
            showFloatingCta: true,
            body: const HomeScreen(),
          ),
          transitionsBuilder: _fadeTransition,
        ),
      ),

      // /check Assessment
      GoRoute(
        path: '/check',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: AppScaffold(
            currentRoute: '/check',
            body: const AssessmentScreen(),
          ),
          transitionsBuilder: _fadeTransition,
        ),
      ),

      // /calculating Suspense animation
      GoRoute(
        path: '/calculating',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: AppScaffold(
            currentRoute: '/calculating',
            body: const CalculatingScreen(),
          ),
          transitionsBuilder: _fadeTransition,
        ),
      ),

      // /result Final Results
      GoRoute(
        path: '/result',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: AppScaffold(
            currentRoute: '/result',
            body: const ResultScreen(),
          ),
          transitionsBuilder: _fadeTransition,
        ),
      ),

      // /calculators Hub
      GoRoute(
        path: '/calculators',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: AppScaffold(
            currentRoute: '/calculators',
            body: const CalculatorsHubScreen(),
          ),
          transitionsBuilder: _fadeTransition,
        ),
        routes: [
          // /calculators/:type
          GoRoute(
            path: ':type',
            pageBuilder: (context, state) {
              final typeSlug = state.pathParameters['type'] ?? '';
              return CustomTransitionPage(
                key: state.pageKey,
                child: AppScaffold(
                  currentRoute: '/calculators/$typeSlug',
                  body: SingleCalculatorScreen(typeSlug: typeSlug),
                ),
                transitionsBuilder: _fadeTransition,
              );
            },
          ),
        ],
      ),

      // /leaderboard
      GoRoute(
        path: '/leaderboard',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: AppScaffold(
            currentRoute: '/leaderboard',
            body: const LeaderboardScreen(),
          ),
          transitionsBuilder: _fadeTransition,
        ),
      ),

      // /challenge (Supports ?score=87&tier=absolutely-cooked)
      GoRoute(
        path: '/challenge',
        pageBuilder: (context, state) {
          final scoreStr = state.uri.queryParameters['score'];
          final tierSlug = state.uri.queryParameters['tier'] ?? 'absolutely-cooked';
          final score = int.tryParse(scoreStr ?? '87') ?? 87;

          return CustomTransitionPage(
            key: state.pageKey,
            child: AppScaffold(
              currentRoute: '/challenge',
              body: ChallengeScreen(
                challengerScore: score,
                challengerTierSlug: tierSlug,
              ),
            ),
            transitionsBuilder: _fadeTransition,
          );
        },
      ),

      // /about
      GoRoute(
        path: '/about',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: AppScaffold(
            currentRoute: '/about',
            body: const AboutScreen(),
          ),
          transitionsBuilder: _fadeTransition,
        ),
      ),
    ],
  );

  static Widget _fadeTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
      child: child,
    );
  }
}
