import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:game/data/economy.dart';
import 'package:game/logic/job_store.dart';
import 'package:game/main.dart';

import 'test_fonts.dart';

void main() {
  setUpAll(loadAppFonts);

  // Tuğrul, 2026-10-29: kimyasala dokununca hemen almaz; "Al" miktar penceresini açar.
  testWidgets('kimyasalda "Al" 1-5-10-20-100 penceresini açar, seçilen kadar paket alınır', (tester) async {
    tester.view.physicalSize = const Size(1080, 4800);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    SharedPreferences.setMockInitialValues({
      'economy_v1': jsonEncode({'coins': 1000, 'debt': 0, 'stock': {}, 'tools': []}),
    });
    final store = await JobStore.load(now: () => DateTime(2026, 10, 29, 9));
    await tester.pumpWidget(MajistralApp(store: store));
    await tester.tap(find.text('Market'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Kimyasallar'));
    await tester.pumpAndSettle();

    // Kilitli maddenin adı görünmez (Tuğrul, 2026-10-29).
    final locked = packs.keys.firstWhere((c) => !store.chemicalUnlocked(c));
    expect(find.text(locked), findsNothing);
    expect(find.text('Kilitli madde'), findsWidgets);

    final vazelin = packs['Beyaz Vazelin']!;
    expect(find.text('Paketi ${vazelin.price} para. Sahip olunan: 0 adet'), findsOneWidget);
    await tester.tap(find.text('Al').first); // ilk grubun ilk açık maddesi: Beyaz Vazelin
    await tester.pumpAndSettle();
    expect(store.packsOf('Beyaz Vazelin'), 0, reason: '"Al" hemen satın almaz');
    for (final n in [1, 5, 10, 20, 100]) {
      expect(find.text('$n'), findsWidgets);
    }

    await tester.tap(find.text('5'));
    await tester.pumpAndSettle();
    expect(find.text('${vazelin.price * 5}'), findsOneWidget);
    await tester.tap(find.text('5 paket al'));
    await tester.pumpAndSettle();
    expect(store.packsOf('Beyaz Vazelin'), 5);
    expect(store.coins, 1000 - vazelin.price * 5);
    expect(find.text('5 paket al'), findsNothing, reason: 'pencere kapanır');

    // Para yetmeyince düğme kapalı, pencere söyler.
    await tester.tap(find.text('Al').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('100'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Paran yetmiyor'), findsOneWidget);
    await tester.tap(find.text('100 paket al'));
    await tester.pumpAndSettle();
    expect(store.packsOf('Beyaz Vazelin'), 5);
  });
}
