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
import 'package:game/widgets/grow_panel.dart';

import 'test_fonts.dart';
import 'test_helpers.dart';

void main() {
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

    await tester.tap(find.byTooltip('Adları değiştir'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'Tuğrul');
    await tester.tap(find.text('Kaydet'));
    await tester.pumpAndSettle();
    expect(find.text('Tuğrul'), findsOneWidget);
  });
}

/// Formül kitabında bu adda formül var mı?
bool referenceFormula(String name) => formulary.any((f) => f.name == name);
