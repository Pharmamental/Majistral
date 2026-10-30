import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game/data/economy.dart';
import 'package:game/data/market_items.dart';
import 'package:game/data/orders.dart';
import 'package:game/data/patient_uses.dart';
import 'package:game/logic/job_store.dart';
import 'package:game/models/patient_question.dart';
import 'package:game/widgets/patient_sheet.dart';
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
        expect(q.options.toSet(), hasLength(3), reason: id);
        expect(q.answer, inInclusiveRange(0, 2));
        if (id.endsWith('|use')) {
          final mine = {for (final u in orderUses[order.key]!) useAnswers[u]};
          for (final (i, o) in q.options.indexed) {
            if (i != q.answer) expect(mine, isNot(contains(o)), reason: id);
          }
        }
      }
    }
    expect(count, greaterThan(300));
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
      await take(store, order);
      final job = jobOf(store, order)!;
      final start = store.coins;

      final first = store.nextPatientQuestion(job)!;
      expect(first.returning, isFalse);
      await store.answerPatient(first, first.answer);
      expect(store.coins, start + patientTip);

      final second = store.nextPatientQuestion(job)!;
      expect(second.id, isNot(first.id), reason: 'sorulan soru tekrar gelmez');
      final wrong = (second.answer + 1) % 3;
      expect(await store.answerPatient(second, wrong), isFalse);
      expect(store.coins, start + patientTip, reason: 'yanlışta ceza yok');

      final third = store.nextPatientQuestion(job)!;
      await store.answerPatient(third, third.answer);
      expect(store.nextPatientQuestion(job), isNull, reason: 'günde 3 soru');

      clock = clock.add(const Duration(days: 1));
      final reopened = await JobStore.load(now: () => clock, random: math.Random(2));
      final back = reopened.nextPatientQuestion(jobOf(reopened, order)!)!;
      expect(back.id, second.id);
      expect(back.returning, isTrue);
    });
  });

  testWidgets('pencere: şıkka basınca açıklama ve Tamam gelir, telefonda taşmaz', (tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final store = await JobStore.load(now: () => at);
    final order = prescriptionOrders.first;
    final q = buildPatientQuestion('${order.key}|item:Sıvı Parafin', order, math.Random(1))!;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () => askPatient(context, store, q, from: const Rect.fromLTWH(10, 10, 40, 40)),
            child: const Text('aç'),
          ),
        ),
      ),
    ));
    await tester.tap(find.text('aç'));
    await tester.pumpAndSettle();
    expect(find.text('İçindeki Sıvı Parafin ne işe yarıyor?'), findsOneWidget);
    expect(find.text('Tamam'), findsNothing);

    await tester.tap(find.text(chemicalRole('Sıvı Parafin')!).first);
    await tester.pumpAndSettle();
    expect(find.textContaining('Doğru bildin'), findsOneWidget);
    expect(find.text('Tamam'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
