import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/router/app_router.dart';
import 'core/storage/local_storage_service.dart';
import 'core/theme/app_typography.dart';
import 'features/assessment/assessment_controller.dart';
import 'services/llm/llm_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize persistent storage
  await LocalStorageService.init();

  // Initialize Hugging Face AI engine if previously configured
  final hfEnabled = LocalStorageService.getHfEnabled();
  final hfToken = LocalStorageService.getHfToken();
  if (hfEnabled && hfToken != null) {
    LLMService().configureHuggingFace(
      enabled: true,
      apiKey: hfToken,
    );
  }

  runApp(const AmICookedApp());
}

class AmICookedApp extends StatelessWidget {
  const AmICookedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AssessmentController()),
      ],
      child: MaterialApp.router(
        title: 'AM I COOKED? — Find Out How Cooked You Are 🔥',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
