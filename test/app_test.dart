import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:game/data/lab_tools.dart';
import 'package:game/data/orders.dart';
import 'package:game/data/references.dart';
import 'package:game/data/stations.dart';
import 'package:game/logic/job_store.dart';
import 'package:game/main.dart';
import 'package:game/widgets/grow_panel.dart';
import 'package:game/widgets/mini_games.dart';

import 'test_fonts.dart';
import 'test_helpers.dart';

Future<JobStore> _store({DateTime Function()? now}) async {
  SharedPreferences.setMockInitialValues({});
  return JobStore.load(now: now);
}

Future<void> _tallScreen(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1080, 4800);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
}

/// Termometreyi ideal aralığa (70–75°) getirip orada tutar.
Future<void> _holdThermometer(WidgetTester tester) async {
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
}

/// Duvardaki gelen reçete fişini açar ve "Al"a basar.
Future<void> _take(WidgetTester tester, String magistralName) async {
  await tester.tap(find.text(magistralName).first);
  await tester.pumpAndSettle();
  await tester.tap(find.text('Al'));
  await tester.pumpAndSettle();
}

/// Laboratuvarda adım kartına basar, reçete penceresini açar.
Future<void> _pickTool(WidgetTester tester, String name) async {
  await tester.tap(find.text(name));
  await tester.pumpAndSettle();
}

/// Açık adım penceresindeki reçete satırı.
Finder _inSheet(String text) => find.descendant(of: find.byType(GrowPanel), matching: find.text(text));

