import 'package:flutter/material.dart';

import 'pages/splash_page.dart';
import 'theme/reggae_colors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ReggaeTriviaApp());
}

class ReggaeTriviaApp extends StatelessWidget {
  const ReggaeTriviaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Reggae Trivia",
      debugShowCheckedModeBanner: false,
      theme: ReggaeColors.theme,
      home: const SplashPage(),
      themeAnimationCurve: Curves.easeInOut,
      themeAnimationDuration: const Duration(milliseconds: 250),
      builder: (context, child) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: child!,
        );
      },
    );
  }
}
