import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:game/data/dried_plants.dart';
import 'package:game/data/formulary.dart';
import 'package:game/data/lab_tools.dart';
import 'package:game/data/orders.dart';
import 'package:game/logic/job_store.dart';
import 'package:game/logic/profile_stats.dart';
import 'package:game/main.dart';
import 'package:game/models/formula.dart';
import 'package:game/models/garden.dart';
import 'package:game/models/prep_job.dart';
import 'package:game/screens/profile_screen.dart';
import 'package:game/widgets/achievement_toast.dart';
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

  testWidgets('Başarım: 5. ezmede Bronz kutucuğu iner, kendiliğinden kalkar', (tester) async {
    await loadAppFonts();
    final at = DateTime(2026);
    Delivery d(List<String> steps) => Delivery(magistralName: 'a', stars: 3, at: at, steps: steps);
    final four = [for (var i = 0; i < 4; i++) d(const ['Ezme', 'Levigasyon'])];
    expect(tierUps(four), isEmpty);
    expect(tierUps([d(const ['Ezme'])]), isEmpty, reason: 'Başladın kutucuk çıkarmaz');
    final ups = tierUps([...four, d(const ['Ezme', 'Ezme'])]);
    expect(ups, [(step: 'Ezme', tier: 1, count: 5)]);

    await tester.pumpWidget(MaterialApp(
      home: Builder(builder: (context) {
        return TextButton(onPressed: () => showAchievements(context, ups), child: const Text('aç'));
      }),
    ));
    await tester.tap(find.text('aç'));
    await tester.pump(const Duration(milliseconds: 1500));
    expect(find.text('Ezme için Bronz madalya'), findsOneWidget);
    expect(find.text('5 kez hazırladın'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pump(const Duration(seconds: 4));
    expect(find.text('Ezme için Bronz madalya'), findsNothing);
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
    expect(find.textContaining('Duvarda 4 reçete'), findsOneWidget);
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
    expect(find.text('1 reçete teslim ettin'), findsOneWidget);
    expect(find.text('Eczacı olmana 9 reçete kaldı'), findsOneWidget);
    expect(find.text('Vitrin'), findsOneWidget);
    await scrollPage(tester, up: true); // diploma ve raf kayar, sekmeler üstte kalır
    expect(find.text('Koleksiyon'), findsOneWidget);
    expect(find.text('1 kez'), findsNWidgets(3)); // yalnız denenen üç teknik
    expect(find.text('Bronz için 4 kez daha yap'), findsNWidgets(3));
    expect(find.text('Laboratuvarda henüz denemediğin ${labTools().length - 3} teknik daha var.'), findsOneWidget);

    await tester.tap(find.text('Koleksiyon'));
    await tester.pumpAndSettle();
    final playable = playableFormulas(prescriptionOrders);
    final merhemPlayable = formulasOf(FormulaCategory.merhem).where((f) => playable.contains(f.name)).length;
    // Her şey açıkken koleksiyon tam görünür.
    expect(find.text('${unlockAll ? merhemPlayable : 1}/$merhemPlayable'), unlockAll ? findsWidgets : findsOneWidget);
    // 2026-10-28'den beri altı kategorinin hepsinde oyunda reçete var.
    expect(find.text('Yakında'), findsNothing);
    expect(find.text('0/50'), findsNothing);
    await tester.tap(find.text('Merhem ve patlar'));
    await tester.pumpAndSettle();
    expect(find.descendant(of: find.byType(GrowPanel), matching: find.text(order.formula)), findsOneWidget);
    // Uzun liste kaydırılır; her şey açıkken ekrandakilerin hepsi işaretli.
    expect(find.byIcon(Icons.check_circle_rounded), unlockAll ? findsWidgets : findsOneWidget);
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

  test('vitrine yalnız fanus konur; aynı fanus iki yerde durmaz; kayıtta kalır; eski ürün adı düşer', () async {
    SharedPreferences.setMockInitialValues({
      'deliveries_v1': saved,
      // Rafta ilaç dururken kaydedilmiş eski vitrin.
      'profile_v1': jsonEncode({'showcase': [order.magistralName, null, null]}),
    });
    final store = await JobStore.load(now: () => clock);
    expect(store.showcase, [null, null, null]);
    await store.setShowcase(0, order.magistralName); // ilaç rafa konmaz
    expect(store.showcase, [null, null, null]);
    final plant = driedPlants.first.name;
    // Fanus 5 çiçekle açılır (2026-10-29; unlockAll vitrini açmaz).
    await store.setShowcase(0, plant);
    expect(store.showcase, [null, null, null]);
    for (var i = 0; i < Garden.fanusCost; i++) {
      await store.giveSeed(plant);
      expect(await store.plant(0, plant), isTrue);
      clock = clock.add(driedPlantNamed(plant)!.growTime);
      expect(await store.harvest(0), plant);
    }
    await store.setShowcase(0, plant);
    expect(store.showcase, [plant, null, null]);
    await store.setShowcase(2, plant); // 0'dan 2'ye taşınır
    expect(store.showcase, [null, null, plant]);
    final reopened = await JobStore.load(now: () => clock);
    expect(reopened.showcase, [null, null, plant]);
    await reopened.setShowcase(2, null);
    expect(reopened.showcase, [null, null, null]);
  });

  testWidgets('Vitrin: boş yere basınca fanuslar çıkar, seçilen rafa konur, kaldırılır', (tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    // Bahçede Papatya yetiştirilmiş.
    SharedPreferences.setMockInitialValues({
      'deliveries_v1': saved,
      'garden_v1': jsonEncode(Garden(grown: {'Papatya'}).toJson()),
    });
    await tester.pumpWidget(MajistralApp(store: await JobStore.load(now: () => clock)));
    await tester.tap(find.text('Profil').last);
    await tester.pumpAndSettle();

    await tester.tap(find.bySemanticsLabel('Vitrinde boş yer, fanus koy').first);
    await tester.pumpAndSettle();
    expect(find.text('Vitrine ne koyalım?'), findsOneWidget);
    expect(find.text('Duvarda 1 reçete daha birikir'), findsOneWidget);
    expect(find.text('Hiç çiçeğin yok. Teslimde emek parası %10 artar.'), findsWidgets); // Lavanta kilitli
    await tester.tap(find.descendant(of: find.byType(GrowPanel), matching: find.text('Papatya')));
    await tester.pumpAndSettle();
    expect(find.bySemanticsLabel('Vitrinde Papatya fanusu'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.bySemanticsLabel('Vitrinde Papatya fanusu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Raftan kaldır'));
    await tester.pumpAndSettle();
    expect(find.bySemanticsLabel('Vitrinde boş yer, fanus koy'), findsNWidgets(3));
  });

  test('her fanusun ikonu var', () {
    for (final p in driedPlants) {
      expect(File(p.imagePath).existsSync(), isTrue, reason: p.imagePath);
    }
  });
}
