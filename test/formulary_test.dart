import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:game/data/formulary.dart';
import 'package:game/data/lab_tools.dart';
import 'package:game/data/orders.dart';
import 'package:game/models/formula.dart';
import 'package:game/models/prescription.dart';

void main() {
  test('altı kategoride 50\'şer, toplam 300 formül; adlar tekrarlanmıyor', () {
    expect(formulary, hasLength(300));
    for (final c in FormulaCategory.values) {
      expect(formulasOf(c), hasLength(50), reason: c.title);
    }
    final names = [for (final f in formulary) f.name];
    expect(names.toSet(), hasLength(names.length));
  });

  test('her formül üç soruyu cevaplıyor: ne işe yarar, hangi maddeler, nasıl yapılır', () {
    for (final f in formulary) {
      expect(f.use.trim(), isNotEmpty, reason: f.name);
      expect(f.ingredients, isNotEmpty, reason: f.name);
      expect(f.steps, isNotEmpty, reason: f.name);
      for (final s in f.steps) {
        expect(formulaStepNames, contains(s.name), reason: '${f.name}: ${s.name}');
        expect(s.how.trim(), isNotEmpty, reason: '${f.name}: ${s.name}');
      }
    }
  });

  test('her formül en az iki kaynağa dayanıyor ve kaynaklar listede', () {
    final ids = [for (final r in allReferences) r.id];
    expect(ids.toSet(), hasLength(ids.length));
    for (final f in formulary) {
      expect(f.refs.toSet().length, greaterThanOrEqualTo(2), reason: f.name);
      for (final id in f.refs) {
        expect(referenceById, contains(id), reason: '${f.name}: $id');
      }
    }
  });

  test('her adım adının ikonu var ve dosyası duruyor', () {
    for (final name in formulaStepNames) {
      expect(stepIcons, contains(name), reason: name);
      expect(File(stepIconPath(name)).existsSync(), isTrue, reason: name);
    }
  });

  test('formül kitabının en sık adımlarının hepsi laboratuvarda yapılabiliyor', () {
    final common = [for (final e in stepUsage()) if (e.value >= 0.1 * formulary.length) e.key];
    final kinds = {for (final t in labTools()) t.kind};
    final inLab = {
      for (final o in prescriptionOrders)
        for (final s in o.steps)
          if (kinds.contains(s.tool)) s.label,
    };
    expect(common, isNotEmpty);
    for (final name in common) {
      expect(inLab, contains(name), reason: name);
    }
  });
}
