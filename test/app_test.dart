import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:game/data/orders.dart';
import 'package:game/data/stations.dart';
import 'package:game/logic/job_store.dart';
import 'package:game/main.dart';
import 'package:game/widgets/prescription_card.dart';

Future<void> _openAndReturn(WidgetTester tester, String label, String title) async {
  await tester.tap(find.text(label));
  await tester.pumpAndSettle();
  expect(find.text(title), findsOneWidget);
  await tester.tap(find.text('Geri'));
  await tester.pumpAndSettle();
  expect(find.text(label), findsOneWidget);
}

Future<JobStore> _store({DateTime Function()? now}) async {
  SharedPreferences.setMockInitialValues({});
  return JobStore.load(now: now);
}

void main() {
  testWidgets('ana ekrandan her bölüme gidip geri dönülür', (tester) async {
    await tester.pumpWidget(MajistralApp(store: await _store()));
    await _openAndReturn(tester, 'Reçeteler', 'Reçeteler');
    await _openAndReturn(tester, 'Market', 'Market');

    // Laboratuvarın termometresi sürekli çalıştığı için pumpAndSettle bitmez.
    await tester.tap(find.text('Laboratuvar'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Fazları Isıt'), findsOneWidget);
    await tester.tap(find.text('Geri'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Laboratuvar'), findsOneWidget);
  });

  testWidgets('reçete ekranı her reçete için bir kart gösterir', (tester) async {
    tester.view.physicalSize = const Size(1080, 4000);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MajistralApp(store: await _store()));
    await tester.tap(find.text('Reçeteler'));
    await tester.pumpAndSettle();
    expect(find.byType(PrescriptionCard), findsNWidgets(prescriptionOrders.length));
    expect(find.text('Dr. Selin Arı'), findsOneWidget);
  });

  testWidgets('hazırlık gerçek zamanda sürer, hazır olunca teslim edilir', (tester) async {
    tester.view.physicalSize = const Size(1080, 4000);
    addTearDown(tester.view.reset);
    final order = prescriptionOrders.first;
    var clock = DateTime(2026, 10, 25, 12);
    final store = await _store(now: () => clock);
    await tester.pumpWidget(MajistralApp(store: store));
    await tester.tap(find.text('Reçeteler'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hazırla').first);
    await tester.pumpAndSettle();
    expect(find.text('Hazırlama'), findsOneWidget);

    for (final chemical in order.chemicals) {
      await tester.tap(find.widgetWithText(FilterChip, chemical));
      await tester.pump();
    }
    for (final step in order.steps) {
      await tester.tap(find.text(step.label));
      await tester.pump();
    }
    await tester.tap(find.text('Başlat'));
    await tester.pump();
    expect(find.text('Hazırlanıyor'), findsOneWidget);
    expect(find.text('10:00'), findsOneWidget);

    // Reçetelere dönünce kartta "Hazırla" yerine süren iş görünür.
    await tester.tap(find.text('Reçetelere Dön'));
    await tester.pumpAndSettle();
    expect(find.text('Hazırlanıyor'), findsOneWidget);

    // Süre dolunca kart "Teslim Et" olur; teslimde yıldızlar gösterilir.
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

  testWidgets('market sekmeleri istasyonları ve kimyasalları gösterir', (tester) async {
    await tester.pumpWidget(MajistralApp(store: await _store()));
    await tester.tap(find.text('Market'));
    await tester.pumpAndSettle();
    expect(find.text('Reklam İzle'), findsOneWidget);

    await tester.tap(find.text('İstasyonlar'));
    await tester.pumpAndSettle();
    expect(find.text(stations.first.name), findsOneWidget);

    await tester.tap(find.text('Kimyasallar'));
    await tester.pumpAndSettle();
    expect(find.text('Beyaz Vazelin'), findsOneWidget);
  });

  testWidgets('termometre ideal aralıkta tutulunca başarı gösterir', (tester) async {
    await tester.pumpWidget(MajistralApp(store: await _store()));
    await tester.tap(find.text('Laboratuvar'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
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
