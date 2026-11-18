import 'package:flutter/material.dart';

import 'ceo_portal/ceo_home.dart';
import 'services/ceo_repository.dart';

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
      // Nanti ganti DummyCeoRepository() dengan ApiCeoRepository() saat API siap.
      home: CeoHome(repo: DummyCeoRepository()),
    );
  }
}
