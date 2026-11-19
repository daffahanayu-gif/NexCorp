import 'package:flutter/material.dart';

import 'app_dependencies.dart';
import 'auth/login_screen.dart';

void main() => runApp(const HoldingCorpHubApp());

class HoldingCorpHubApp extends StatelessWidget {
  const HoldingCorpHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Holding Corp Hub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1F5A6B)),
        scaffoldBackgroundColor: const Color(0xFFF5F7F8),
      ),
      // Dummy secara default; API: flutter run --dart-define=USE_API=true
      home: LoginScreen(deps: AppDependencies.fromEnvironment()),
    );
  }
}