/// Alet penceresini boşluğa dokunarak kapatır.
Future<void> _closeSheet(WidgetTester tester) async {
  await tester.tapAt(const Offset(10, 10));
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(loadAppFonts);
  // Adım akışı oyunsuz sınanır; mini oyunlar test/mini_games_test.dart'ta.
  setUp(() => miniGamesEnabled = false);

  testWidgets('alt çubukla bölümler arasında geçilir', (tester) async {
    await tester.pumpWidget(MajistralApp(store: await _store()));
    expect(find.text('0 elinde'), findsOneWidget);

    await tester.tap(find.text('Laboratuvar'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Hiçbir adım çalışmıyor'), findsOneWidget);
    for (final t in labTools()) {
      expect(find.text(t.name), findsOneWidget);
    }

    await tester.tap(find.text('Market'));
    await tester.pumpAndSettle();
    expect(find.text(stations.first.name), findsOneWidget);
  });

  testWidgets('gelen reçeteler duvarda; alınan tezgâha iner, tezgâhta sağa sola kaydırılır', (tester) async {
    await _tallScreen(tester);
    await tester.pumpWidget(MajistralApp(store: await _store()));
    expect(find.text('Gelen reçeteler · 3/3 · duvar dolu'), findsOneWidget);
    expect(find.text('Tezgâhın boş. Duvardan bir reçete al.'), findsOneWidget);

    // Fişe dokununca reçete açılır; "Kapat" almadan kapatır.
    await tester.tap(find.text(prescriptionOrders.first.magistralName));
    await tester.pumpAndSettle();
    expect(find.text(prescriptionOrders.first.usedFor), findsOneWidget);
    expect(find.text('Raf ömrü'), findsOneWidget);
    await tester.tap(find.text('Kapat'));
    await tester.pumpAndSettle();
    expect(find.text('Gelen reçeteler · 3/3 · duvar dolu'), findsOneWidget);

    for (final o in prescriptionOrders.take(JobStore.wallSize)) {
      await _take(tester, o.magistralName);
    }
    expect(find.textContaining('Gelen reçeteler · 0/3 · yenisi'), findsOneWidget);
    expect(find.byIcon(Icons.hourglass_empty_rounded), findsNWidgets(3)); // duvarın boş yerleri
    expect(find.text('3 elinde · 3 seni bekliyor'), findsOneWidget);
    // Son alınan kart öne gelir; geri kaydırınca ilki görünür.
    expect(find.text('Dr. Deniz · Dermatoloji · Hasta E. Şahin', findRichText: true), findsOneWidget);
    for (var i = 0; i < 2; i++) {
      await tester.drag(find.byType(PageView), const Offset(500, 0));
      await tester.pumpAndSettle();
    }
    expect(find.text('Dr. Selin · Dermatoloji · Hasta M. Yılmaz', findRichText: true), findsOneWidget);
  });

  testWidgets('hazırla reçeteyi kabul eder, her adım laboratuvarda kendi kartından başlatılır', (tester) async {
    await _tallScreen(tester);
    final order = prescriptionOrders.first;
    var clock = DateTime(2026, 10, 25, 12);
    final store = await _store(now: () => clock);
    await tester.pumpWidget(MajistralApp(store: store));

    // Alet seçme ekranı yok: duvardan alınan reçete tezgâhta ilk adımı bekler.
    await _take(tester, order.magistralName);
    // Bekleyen kartta çip ve cümle yok; bekleyen adımın kutusu "Sıra sende" der.
    expect(find.text('Seni bekliyor'), findsNothing);
    expect(find.textContaining('Laboratuvarda aletine bas'), findsNothing);
    expect(find.text('Sıra sende'), findsOneWidget);
    expect(find.text('Tartım'), findsNothing); // tartım oyundan çıktı (2026-10-27)

    await tester.tap(find.text('Laboratuvara git'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('1 reçete seni bekliyor'), findsOneWidget);

    // Eritme kartına basınca reçete sönük, nedeni yazılı.
    await _pickTool(tester, 'Eritme');
    expect(find.text('Bu reçetede bu adım yok.'), findsOneWidget);
    await tester.tap(_inSheet(order.magistralName));
    await tester.pump();
    expect(jobOf(store, order)!.runs, isEmpty);
    await _closeSheet(tester);

    // Ezme kartında reçete vurgulu; basınca ezme başlar.
    await _pickTool(tester, 'Ezme');
    expect(find.text('Sıradaki adım: Ezme · 1 dk'), findsOneWidget);
    await tester.tap(_inSheet(order.magistralName));
    await tester.pumpAndSettle();
    expect(find.text('1 adım çalışıyor'), findsOneWidget);
    clock = clock.add(const Duration(minutes: 1));
    await tester.pump(const Duration(seconds: 1));

    // Levigasyon kendi kartında.
    await _pickTool(tester, 'Levigasyon');
    expect(find.text('Sıradaki adım: Levigasyon · 3 dk'), findsOneWidget);
    await tester.tap(_inSheet(order.magistralName));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Reçeteler'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Hazırlanıyor'), findsOneWidget);
    expect(find.text('03:00'), findsOneWidget);
    expect(find.text('sonra sıra sende'), findsOneWidget);

    // Reçete düğmeyle açılır: miktarlar, görevler, kullanım alanı.
    await tester.tap(find.text('Reçete').first);
    await tester.pumpAndSettle();
    expect(find.text(order.usedFor), findsOneWidget);
    expect(find.text(order.ingredients.first.written), findsOneWidget);
    await tester.tap(find.text('Kapat'));
    await tester.pumpAndSettle();
    expect(find.text('1 elinde · 1 hazırlanıyor'), findsOneWidget);

    // Levigasyon bitti: geometrik seyreltme kartında çelik spatül uyarısı görünür.
    clock = clock.add(const Duration(minutes: 3));
    await tester.tap(find.text('Laboratuvar'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await _pickTool(tester, 'Geometrik seyreltme');
    expect(find.text('Sıradaki adım: Geometrik seyreltme · 4 dk'), findsOneWidget);
    expect(find.textContaining('çelikle tepkimeye girer'), findsOneWidget);
    await tester.tap(_inSheet(order.magistralName));
    await tester.pumpAndSettle();
    clock = clock.add(const Duration(minutes: 4));

    await tester.tap(find.text('Reçeteler'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.tap(find.text('Hazır · Teslim Et'));
    await tester.pumpAndSettle();
    expect(find.text('Kusursuz hazırlandı!'), findsOneWidget);
    expect(find.byIcon(Icons.star_rounded), findsNWidgets(3));

    await tester.tap(find.text('Tamam'));
    await tester.pumpAndSettle();
    expect(jobOf(store, order), isNull);
    // Teslim edilen duvara dönmez; yenisi sayaçla gelir (8. dakikadayız).
    expect(find.text('Gelen reçeteler · 2/3 · yenisi 02:00 sonra'), findsOneWidget);
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

  testWidgets('kremde önce termometre, sonra eritmenin süresi', (tester) async {
    await _tallScreen(tester);
    final cream = prescriptionOrders[2]; // eritme 6 (oyun), çözme 4, emülsifikasyon 9, soğutma 8
    final clock = DateTime(2026, 10, 25, 12);
    final store = await _store(now: () => clock);
    await take(store, cream);
    await tester.pumpWidget(MajistralApp(store: store));
    expect(find.text('1 elinde · 1 seni bekliyor'), findsOneWidget);

    await tester.tap(find.text('Laboratuvar'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await _pickTool(tester, 'Eritme');
    await tester.tap(_inSheet(cream.magistralName));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Yağ fazını erit'), findsOneWidget);
    expect(find.text('Soğuk, basılı tutarak ısıt'), findsOneWidget);
    // Oyun bitmeden süre başlamaz.
    expect(jobOf(store, cream)!.runs, isEmpty);

    await _holdThermometer(tester);
    expect(find.text('Isı ideal aralıkta sabit tutuldu!'), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Yağ fazını erit'), findsNothing);

    final run = jobOf(store, cream)!.runs.single;
    expect(run.label, 'Eritme');
    expect(run.end, clock.add(const Duration(minutes: 6)));
    expect(find.text('1 adım çalışıyor'), findsOneWidget);
  });

  testWidgets('acele et reklamdan sonra adımın süresini yarılar, teslimde 2 yıldız', (tester) async {
    await _tallScreen(tester);
    final order = prescriptionOrders[1]; // çinko oksit: levigasyon 5, geometrik seyreltme 7
    var clock = DateTime(2026, 10, 25, 12);
    final store = await _store(now: () => clock);
    final tools = {for (final t in labTools()) t.name: t};
    await take(store, order);
    await store.startStep(jobOf(store, order)!.id, tools['Levigasyon']!);
    await tester.pumpWidget(MajistralApp(store: store));
    expect(find.text('05:00'), findsOneWidget);

    await tester.tap(find.text('Acele et · 5 hak'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Levigasyon: 05:00 › 02:30'), findsOneWidget);
    await tester.tap(find.text('Reklam izle'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('02:30'), findsOneWidget);
    expect(find.text('Acele et · 4 hak'), findsOneWidget);

    clock = clock.add(const Duration(minutes: 3));
    await store.startStep(jobOf(store, order)!.id, tools['Geometrik seyreltme']!);
    clock = clock.add(const Duration(minutes: 7));
    await tester.pump(const Duration(seconds: 1));
    await tester.tap(find.text('Hazır · Teslim Et'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byIcon(Icons.star_rounded), findsNWidgets(2));
    expect(find.text('Acele edildi: her acele kaliteyi yarıya indirir.'), findsOneWidget);
  });

  testWidgets('Alt çubuk sırası; Diğer › Kaynaklar listesi (telefon genişliği)', (tester) async {
    tester.view.physicalSize = const Size(1080, 2340); // 360 × 780
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MajistralApp(store: await _store()));

    final labels = ['Reçeteler', 'Laboratuvar', 'Market', 'Profil', 'Diğer'];
    final xs = [for (final l in labels) tester.getCenter(find.text(l).last).dx];
    expect(xs, [...xs]..sort());
    expect(find.text('Formüller'), findsNothing);

    await tester.tap(find.text('Profil').last);
    await tester.pumpAndSettle();
    expect(find.text('ECZACILIK DİPLOMASI'), findsOneWidget);

    await tester.tap(find.text('Diğer').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Kaynaklar'));
    await tester.pumpAndSettle();
    expect(find.text(ReferenceKind.farmakope.title), findsOneWidget);
    await tester.tap(find.text('Diğer').first);
    await tester.pumpAndSettle();
    expect(find.text('Kaynaklar ve daha fazlası'), findsOneWidget);
  });
}
