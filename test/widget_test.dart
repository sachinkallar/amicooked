import 'package:flutter_test/flutter_test.dart';
import 'package:amicooked/main.dart';
import 'package:amicooked/core/storage/local_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalStorageService.init();
  });

  testWidgets('App loads Home screen successfully with branding and CTAs', (WidgetTester tester) async {
    await tester.pumpWidget(const AmICookedApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Verify Brand Title
    expect(find.text('AM I COOKED?'), findsWidgets);

    // Verify Primary CTAs
    expect(find.text('🔥 CHECK HOW COOKED I AM'), findsOneWidget);
    expect(find.text('🧮 TRY A MINI CALCULATOR'), findsOneWidget);

    // Verify How it works steps
    expect(find.text('ANSWER'), findsOneWidget);
    expect(find.text('GET JUDGED'), findsOneWidget);
    expect(find.text('ACCEPT YOUR FATE'), findsOneWidget);
  });
}
