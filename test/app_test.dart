import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:game/data/orders.dart';
import 'package:game/data/stations.dart';
import 'package:game/logic/job_store.dart';
import 'package:game/main.dart';
import 'package:game/models/prescription.dart';
import 'package:game/widgets/prescription_card.dart';

import 'test_fonts.dart';

Future<JobStore> _store({DateTime Function()? now}) async {
  SharedPreferences.setMockInitialValues({});
  return JobStore.load(now: now);
}

Future<void> _tallScreen(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1080, 4800);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
}

void main() {
  setUpAll(loadAppFonts);

  testWidgets('alt çubukla üç bölüm arasında geçilir', (tester) async {
    await tester.pumpWidget(MajistralApp(store: await _store()));
    expect(find.text('3 reçete'), findsOneWidget);

    await tester.tap(find.text('Laboratuvar'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Bütün istasyonlar boş'), findsOneWidget);
    for (final s in LabStation.values) {
      expect(find.text(s.label), findsOneWidget);
    }

    await tester.tap(find.text('Market'));
    await tester.pumpAndSettle();
    expect(find.text(stations.first.name), findsOneWidget);
  });

  testWidgets('reçete ekranı her reçete için bir kart gösterir', (tester) async {
    await _tallScreen(tester);
    await tester.pumpWidget(MajistralApp(store: await _store()));
    expect(find.byType(PrescriptionCard), findsNWidgets(prescriptionOrders.length));
    expect(find.text('Dr. Selin Arı'), findsOneWidget);
  });

  testWidgets('hazırlık gerçek zamanda sürer, hazır olunca teslim edilir', (tester) async {
    await _tallScreen(tester);
    final order = prescriptionOrders.first;
    var clock = DateTime(2026, 10, 25, 12);
    final store = await _store(now: () => clock);
    await tester.pumpWidget(MajistralApp(store: store));

    await tester.tap(find.text('Hazırla').first);
    await tester.pumpAndSettle();
    expect(find.text('Hazırlama'), findsOneWidget);
    expect(find.text('Önce raftan kimyasal seç'), findsOneWidget);

    for (final chemical in order.chemicals) {
      await tester.tap(find.descendant(of: find.byType(Wrap), matching: find.text(chemical)).first);
      await tester.pump();
    }
    expect(find.text('Aletlerini seç'), findsOneWidget);
    // Salisilik asit: çelik değil plastik spatül; toz için porselen havan.
    for (final tool in ['Plastik spatül', 'Porselen havan', 'Merhem taşı']) {
      await tester.tap(find.text(tool));
      await tester.pump();
    }
    for (final step in order.steps) {
      await tester.tap(find.text(step.label));
      await tester.pump();
    }
    expect(find.text('Hazırsın'), findsOneWidget);
    await tester.tap(find.text('Başlat'));
    await tester.pump();
    expect(find.text('Hazırlanıyor'), findsOneWidget);
    expect(find.text('10:00'), findsOneWidget);
    expect(find.text('Terazi: Tartım'), findsOneWidget);

    // Laboratuvarda terazi bu işle çalışıyor görünür.
    await tester.tap(find.text('Reçetelere Dön'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Laboratuvar'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('1 istasyon çalışıyor'), findsOneWidget);
    expect(find.text(order.magistralName), findsOneWidget);
    await tester.tap(find.text('Reçeteler'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Hazırlanıyor'), findsOneWidget);
    expect(find.text('3 reçete · 1 hazırlanıyor'), findsOneWidget);

    clock = clock.add(order.prepTime);
    await tester.pump(const Duration(seconds: 1));
    await tester.tap(find.text('Hazır · Teslim Et'));
    await tester.pumpAndSettle();
    expect(find.text('Kusursuz hazırlandı!'), findsOneWidget);
    expect(find.byIcon(Icons.star_rounded), findsNWidgets(3));

    await tester.tap(find.text('Tamam'));
    await tester.pumpAndSettle();
    expect(store.jobFor(order.magistralName), isNull);
    expect(find.text('Hazırla'), findsNWidgets(prescriptionOrders.length));
  });

  testWidgets('market sekmeleri istasyonları, reklamı ve kimyasalları gösterir', (tester) async {
    await tester.pumpWidget(MajistralApp(store: await _store()));
    await tester.tap(find.text('Market'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Hızlandırma'));
    await tester.pumpAndSettle();
    expect(find.text('Reklam İzle'), findsOneWidget);

    await tester.tap(find.text('Kimyasallar'));
    await tester.pumpAndSettle();
    expect(find.text('Beyaz Vazelin'), findsOneWidget);
  });

  testWidgets('termometre ideal aralıkta tutulunca başarı gösterir', (tester) async {
    await _tallScreen(tester);
    await tester.pumpWidget(MajistralApp(store: await _store()));
    await tester.tap(find.text('Laboratuvar'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    // Isıtma denemesi su banyosu istasyonundan açılır.
    await tester.tap(find.text(LabStation.isitma.label));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Soğuk, basılı tutarak ısıt'), findsOneWidget);

    final gesture = await tester.startGesture(tester.getCenter(find.byKey(const Key('flame-button'))));
    // 22°/sn ısınma: 0'dan ~72°'ye yaklaşık 3,3 sn.
    for (var i = 0; i < 33; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    await gesture.up();
    // Bırakınca 14°/sn soğur: 100 ms soğuma (-1,4°) + 64 ms ısıtma (+1,4°)
    // sıcaklığı aralıkta sabit tutar.
    for (var i = 0; i < 40; i++) {
      await tester.pump(const Duration(milliseconds: 100));
      if (find.text('Tekrar Dene').evaluate().isNotEmpty) break;
      final g = await tester.startGesture(tester.getCenter(find.byKey(const Key('flame-button'))));
      await tester.pump(const Duration(milliseconds: 64));
      await g.up();
    }
    expect(find.text('Isı ideal aralıkta sabit tutuldu!'), findsOneWidget);
  });
}
