import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:game/logic/job_store.dart';
import 'package:game/main.dart';

import 'test_fonts.dart';

void main() {
  setUpAll(loadAppFonts);

  // Tuğrul, 2026-10-30: istasyon kartı yeşil artış; süre değil "%30 daha hızlı",
  // "para gerek" yazısı ve sağ üstte yüzde çipi yok.
  testWidgets('istasyon kartı yeşil artış: alınca kart "Elinde" olur', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    SharedPreferences.setMockInitialValues({
      'economy_v1': jsonEncode({'coins': 1000, 'debt': 0, 'stock': {}, 'tools': []}),
    });
    final store = await JobStore.load(now: () => DateTime(2026, 10, 29, 9));
    await tester.pumpWidget(MajistralApp(store: store));
    await tester.tap(find.text('Market'));
    await tester.pumpAndSettle();

    expect(find.text('Ezme için Wedgwood havan'), findsOneWidget);
    expect(find.text('Hazırlama hızı'), findsWidgets);
    expect(find.text('%30 daha hızlı'), findsWidgets);
    expect(find.textContaining('sürer'), findsNothing);
    expect(find.textContaining('para daha gerek'), findsNothing);

    await tester.tap(find.text('900 ile al'));
    await tester.pumpAndSettle();
    expect(store.coins, 100);
    expect(find.text('Elinde'), findsWidgets);
    expect(find.text('900 ile al'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
