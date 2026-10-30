import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game/data/lab_tools.dart';
import 'package:game/data/market_items.dart';
import 'package:game/data/orders.dart';
import 'package:game/data/patient_uses.dart';
import 'package:game/logic/job_store.dart';
import 'package:game/models/patient_question.dart';
import 'package:game/main.dart';
import 'package:game/widgets/grow_panel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'test_fonts.dart';
import 'test_helpers.dart';

void main() {
  setUpAll(loadAppFonts);
  final at = DateTime(2026, 10, 30, 10);

  test('veri: her ilaç reçetesinin kullanımı var, adlar reçetelerle aynı', () {
    final keys = {for (final o in prescriptionOrders) o.key};
    for (final key in [...orderUses.keys, ...unverifiedOrders]) {
      expect(keys, contains(key));
    }
    for (final uses in orderUses.values) {
      for (final u in uses) {
        expect(useAnswers, contains(u));
      }
    }
    // Bazlar dışında bütün reçeteler kullanım sorusuna girer.
    expect(keys.difference({...orderUses.keys, ...unverifiedOrders}), hasLength(10));
  });

  test('bütün sorular kurulur: 3 ayrı şık, doğrusu bir tane, yanlış şık bu ilaç için doğru değil', () {
    final rnd = math.Random(3);
    var count = 0;
    for (final order in prescriptionOrders) {
      for (final id in questionIdsFor(order)) {
        final q = buildPatientQuestion(id, order, rnd)!;
        count++;
        expect(q.options.toSet(), hasLength(questionKind(id) == 'has' ? 2 : 3), reason: id);
        expect(q.answer, lessThan(q.options.length));
        if (id.endsWith('|use')) {
          final mine = {for (final u in orderUses[order.key]!) useAnswers[u]};
          for (final (i, o) in q.options.indexed) {
            if (i != q.answer) expect(mine, isNot(contains(o)), reason: id);
          }
        }
      }
    }
    expect(count, greaterThan(250));
    expect(prescriptionOrders.expand(questionIdsFor).where((id) => id.endsWith('|shelf')), isEmpty);
  });

  test('var mı sorusu: cevap reçeteye uyar, adından belli madde sorulmaz, hazır baz maddesi yok denmez', () {
    final rnd = math.Random(5);
    final actives = {for (final g in chemicalGroups.skip(5)) for (final i in g.items) i.name};
    var yes = 0, no = 0;
    for (final order in prescriptionOrders) {
      final names = {for (final i in order.ingredients) i.name};
      for (final id in questionIdsFor(order).where((id) => questionKind(id) == 'has')) {
        final name = id.substring(id.indexOf('has:') + 4);
        final q = buildPatientQuestion(id, order, rnd)!;
        expect(q.answer == 0, names.contains(name), reason: id);
        if (q.answer == 0) {
          yes++;
        } else {
          no++;
          expect(actives, contains(name), reason: id);
        }
      }
    }
    expect(yes, greaterThan(100));
    expect(no, greaterThan(100));

    final salisilik = prescriptionOrders.firstWhere((o) => o.key == '%5 Salisilik Asitli Vazelin');
    final ids = questionIdsFor(salisilik);
    expect(ids, contains('${salisilik.key}|has:Sıvı Parafin'));
    expect(ids, isNot(contains('${salisilik.key}|has:Salisilik Asit')));
    expect(ids, isNot(contains('${salisilik.key}|has:Beyaz Vazelin')));

    final kalamin = prescriptionOrders.firstWhere((o) => o.key == 'Kalamin merhemi %15 (BP)');
    expect(questionIdsFor(kalamin), isNot(contains('${kalamin.key}|has:Çinko Oksit')));
  });

  test('kuşkulu reçeteden soru çıkmaz, deri ilacında diş şıkkı olmaz', () {
    for (final o in prescriptionOrders.where((o) => unverifiedOrders.contains(o.key))) {
      expect(questionIdsFor(o), isEmpty);
    }
    final order = prescriptionOrders.firstWhere((o) => o.key == 'Klotrimazollü krem %1');
    for (var i = 0; i < 20; i++) {
      final q = buildPatientQuestion('${order.key}|use', order, math.Random(i))!;
      expect(q.options, isNot(contains(useAnswers['curuk'])));
    }
  });

  test('defter: yanlış bilinen soru 1, 3, 7 gün sonra gelir, sonra biter', () {
    final book = PatientBook();
    book.record('a', right: true, now: at);
    expect(book.dueAt(at.add(const Duration(days: 30))), isEmpty, reason: 'ilk seferde bilinen dönmez');
    book.record('b', right: false, now: at);
    expect(book.dueAt(at), isEmpty);
    var t = at.add(const Duration(days: 1));
    expect(book.dueAt(t), ['b']);
    book.record('b', right: true, now: t);
    expect(book.dueAt(t.add(const Duration(days: 2))), isEmpty);
    t = t.add(const Duration(days: 3));
    expect(book.dueAt(t), ['b']);
    book.record('b', right: true, now: t);
    t = t.add(const Duration(days: 7));
    expect(book.dueAt(t), ['b']);
    book.record('b', right: true, now: t);
    expect(book.dueAt(t.add(const Duration(days: 30))), isEmpty);
    expect(PatientBook.fromJson(book.toJson()).asked['b']!.due, isNull);
  });

  group('oyunda', () {
    late DateTime clock;
    setUp(() {
      clock = at;
      SharedPreferences.setMockInitialValues({});
    });

    test('günde 3 soru; doğruda bahşiş, yanlış soru ertesi gün başka teslimde döner', () async {
      final store = await JobStore.load(now: () => clock, random: math.Random(1));
      final order = prescriptionOrders.first;
      final tools = {for (final t in labTools()) t.name: t};
      await take(store, order);
      for (final s in order.steps) {
        await store.startStep(jobOf(store, order)!.id, tools[s.label]!);
        clock = clock.add(Duration(minutes: s.minutes));
      }
      final job = (await store.deliver(jobOf(store, order)!.id))!;
      final start = store.coins;
      expect(store.patientTip, (store.lastPayout!.coins / 10).ceil());

      final first = store.nextPatientQuestion(job)!;
      expect(first.returning, isFalse);
      await store.answerPatient(first, first.answer);
      expect(store.coins, start + store.patientTip);

      final second = store.nextPatientQuestion(job)!;
      expect(second.id, isNot(first.id), reason: 'sorulan soru tekrar gelmez');
      final wrong = (second.answer + 1) % 3;
      expect(await store.answerPatient(second, wrong), isFalse);
      expect(store.coins, start + store.patientTip, reason: 'yanlışta ceza yok');

      final third = store.nextPatientQuestion(job)!;
      await store.answerPatient(third, third.answer);
      expect(store.nextPatientQuestion(job), isNull, reason: 'günde 3 soru');

      clock = clock.add(const Duration(days: 1));
      final reopened = await JobStore.load(now: () => clock, random: math.Random(2));
      final back = reopened.nextPatientQuestion(job)!;
      expect(back.id, second.id);
      expect(back.returning, isTrue);
    });
  });

  testWidgets('soru pencere açmadan tezgâhta çıkar; cevaplayınca reçeteler geri gelir', (tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    SharedPreferences.setMockInitialValues({});
    final store = await JobStore.load(now: () => at, random: math.Random(4));
    final order = prescriptionOrders.first;
    final job = await take(store, order);
    await tester.pumpWidget(MajistralApp(store: store));
    await tester.pumpAndSettle();
    store.askPatient(job);
    await tester.pumpAndSettle();

    final q = store.pendingQuestion!;
    expect(find.text(q.ask), findsOneWidget);
    expect(find.byType(GrowPanel), findsNothing, reason: 'pencere açılmaz');
    expect(find.text('Elinde 1 reçete var, 1 seni bekliyor'), findsOneWidget, reason: 'sayfa değişmez');
    expect(find.text('Tamam'), findsNothing);

    await tester.tap(find.text(q.options[q.answer]));
    await tester.pumpAndSettle();
    expect(find.textContaining('Doğru bildin'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Tamam'));
    await tester.pumpAndSettle();
    expect(store.pendingQuestion, isNull);
    expect(find.text(q.ask), findsNothing);
    expect(find.text(order.magistralName), findsOneWidget);
  });
}
