import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:game/data/lab_tools.dart';
import 'package:game/data/stations.dart';
import 'package:game/logic/job_store.dart';
import 'package:game/main.dart';

import 'test_fonts.dart';

void main() {
  setUpAll(loadAppFonts);

  // Tuğrul, 2026-10-30: istasyon kartı yıldızlı aşama; süre değil "%30 daha hızlı",
  // "para gerek" yazısı ve sağ üstte yüzde çipi yok.
  testWidgets('istasyon kartı yıldızlı aşama: alınca sıradaki gelir, son alet "Elinde" olur', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    SharedPreferences.setMockInitialValues({
      'economy_v1': jsonEncode({'coins': 2300, 'debt': 0, 'stock': {}, 'tools': []}),
    });
    final store = await JobStore.load(now: () => DateTime(2026, 10, 29, 9));
    await tester.pumpWidget(MajistralApp(store: store));
    await tester.tap(find.text('Market'));
    await tester.pumpAndSettle();

    expect(find.text('Ezme'), findsOneWidget);
    expect(find.text('Wedgwood havan'), findsOneWidget);
    expect(find.bySemanticsLabel('3 aşamanın 1 tanesi tamam'), findsWidgets);
    expect(find.textContaining('yıldızı bu alet'), findsNothing);
    expect(find.text('%30 daha hızlı'), findsWidgets);
    expect(find.textContaining('sürer'), findsNothing);
    expect(find.textContaining('para daha gerek'), findsNothing);

    await tester.tap(find.text('900 ile al'));
    await tester.pumpAndSettle();
    expect(store.coins, 1400);
    expect(find.text('900 ile al'), findsNothing);
    expect(find.text('Motorlu havan'), findsOneWidget, reason: 'sıradaki kademe gelir');
    expect(find.bySemanticsLabel('3 aşamanın 2 tanesi tamam'), findsWidgets);
    expect(find.text('1400 ile al'), findsOneWidget);
    await tester.tap(find.text('1400 ile al'));
    await tester.pumpAndSettle();
    expect(find.text('Elinde'), findsWidgets, reason: 'son kademe alınınca kart biter');
    expect(tester.takeException(), isNull);
  });

  testWidgets('ortak makine bir kez alınır, üç adımı hızlandırır, alttaki alet sorulmaz', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    SharedPreferences.setMockInitialValues({
      'economy_v1': jsonEncode({'coins': 6000, 'debt': 0, 'stock': {}, 'tools': ['Yüksek devirli karıştırıcı']}),
    });
    final store = await JobStore.load(now: () => DateTime(2026, 10, 30, 9));
    final makine = stationFor('Şişirme')!.tiers.last;
    expect(await store.buyTool(makine), isTrue);
    expect(store.coins, 500);
    for (final adim in ['Geometrik seyreltme', 'Karıştırma', 'Şişirme']) {
      expect(upgradeFor(adim, owns: store.ownsTool)?.name, makine.name, reason: adim);
    }
    await tester.pumpWidget(MajistralApp(store: store));
    await tester.tap(find.text('Market'));
    await tester.pumpAndSettle();
    expect(find.text('Santrifüj karıştırıcı'), findsWidgets);
    expect(find.text('Bu makine 3 adımı birden hızlandırır.'), findsWidgets);
    expect(find.textContaining('Unguator'), findsNothing, reason: 'Unguator artık sorulmaz');
    expect(tester.takeException(), isNull);
  });
}
