// Market dar telefonda (360 dp): dört ikon ve Çiçekler listesi taşmaz (2026-10-29).
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:game/logic/job_store.dart';
import 'package:game/screens/market_screen.dart';

import 'test_fonts.dart';

void main() {
  setUpAll(loadAppFonts);
  testWidgets('360 dp: dört ikon ve çiçekler taşmaz', (tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    SharedPreferences.setMockInitialValues({});
    final store = await JobStore.load();
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: JobScope(store: store, child: const MarketScreen()))));
    await tester.tap(find.byTooltip('Çiçekler'));
    await tester.pumpAndSettle();
    expect(find.text('Papatya'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
