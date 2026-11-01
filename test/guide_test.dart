import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:game/data/lab_tools.dart';
import 'package:game/data/orders.dart';
import 'package:game/logic/job_store.dart';
import 'package:game/main.dart';
import 'package:game/models/prep_job.dart';
import 'package:game/widgets/grow_panel.dart';
import 'package:game/widgets/guide_note.dart';
import 'package:game/widgets/mini_games.dart';
import 'package:game/widgets/patient_card.dart';

import 'test_fonts.dart';

/// Pulse dönerken pumpAndSettle bitmez; pencere geçişi kadar pump edilir.
Future<void> _settle(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
}

Future<void> _tab(WidgetTester tester, String name) async {
  await tester.tap(find.text(name).last);
  await _settle(tester);
}

void main() {
  setUpAll(loadAppFonts);

  late DateTime clock;
  final tools = {for (final t in labTools()) t.name: t};
  setUp(() {
    clock = DateTime(2026, 10, 31, 12);
    miniGamesEnabled = false;
    patientQuestionsEnabled = true;
    SharedPreferences.setMockInitialValues({});
  });

  Future<JobStore> guided() => JobStore.load(now: () => clock, guided: true);

  /// Reçetenin bütün adımlarını sırayla bitirir.
  Future<void> finish(JobStore store, PrepJob job) async {
    while (store.nextStep(job) != null) {
      final step = store.nextStep(job)!;
      await store.startStep(job.id, tools[step.label]!);
      job = store.job(job.id)!;
      clock = store.running(job)!.end;
    }
  }

  test('ilk açılışta duvarda tek reçete, ilk iş 30 saniye sürer', () async {
    final store = await guided();
    expect(store.guideStage, 0);
    expect(store.wall.single.orderKey, prescriptionOrders.first.key);
    expect(store.untilNextArrival, isNull);

    // Saatler geçse de ilk teslimden önce yeni reçete gelmez.
    clock = clock.add(const Duration(hours: 5));
    expect(store.wall, hasLength(1));

    final job = (await store.accept(store.wall.single))!;
    expect(store.wall, isEmpty);
    expect(store.rushHidden(job), isTrue);
    expect(store.remaining(job), JobStore.guideFirstTotal);
    final started = clock;
    await finish(store, job);
    expect(clock.difference(started), JobStore.guideFirstTotal);
  });

  test('ilk teslimde tohum ve hasta yok, duvara üç reçete gelir', () async {
    final store = await guided();
    final job = (await store.accept(store.wall.single))!;
    await finish(store, job);
    await store.deliver(job.id);
    store.askPatient(job);

    expect(store.lastDrop, isNull);
    expect(store.pendingQuestion, isNull);
    expect(store.guideStage, 1);
    expect(store.wall.map((o) => o.orderKey), [for (final o in prescriptionOrders.skip(1).take(3)) o.key]);
    expect(store.untilNextArrival, JobStore.arrivalEvery);
  });

  test('ikinci reçete kısa, üçüncüsü gerçek süreli, üç teslimde öğretici biter', () async {
    final store = await guided();
    final first = (await store.accept(store.wall.single))!;
    await finish(store, first);
    await store.deliver(first.id);

    // Oyuncu kremi seçse de ikinci reçete kısa sürer.
    final cream = store.wall.firstWhere((o) => o.magistralName == 'Hidrofil Merhem');
    expect(store.wallTime(store.orderKeyed(cream.orderKey)), JobStore.guideSecondTotal);
    final second = (await store.accept(cream))!;
    expect(store.rushHidden(second), isFalse);
    expect(store.remaining(second).inSeconds, closeTo(JobStore.guideSecondTotal.inSeconds, 2));

    // Aynı anda alınan öteki reçete gerçek süreli.
    final other = store.wall.first;
    expect(store.wallTime(store.orderKeyed(other.orderKey)), store.orderKeyed(other.orderKey).prepTime);
    final third = (await store.accept(other))!;
    expect(store.remaining(third), store.orderOf(third).prepTime);

    await finish(store, second);
    await store.deliver(second.id);
    store.askPatient(second);
    expect(store.pendingQuestion, isNotNull);
    store.closePatient();

    await finish(store, third);
    await store.deliver(third.id);
    expect(store.guideStage, isNull);
    expect(store.guideNotes, isFalse);
  });

  test('öğretici yarıda kapanıp açılınca kaldığı yerden sürer', () async {
    final store = await guided();
    final first = (await store.accept(store.wall.single))!;
    await finish(store, first);
    await store.deliver(first.id);
    final second = (await store.accept(store.wall.first))!;

    final reopened = await guided();
    expect(reopened.guideStage, 1);
    expect(reopened.wall, hasLength(2));
    expect(reopened.remaining(reopened.job(second.id)!), JobStore.guideSecondTotal);
  });

  test('eski oyuncu öğretici görmez', () async {
    SharedPreferences.setMockInitialValues({
      'wall_v1': '{"wall":[],"nextId":4,"due":0,"seen":[]}',
    });
    final store = await guided();
    expect(store.guideStage, isNull);
    expect(store.wall, isNotEmpty);
  });

  test('bozuk kayıtta oyun notsuz sürer', () async {
    SharedPreferences.setMockInitialValues({
      'wall_v1': '{"wall":[],"nextId":4,"due":0,"seen":[]}',
      'guide_v1': 'bozuk',
    });
    expect((await guided()).guideStage, isNull);
  });

  test('laboratuvar notu adımı izler, öğrettiğini saklar', () async {
    final store = await guided();
    expect(labGuide(store)!.toOrders, isTrue);
    expect(labGuide(store)!.rows.first.title, 'Reçeteni al');

    var job = (await store.accept(store.wall.single))!;
    expect(labGuide(store)!.rows.map((r) => r.mark), [GuideMark.now, GuideMark.later, GuideMark.later]);
    expect(labGuide(store)!.rows.first.note, 'Ezme kartına dokun.');

    await store.startStep(job.id, tools['Ezme']!);
    job = store.job(job.id)!;
    expect(labGuide(store)!.rows.first.note, 'Sürüyor. Bitince sıra Levigasyon adımında.');

    clock = store.running(job)!.end;
    var rows = labGuide(store)!.rows;
    expect(rows[0].mark, GuideMark.done);
    expect(rows[0].note, 'Taneleri incelttin, merhem kumlu olmaz.');
    expect(rows[1].mark, GuideMark.now);
    expect(rows[1].note, 'Levigasyon kartına dokun.');

    await store.startStep(job.id, tools['Levigasyon']!);
    job = store.job(job.id)!;
    clock = store.running(job)!.end;
    await store.startStep(job.id, tools['Geometrik seyreltme']!);
    job = store.job(job.id)!;
    rows = labGuide(store)!.rows;
    expect(rows[0].note, isNull); // yalnız son bitenin öğrettiği yazar
    expect(rows[1].note, 'Tozu azıcık sıvıyla macun yaptın. Buna levigasyon denir.');
    expect(rows[2].note, 'Sürüyor. Bitince ilacın hazır.');

    clock = store.running(job)!.end;
    final ready = labGuide(store)!;
    expect(ready.toOrders, isTrue);
    expect(ready.rows.every((r) => r.mark == GuideMark.done), isTrue);
    expect(ready.footer, 'İlacın hazır, şimdi hastaya teslim edebilirsin.');
  });

  test('ikinci reçetede not ancak takılınca çıkar', () async {
    final store = await guided();
    final first = (await store.accept(store.wall.single))!;
    await finish(store, first);
    await store.deliver(first.id);
    expect(counterGuide(store)!.rows.single.title, 'Duvara üç reçete geldi.');

    var job = (await store.accept(store.wall.first))!;
    expect(labGuide(store), isNull);
    clock = clock.add(guideIdle);
    expect(labGuide(store)!.rows.single.note, 'Levigasyon kartına dokun.');

    await store.startStep(job.id, tools['Levigasyon']!);
    expect(labGuide(store)!.rows.single.title, 'Adım sürerken duvardan bir reçete daha alabilirsin.');
    job = store.job(job.id)!;
  });

  test('notlar kapatılınca çıkmaz, süreler kısa kalır', () async {
    final store = await guided();
    await store.setGuideNotes(false);
    expect(store.guideClosed, isTrue);
    expect(counterGuide(store), isNull);
    expect(labGuide(store), isNull);

    final job = (await store.accept(store.wall.single))!;
    expect(store.remaining(job), JobStore.guideFirstTotal);
    expect((await guided()).guideClosed, isTrue);
  });

  testWidgets('ilk ekran, reçete kâğıdı ve laboratuvar notu', (tester) async {
    tester.view.physicalSize = const Size(1170, 2532); // 390 × 844
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final store = await guided();
    await tester.pumpWidget(MajistralApp(store: store));

    expect(find.text('Duvarda 1 reçete var.'), findsOneWidget);
    expect(find.text('Reçeteni al'), findsOneWidget);
    expect(find.text('Hastaya teslim et'), findsOneWidget);
    expect(find.text('30 sn'), findsOneWidget);

    await tester.tap(find.text(prescriptionOrders.first.magistralName));
    await _settle(tester);
    expect(find.textContaining('Maddeleri senin için tarttık'), findsOneWidget);

    await tester.tap(find.text('Al'));
    await _settle(tester);
    await tester.tap(find.text('Laboratuvara git'));
    await _settle(tester);
    expect(find.text('Ezme kartına dokun.'), findsOneWidget);

    await tester.tap(find.text('Ezme').last);
    await _settle(tester);
    expect(find.byType(GrowPanel), findsNothing); // tek reçete: pencere açılmaz
    expect(store.jobs.single.runs.single.label, 'Ezme');
    expect(find.text('Acele et'), findsNothing);
  });

  testWidgets('defter sayfası adım değişirken boyunu korur', (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final store = await guided();
    var job = (await store.accept(store.wall.single))!;
    await tester.pumpWidget(MajistralApp(store: store));
    await _tab(tester, 'Laboratuvar');

    final heights = <double>[];
    Future<void> measure() async {
      await tester.pump(const Duration(seconds: 1));
      heights.add(tester.getSize(find.byType(GuideNote)).height);
    }

    await measure();
    for (final step in store.orderOf(job).steps) {
      await store.startStep(job.id, tools[step.label]!);
      job = store.job(job.id)!;
      await measure();
      clock = store.running(job)!.end;
      if (step != store.orderOf(job).steps.last) await measure();
    }
    expect(heights.toSet(), hasLength(1), reason: '$heights');
  });

  testWidgets('notları kapatınca Diğer\'de geri açma düğmesi çıkar', (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final store = await guided();
    await tester.pumpWidget(MajistralApp(store: store));

    await tester.tap(find.text('Notları kapat'));
    await _settle(tester);
    expect(find.text('Tezgâhın boş. Duvardan bir reçete al.'), findsOneWidget);

    await _tab(tester, 'Diğer');
    await tester.tap(find.text('Notları yeniden göster'));
    await _settle(tester);
    expect(store.guideNotes, isTrue);
    expect(find.text('Notları yeniden göster'), findsNothing);
  });

  testWidgets('mini oyunda uyarı görünür, reçetenin sıvısı yazar, dışarı dokunmak kapatmaz', (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    miniGamesEnabled = true;
    final store = await guided();
    final job = (await store.accept(store.wall.single))!;
    await tester.pumpWidget(MajistralApp(store: store));
    await _tab(tester, 'Laboratuvar');

    await tester.tap(find.text('Ezme').last);
    await _settle(tester);
    expect(find.textContaining('çelikle tepkimeye girer'), findsOneWidget);
    expect(find.text('Yanlış yapsan da ilacın satılır.'), findsOneWidget);

    await tester.tapAt(const Offset(5, 5));
    await _settle(tester);
    expect(find.byType(MiniGameView), findsOneWidget);

    // Sonraki adımın oyunu: öteki yazılar değişir, güven cümlesi yalnız ilk oyunda.
    await store.startStep(job.id, tools['Ezme']!);
    Navigator.of(tester.element(find.byType(MiniGameView))).pop();
    await _settle(tester);
    clock = store.running(store.job(job.id)!)!.end;
    await tester.pump(const Duration(seconds: 1));
    await tester.tap(find.text('Levigasyon').last);
    await _settle(tester);
    expect(find.textContaining('bir damla sıvı parafin'), findsOneWidget);
    expect(find.text('Yanlış yapsan da ilacın satılır.'), findsNothing);
  });

  testWidgets('dar telefonda oyun penceresi uyarılarla birlikte taşmaz', (tester) async {
    tester.view.physicalSize = const Size(960, 1707); // 320 × 569
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    miniGamesEnabled = true;
    final store = await guided();
    final job = (await store.accept(store.wall.single))!;
    await tester.pumpWidget(MajistralApp(store: store));
    await _tab(tester, 'Laboratuvar');

    await tester.tap(find.text('Ezme').last);
    await _settle(tester);
    expect(find.byType(MiniGameView), findsOneWidget);
    await store.startStep(job.id, tools['Ezme']!);
    Navigator.of(tester.element(find.byType(MiniGameView))).pop();
    await _settle(tester);
    clock = store.running(store.job(job.id)!)!.end;
    await tester.pump(const Duration(seconds: 1));

    // Levigasyonda bir de düğme var, en uzun pencere bu.
    await tester.tap(find.text('Levigasyon').last);
    await _settle(tester);
    expect(find.text('Spatülle'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('rozet işin yapılacağı sekmede', (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final store = await JobStore.load(now: () => clock);
    await store.accept(store.wall.first);
    await tester.pumpWidget(MajistralApp(store: store));
    await tester.pump();
    final ordersTab = tester.getCenter(find.text('Reçeteler').last).dx;
    final badge = tester.getCenter(find.text('1').last).dx;
    expect(badge, greaterThan(ordersTab + 40)); // laboratuvarın üstünde
  });
}
