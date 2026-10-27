import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:game/data/lab_tools.dart';
import 'package:game/data/orders.dart';
import 'package:game/models/prescription.dart';

void main() {
  test('her adımın kendi ikonu var ve dosyası duruyor', () {
    for (final o in prescriptionOrders) {
      for (final step in o.steps) {
        expect(stepIcons, contains(step.label), reason: step.label);
        expect(File(step.imagePath).existsSync(), isTrue, reason: step.imagePath);
      }
    }
  });

  test('laboratuvarda sahip olunan aletler: havan ve spatüller ayrı, kademede en yükseği', () {
    expect([for (final t in labTools()) t.name],
        ['Porselen havan', 'Çelik spatül', 'Plastik spatül', 'Ocak ve su banyosu', 'Kavanoz']);
    for (final t in labTools()) {
      expect(File(t.imagePath).existsSync(), isTrue, reason: t.imagePath);
    }
  });

  test('Unguator alınınca karıştırma ona geçer, spatül gerekmez; termostatlı banyo ocağın yerini alır', () {
    const bought = {'Unguator', 'Termostatlı su banyosu', 'Cam havan'};
    final tools = labTools(owns: (i) => isOwned(i) || bought.contains(i.name));
    expect([for (final t in tools) t.name],
        ['Porselen havan', 'Cam havan', 'Unguator', 'Termostatlı su banyosu', 'Kavanoz']);
    expect(tools.firstWhere((t) => t.name == 'Unguator').kind, StepTool.karistirma);
  });

  test('her adımın türünden laboratuvarda en az bir alet var', () {
    final kinds = {for (final t in labTools()) t.kind};
    for (final o in prescriptionOrders) {
      for (final step in o.steps) {
        expect(kinds, contains(step.tool), reason: '${o.magistralName}: ${step.label}');
      }
    }
  });
}
