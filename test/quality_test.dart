import 'package:flutter_test/flutter_test.dart';

import 'package:game/data/orders.dart';
import 'package:game/logic/quality.dart';

void main() {
  final order = prescriptionOrders.first;
  final correctSteps = [for (final s in order.steps) s.label];

  test('doğru kimyasal ve doğru sıra 3 yıldız, açıklama yok', () {
    final r = evaluatePreparation(
      order: order,
      selectedChemicals: order.chemicals.toSet(),
      stepOrder: correctSteps,
    );
    expect(r.stars, 3);
    expect(r.notes, isEmpty);
  });

  test('eksik kimyasal bir yıldız götürür ve adını söyler', () {
    final r = evaluatePreparation(
      order: order,
      selectedChemicals: order.chemicals.skip(1).toSet(),
      stepOrder: correctSteps,
    );
    expect(r.stars, 2);
    expect(r.notes.single, contains(order.chemicals.first));
  });

  test('reçetede olmayan kimyasal bir yıldız götürür', () {
    final r = evaluatePreparation(
      order: order,
      selectedChemicals: {...order.chemicals, order.distractors.first},
      stepOrder: correctSteps,
    );
    expect(r.stars, 2);
    expect(r.notes.single, contains(order.distractors.first));
  });

  test('yanlış sıra bir yıldız götürür, ipucu ve doğru sırayı gösterir', () {
    final r = evaluatePreparation(
      order: order,
      selectedChemicals: order.chemicals.toSet(),
      stepOrder: correctSteps.reversed.toList(),
    );
    expect(r.stars, 2);
    expect(r.notes, contains(order.sequenceHint));
    expect(r.notes.last, startsWith('Doğru sıra:'));
  });

  test('bütün hatalar birlikte olsa da en düşük kalite 1 yıldız', () {
    final r = evaluatePreparation(
      order: order,
      selectedChemicals: {order.distractors.first},
      stepOrder: correctSteps.reversed.toList(),
    );
    expect(r.stars, 1);
  });
}
