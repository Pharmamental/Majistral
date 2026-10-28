import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:game/data/formulary.dart';
import 'package:game/data/lab_tools.dart';
import 'package:game/data/orders.dart';
import 'package:game/logic/job_store.dart';
import 'package:game/logic/profile_stats.dart';
import 'package:game/main.dart';
import 'package:game/models/formula.dart';
import 'package:game/models/prep_job.dart';
import 'package:game/screens/profile_screen.dart';
import 'package:game/widgets/grow_panel.dart';

import 'test_fonts.dart';
import 'test_helpers.dart';

void main() {
  group('vitrin', showcaseTests);
  setUpAll(loadAppFonts);
  final order = prescriptionOrders.first; // %5 SA: ezme 1, levigasyon 3, geometrik seyreltme 4
  late DateTime clock;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    clock = DateTime(2026, 10, 28, 12);
  });

  /// [order]'ı baştan sona hazırlayıp teslim eder.
  Future<void> prepareAndDeliver(JobStore store) async {
    final tools = {for (final t in labTools()) t.name: t};
    await take(store, order);
    for (final s in order.steps) {
      await store.startStep(jobOf(store, order)!.id, tools[s.label]!);
      clock = clock.add(Duration(minutes: s.minutes));
    }
    await store.deliver(jobOf(store, order)!.id);
  }

  test('oyundaki her reçetenin formül kitabında karşılığı var', () {
    for (final o in prescriptionOrders) {
      expect(referenceFormula(o.formula), isTrue, reason: o.formula);
    }
  });

  test('teslim kayda yazılır, uygulama kapanıp açılınca kalır', () async {
    final store = await JobStore.load(now: () => clock);
    expect(store.deliveries, isEmpty);
    await prepareAndDeliver(store);
    final reopened = await JobStore.load(now: () => clock);
    expect(reopened.deliveries, hasLength(1));
    final d = reopened.deliveries.single;
    expect(d.magistralName, order.magistralName);
    expect(d.stars, 3);
    expect(d.steps, ['Ezme', 'Levigasyon', 'Geometrik seyreltme']);
  });

  test('diplomadaki adlar değişir ve kalır; boş ad eskisini bozmaz', () async {
    final store = await JobStore.load(now: () => clock);
    await store.rename(player: 'Tuğrul', pharmacy: '  ');
    final reopened = await JobStore.load(now: () => clock);
    expect(reopened.playerName, 'Tuğrul');
    expect(reopened.pharmacyName, 'Majistral Eczanesi');
  });

  test('unvan teslim sayısıyla yükselir; ustalık yıldızla değil kaç kez yapıldığıyla', () {
    expect(ranks[rankIndex(0)].title, 'Stajyer eczacı');
    expect(ranks[rankIndex(10)].title, 'Eczacı');
    expect(ranks[rankIndex(1000)].title, 'Mesul müdür');
    final at = DateTime(2026);
    final deliveries = [
      Delivery(magistralName: 'a', stars: 3, at: at, steps: const ['Ezme', 'Levigasyon']),
      Delivery(magistralName: 'b', stars: 1, at: at, steps: const ['Ezme']),
    ];
    expect(stepCount('Ezme', deliveries), 2);
    expect(stepCount('Eritme', deliveries), 0);
    expect(tierIndex(0), -1);
    expect(tiers[tierIndex(1)].title, 'Başladın');
    expect(tiers[tierIndex(5)].title, 'Bronz');
    expect(tiers[tierIndex(400)].title, 'Altın');
    expect(preparedFormulas([Delivery(magistralName: order.magistralName, stars: 3, at: at, steps: const [])],
        prescriptionOrders), {order.formula});
  });

  testWidgets('Profil boşken ad yer tutucusu ve ilk adım; "yapılmadı" duvarı yok', (tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MajistralApp(store: await JobStore.load(now: () => clock)));
    await tester.tap(find.text('Profil').last);
    await tester.pumpAndSettle();
    expect(find.text('Adını yaz'), findsOneWidget);
    expect(find.text('Stajyer eczacı'), findsOneWidget); // unvan yalnız diplomada
    expect(find.text('İlk reçeteni bekliyor'), findsOneWidget);
    expect(find.textContaining('yapılmadı'), findsNothing);
    await tester.tap(find.text('Reçetelere git'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Gelen reçeteler'), findsOneWidget);
  });

  testWidgets('Profil: diploma, ustalık ve koleksiyon teslimden sonra dolar', (tester) async {
    tester.view.physicalSize = const Size(1080, 2340); // 360 × 780
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final store = await JobStore.load(now: () => clock);
    await prepareAndDeliver(store);
    await tester.pumpWidget(MajistralApp(store: store));

    await tester.tap(find.text('Profil').last);
    await tester.pumpAndSettle();
    expect(find.text('ECZACILIK DİPLOMASI'), findsOneWidget);
    expect(find.text('1 reçete teslim edildi'), findsOneWidget);
    expect(find.text('Eczacı unvanına 9 reçete'), findsOneWidget);
    expect(find.text('Vitrin'), findsOneWidget);
    await scrollPage(tester, up: true); // diploma ve raf kayar, sekmeler üstte kalır
    expect(find.text('Koleksiyon'), findsOneWidget);
    expect(find.text('×1'), findsNWidgets(3)); // yalnız denenen üç teknik
    expect(find.text('Bronz için 4 kez daha'), findsNWidgets(3));
    expect(find.text('Laboratuvarda henüz denemediğin ${labTools().length - 3} teknik daha var.'), findsOneWidget);

    await tester.tap(find.text('Koleksiyon'));
    await tester.pumpAndSettle();
    final playable = playableFormulas(prescriptionOrders);
    expect(find.text('1/${formulasOf(FormulaCategory.merhem).where((f) => playable.contains(f.name)).length}'),
        findsOneWidget);
    expect(find.text('Yakında'), findsWidgets); // oyunda reçetesi olmayan kategoriler
    expect(find.text('0/50'), findsNothing);
    await tester.tap(find.text('Merhem ve patlar'));
    await tester.pumpAndSettle();
    expect(find.descendant(of: find.byType(GrowPanel), matching: find.text(order.formula)), findsOneWidget);
    expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
    await tester.tap(find.text('Kapat'));
    await tester.pumpAndSettle();

    await scrollPage(tester, up: false);
    await tester.tap(find.byTooltip('Adları değiştir'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'Tuğrul');
    await tester.tap(find.text('Kaydet'));
    await tester.pumpAndSettle();
    expect(find.text('Tuğrul'), findsOneWidget);
  });

  test('defterde gün adı: bugün, dün, tarih; başka yılsa yıl da', () {
    final now = DateTime(2026, 10, 28, 9);
    expect(dayLabel(DateTime(2026, 10, 28, 1), now), 'Bugün');
    expect(dayLabel(DateTime(2026, 10, 27, 23), now), 'Dün');
    expect(dayLabel(DateTime(2026, 10, 3), now), '3 Ekim');
    expect(dayLabel(DateTime(2025, 12, 31), now), '31 Aralık 2025');
  });

  testWidgets('Defter: profilde son 3 teslim, tamamı güne göre gruplu açılır', (tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final names = [for (final o in prescriptionOrders) o.magistralName];
    // Dört teslim: ikisi dün, ikisi bugün; en yenisi listenin sonunda.
    final saved = [
      for (final (i, at) in [
        DateTime(2026, 10, 27, 10),
        DateTime(2026, 10, 27, 15),
        DateTime(2026, 10, 28, 9),
        DateTime(2026, 10, 28, 11, 5),
      ].indexed)
        Delivery(magistralName: names[i], stars: i == 1 ? 2 : 3, at: at, steps: const []).toJson(),
    ];
    SharedPreferences.setMockInitialValues({'deliveries_v1': jsonEncode(saved)});
    await tester.pumpWidget(MajistralApp(store: await JobStore.load(now: () => clock)));
    await tester.tap(find.text('Profil').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Defter'));
    await tester.pumpAndSettle();
    await scrollPage(tester, up: true);

    expect(find.text('Son teslimlerin'), findsOneWidget);
    expect(find.text(names[3]), findsOneWidget); // en yeni üstte
    expect(find.text(names[0]), findsNothing); // en eski profilde görünmez
    expect(find.text('11:05'), findsOneWidget);
    expect(find.text(prescriptionOrders[3].doctorName), findsOneWidget);

    await tester.tap(find.text('Defterin tamamı (4 reçete) ›'));
    await tester.pumpAndSettle();
    final inPanel = find.byType(GrowPanel);
    expect(find.descendant(of: inPanel, matching: find.text('Bugün')), findsOneWidget);
    expect(find.descendant(of: inPanel, matching: find.text('Dün')), findsOneWidget);
    expect(find.descendant(of: inPanel, matching: find.text(names[0])), findsOneWidget);
  });
}


/// Formül kitabında bu adda formül var mı?
bool referenceFormula(String name) => formulary.any((f) => f.name == name);

/// Profil sayfasını kaydırır: yukarı (diploma ve raf gider) ya da aşağı (geri gelir).
Future<void> scrollPage(WidgetTester tester, {required bool up}) async {
  await tester.drag(find.byType(NestedScrollView), Offset(0, up ? -600 : 600));
  await tester.pumpAndSettle();
}

void showcaseTests() {
  setUpAll(loadAppFonts);
  late DateTime clock;
  final order = prescriptionOrders.first;
  final saved = jsonEncode([
    Delivery(magistralName: order.magistralName, stars: 3, at: DateTime(2026, 10, 28, 9), steps: const []).toJson(),
  ]);

  setUp(() {
    SharedPreferences.setMockInitialValues({'deliveries_v1': saved});
    clock = DateTime(2026, 10, 28, 12);
  });

  test('vitrine yalnız teslim edilen ürün konur; aynı ürün iki yerde durmaz; kayıtta kalır', () async {
    final store = await JobStore.load(now: () => clock);
    await store.setShowcase(0, prescriptionOrders[1].magistralName); // teslim edilmedi
    expect(store.showcase, [null, null, null]);
    await store.setShowcase(0, order.magistralName);
    await store.setShowcase(2, order.magistralName); // 0'dan 2'ye taşınır
    expect(store.showcase, [null, null, order.magistralName]);
    final reopened = await JobStore.load(now: () => clock);
    expect(reopened.showcase, [null, null, order.magistralName]);
    await reopened.setShowcase(2, null);
    expect(reopened.showcase, [null, null, null]);
  });

  testWidgets('Vitrin: boş yere basınca teslim edilenler çıkar, seçilen rafa konur, kaldırılır', (tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MajistralApp(store: await JobStore.load(now: () => clock)));
    await tester.tap(find.text('Profil').last);
    await tester.pumpAndSettle();

    await tester.tap(find.bySemanticsLabel('Vitrinde boş yer, ürün koy').first);
    await tester.pumpAndSettle();
    expect(find.text('Vitrine ne koyalım?'), findsOneWidget);
    expect(find.text('1 kez teslim edildi'), findsOneWidget);
    await tester.tap(find.descendant(of: find.byType(GrowPanel), matching: find.text(order.magistralName)));
    await tester.pumpAndSettle();
    expect(find.bySemanticsLabel('Vitrinde ${order.magistralName}'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Vitrinde ${order.magistralName}'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Raftan kaldır'));
    await tester.pumpAndSettle();
    expect(find.bySemanticsLabel('Vitrinde boş yer, ürün koy'), findsNWidgets(3));
  });
}
