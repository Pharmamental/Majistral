import 'package:flutter_test/flutter_test.dart';

import 'package:game/data/orders.dart';
import 'package:game/logic/quality.dart';
import 'package:game/models/prescription.dart';

void main() {
  final order = prescriptionOrders.first; // %5 salisilik asitli vazelin
  final cream = prescriptionOrders[2]; // hidrofil merhem
  final correctSteps = [for (final s in order.steps) s.label];

  /// Her alet türünden ilk uygun seçenek.
  Map<ToolKind, String> rightTools(PrescriptionOrder o) => {
        for (final req in o.tools) req.kind: req.allowed.first,
      };

  PreparationResult evaluate({
    Set<String>? chemicals,
    List<String>? steps,
    Map<ToolKind, String>? tools,
  }) =>
      evaluatePreparation(
        order: order,
        selectedChemicals: chemicals ?? order.chemicals.toSet(),
        stepOrder: steps ?? correctSteps,
        selectedTools: tools ?? rightTools(order),
      );

  test('doğru kimyasal, doğru alet ve doğru sıra 3 yıldız, açıklama yok', () {
    final r = evaluate();
    expect(r.stars, 3);
    expect(r.notes, isEmpty);
  });

  test('eksik kimyasal bir yıldız götürür ve adını söyler', () {
    final r = evaluate(chemicals: order.chemicals.skip(1).toSet());
    expect(r.stars, 2);
    expect(r.notes.single, contains(order.chemicals.first));
  });

  test('reçetede olmayan kimyasal bir yıldız götürür', () {
    final r = evaluate(chemicals: {...order.chemicals, order.distractors.first});
    expect(r.stars, 2);
    expect(r.notes.single, contains(order.distractors.first));
  });

  test('yanlış sıra bir yıldız götürür, ipucu ve doğru sırayı gösterir', () {
    final r = evaluate(steps: correctSteps.reversed.toList());
    expect(r.stars, 2);
    expect(r.notes, contains(order.sequenceHint));
    expect(r.notes.last, startsWith('Doğru sıra:'));
  });

  test('salisilik asitte çelik spatül bir yıldız götürür ve nedenini söyler', () {
    final r = evaluate(tools: {...rightTools(order), ToolKind.spatula: 'Çelik spatül'});
    expect(r.stars, 2);
    expect(r.notes.single, contains('plastik spatül'));
  });

  test('iki alet yanlış olsa da alet hatası tek yıldız götürür, iki açıklama verir', () {
    final r = evaluate(tools: {
      ...rightTools(order),
      ToolKind.spatula: 'Çelik spatül',
      ToolKind.mortar: 'Cam havan',
    });
    expect(r.stars, 2);
    expect(r.notes, hasLength(2));
  });

  test('alet seçilmemişse yanlış sayılır', () {
    final r = evaluate(tools: const {});
    expect(r.stars, 2);
  });

  test('kremde parşömen blok yanlış, merhem taşı doğru', () {
    PreparationResult run(String surface) => evaluatePreparation(
          order: cream,
          selectedChemicals: cream.chemicals.toSet(),
          stepOrder: [for (final s in cream.steps) s.label],
          selectedTools: {...rightTools(cream), ToolKind.surface: surface},
        );
    expect(run('Merhem taşı').stars, 3);
    final wrong = run('Parşömen blok');
    expect(wrong.stars, 2);
    expect(wrong.notes.single, contains('suyunu emer'));
  });

  test('bütün hatalar birlikte olsa da en düşük kalite 1 yıldız', () {
    final r = evaluate(
      chemicals: {order.distractors.first},
      steps: correctSteps.reversed.toList(),
      tools: const {},
    );
    expect(r.stars, 1);
  });

  group('tartım', () {
    Map<String, double?> exact(PrescriptionOrder o) => {for (final i in o.ingredients) i.name: i.grams};

    test('reçetelerin toplamı yazılan toplamla aynı', () {
      expect(prescriptionOrders[0].totalGrams, closeTo(50, 1e-9));
      expect(prescriptionOrders[1].totalGrams, closeTo(60, 1e-9));
      // USP hidrofil merhem "yaklaşık 1000 g" yapar: parabenlerle 1000,4 g.
      expect(cream.totalGrams, closeTo(100.04, 1e-9));
    });

    test('doğru tartım açıklama üretmez, %5 içindeki yuvarlama da doğru sayılır', () {
      for (final o in prescriptionOrders) {
        expect(evaluateWeighing(o, exact(o)), isEmpty, reason: o.magistralName);
      }
      expect(evaluateWeighing(order, {...exact(order), 'Beyaz Vazelin': 46.3}), isEmpty);
    });

    test('"ad"ı unutmak ve 10 kat hata yakalanır', () {
      expect(evaluateWeighing(order, {...exact(order), 'Beyaz Vazelin': 50}), hasLength(2));
      final ten = evaluateWeighing(cream, {...exact(cream), 'Metilparaben': 0.25});
      expect(ten.first, 'Tartım: Metilparaben 0,25 g tartıldı, doğrusu 0,025 g.');
      expect(ten.last, cream.calcHint);
    });

    test('gram Türkçe yazılır ve virgüllü sayı okunur', () {
      expect(formatGrams(46.25), '46,25');
      expect(formatGrams(12), '12');
      expect(formatGrams(0.025), '0,025');
      expect(formatGrams(100), '100');
      expect(parseGrams(' 46,25 '), 46.25);
      expect(parseGrams('2.5'), 2.5);
      expect(parseGrams('abc'), isNull);
    });
  });
}
