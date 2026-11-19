import 'package:flutter/material.dart';

import '../app_dependencies.dart';
import '../auth/login_screen.dart';
import '../auth/sesi_pengguna.dart';
import 'manager_dashboard_screen.dart';
import 'pengajuan_saya_screen.dart';

/// Kerangka Portal Manajer: navigasi bawah Proyek / Pengajuan.
/// Tab dibangun ulang tiap dipilih agar data selalu terbaru (mis. status
/// keputusan CEO pada tab Pengajuan).
class ManagerHome extends StatefulWidget {
  final SesiPengguna sesi;
  final AppDependencies deps;
  const ManagerHome({super.key, required this.sesi, required this.deps});

  @override
  State<ManagerHome> createState() => _ManagerHomeState();
}

class _ManagerHomeState extends State<ManagerHome> {
  int _tab = 0;

  void _keluar() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen(deps: widget.deps)),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final repo = widget.deps.manager;
    return Scaffold(
      body: _tab == 0
          ? ManagerDashboardScreen(sesi: widget.sesi, repo: repo, onKeluar: _keluar)
          : PengajuanSayaScreen(sesi: widget.sesi, repo: repo, onKeluar: _keluar),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.work_outline), selectedIcon: Icon(Icons.work), label: 'Proyek'),
          NavigationDestination(icon: Icon(Icons.request_quote_outlined), selectedIcon: Icon(Icons.request_quote), label: 'Pengajuan'),
        ],
      ),
    );
  }
}
