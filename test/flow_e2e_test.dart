import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:amicooked/main.dart';
import 'package:amicooked/core/storage/local_storage_service.dart';
import 'package:amicooked/features/assessment/assessment_controller.dart';
import 'package:amicooked/core/router/app_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalStorageService.init();
  });

  testWidgets('Complete End-to-End User Flow: Home → Assessment → Questions → Calculating → Results → Retake',
      (WidgetTester tester) async {
    // Set a realistic viewport
    tester.view.physicalSize = const Size(1280, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    // 1. HOME
    await tester.pumpWidget(const AmICookedApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('AM I COOKED?'), findsWidgets);
    expect(find.text('🔥 CHECK HOW COOKED I AM'), findsOneWidget);

    // 2. NAVIGATE TO ASSESSMENT (/check)
    await tester.tap(find.text('🔥 CHECK HOW COOKED I AM'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Question 1 / 15'), findsOneWidget);

    // 3. ANSWER QUESTIONS USING TREE CONTROLLER
    final assessmentContext = tester.element(find.text('Question 1 / 15'));
    final controller = assessmentContext.read<AssessmentController>();

    controller.selectOption('q1_bank_app', 'q1_3');
    controller.selectOption('q2_payday_math', 'q2_3');
    controller.selectOption('q3_food_delivery', 'q3_3');
    controller.selectOption('q4_impulse_emi', 'q4_3');
    controller.selectOption('q5_sleep_hours', 'q5_3');

    // 4. NAVIGATE TO /calculating
    AppRouter.router.go('/calculating');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.textContaining('CALCULATING'), findsWidgets);

    // Advance calculating timer to completion
    await tester.pump(const Duration(seconds: 3));

    final damageBtn = find.text('🔥 SHOW ME THE DAMAGE');
    expect(damageBtn, findsOneWidget);
    await tester.tap(damageBtn);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Verify Result page elements
    expect(find.text('YOU ARE'), findsOneWidget);
    expect(find.text('CATEGORY BREAKDOWN'), findsOneWidget);
    expect(find.text('OFFICIAL ROAST'), findsOneWidget);
    expect(find.text('YOUR EMERGENCY PLAN'), findsOneWidget);
    expect(find.text('📤 SHARE MY SCORE'), findsOneWidget);

    // 6. RETAKE TEST
    final retakeBtn = find.text('🔄 RETAKE TEST');
    expect(retakeBtn, findsOneWidget);
    await tester.tap(retakeBtn);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Verifies returned to /check
    expect(find.text('Question 1 / 15'), findsOneWidget);
  });
}
