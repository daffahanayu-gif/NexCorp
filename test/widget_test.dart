import 'package:flutter_test/flutter_test.dart';

import 'package:holding_corp_hub_manager/main.dart';

void main() {
  testWidgets('Aplikasi tampil di halaman login', (tester) async {
    await tester.pumpWidget(const HoldingCorpHubApp());
    expect(find.text('Holding Corp Hub'), findsOneWidget);
    expect(find.text('Masuk'), findsOneWidget);
  });

  testWidgets('Login Manajer (demo) masuk ke Portal Manajer', (tester) async {
    await tester.pumpWidget(const HoldingCorpHubApp());
    await tester.tap(find.text('Nusantara Tech'));
    await tester.tap(find.text('Masuk'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
    expect(find.text('Proyek Saya'), findsOneWidget);
    expect(find.text('Platform E-Procurement'), findsOneWidget);
  });
}
