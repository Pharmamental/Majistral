import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:game/data/lab_tools.dart';
import 'package:game/data/orders.dart';
import 'package:game/models/prescription.dart';
import 'package:game/models/shop_item.dart';

void main() {
  test('her adımın kendi ikonu var ve dosyası duruyor', () {
    for (final o in prescriptionOrders) {
      for (final step in o.steps) {
        expect(stepIcons, contains(step.label), reason: step.label);
        expect(File(step.imagePath).existsSync(), isTrue, reason: step.imagePath);
      }
    }
  });

  // Kural (Tuğrul, 2026-10-28): reçetedeki her adım = laboratuvardaki bir kart.
  test('reçetedeki her adımın laboratuvarda aynı adlı tek bir kartı var', () {
    final names = [for (final t in labTools()) t.name];
    expect(names.toSet(), hasLength(names.length));
    for (final o in prescriptionOrders) {
      for (final step in o.steps) {
        expect(names, contains(step.label), reason: '${o.magistralName}: ${step.label}');
      }
    }
    expect(names, [
      'Ezme',
      'Levigasyon',
      'Geometrik seyreltme',
      'Eritme',
      'Çözme',
      'Emülsifikasyon',
      'Soğutma',
      'Elekten geçirme',
      'Karıştırma',
      'Şişirme',
      'Hacme tamamlama',
      'Kapsül doldurma',
    ]);
    for (final t in labTools()) {
      expect(File(t.imagePath).existsSync(), isTrue, reason: t.imagePath);
    }
  });

  test('kart adımı yapan aleti yazar; Unguator alınınca karıştırma ona geçer', () {
    String equipment(List tools, String step) => tools.firstWhere((t) => t.name == step).equipment;
    // Satın alma öncesi: yalnız ücretsiz kademeler elde (unlockAll'dan bağımsız).
    bool free(ShopItem i) => i.price == 0;
    expect(equipment(labTools(owns: free), 'Geometrik seyreltme'), 'Merhem taşı ve spatül · Porselen havan');
    expect(equipment(labTools(owns: free), 'Kapsül doldurma'), 'Kapsül doldurma aleti');
    const bought = {'Unguator', 'Termostatlı su banyosu'};
    final upgraded = labTools(owns: (i) => free(i) || bought.contains(i.name));
    expect(equipment(upgraded, 'Geometrik seyreltme'), 'Unguator · Porselen havan');
    expect(equipment(upgraded, 'Eritme'), 'Termostatlı su banyosu');
  });
}
