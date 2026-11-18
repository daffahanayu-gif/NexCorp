import 'package:flutter/material.dart';

import '../services/ceo_repository.dart';
import 'approval_center_screen.dart';
import 'ceo_dashboard_screen.dart';

/// Kerangka Portal CEO: navigasi bawah antara Ringkasan dan Approval.
class CeoHome extends StatefulWidget {
  final CeoRepository repo;
  const CeoHome({super.key, required this.repo});

  @override
  State<CeoHome> createState() => _CeoHomeState();
}

class _CeoHomeState extends State<CeoHome> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _tab,
        children: [
          CeoDashboardScreen(repo: widget.repo),
          ApprovalCenterScreen(repo: widget.repo),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.apartment_outlined), selectedIcon: Icon(Icons.apartment), label: 'Ringkasan'),
          NavigationDestination(icon: Icon(Icons.fact_check_outlined), selectedIcon: Icon(Icons.fact_check), label: 'Approval'),
        ],
      ),
    );
  }
}
