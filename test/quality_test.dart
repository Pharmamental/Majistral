import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:game/data/orders.dart';
import 'package:game/logic/quality.dart';
import 'package:game/models/prescription.dart';

void main() {
  final order = prescriptionOrders.first; // %5 salisilik asitli vazelin
  final cream = prescriptionOrders[2]; // hidrofil merhem

  /// Her alet türünden ilk uygun seçenek.
  Map<ToolKind, String> rightTools(PrescriptionOrder o) => {
        for (final req in o.tools) req.kind: req.allowed.first,
      };

  PreparationResult evaluate({Map<ToolKind, String>? tools}) =>
      evaluatePreparation(order: order, selectedTools: tools ?? rightTools(order));

  test('doğru aletle 3 yıldız, açıklama yok', () {
    final r = evaluate();
    expect(r.stars, 3);
    expect(r.notes, isEmpty);
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
          selectedTools: {...rightTools(cream), ToolKind.surface: surface},
        );
    expect(run('Merhem taşı').stars, 3);
    final wrong = run('Parşömen blok');
    expect(wrong.stars, 2);
    expect(wrong.notes.single, contains('suyunu emer'));
  });

  test('her adımın kendi ikonu var ve dosyası duruyor', () {
    for (final o in prescriptionOrders) {
      for (final step in o.steps) {
        expect(stepIcons, contains(step.label), reason: step.label);
        expect(File(step.imagePath).existsSync(), isTrue, reason: step.imagePath);
      }
    }
  });
}
