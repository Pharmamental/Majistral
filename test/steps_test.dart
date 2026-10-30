import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:game/data/lab_tools.dart';
import 'package:game/data/orders.dart';
import 'package:game/data/stations.dart';
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

  test('kart adımı yapan aleti yazar; yükseltme alınınca onu', () {
    String equipment(List tools, String step) => tools.firstWhere((t) => t.name == step).equipment;
    // Satın alma öncesi: yalnız ücretsiz kademeler elde (unlockAll'dan bağımsız).
    bool free(ShopItem i) => i.price == 0;
    expect(equipment(labTools(owns: free), 'Geometrik seyreltme'), 'Merhem taşı ve spatül ya da porselen havan');
    expect(equipment(labTools(owns: free), 'Kapsül doldurma'), 'Kapsül doldurma aleti');
    const bought = {'Unguator', 'Termostatlı su banyosu'};
    final upgraded = labTools(owns: (i) => free(i) || bought.contains(i.name));
    expect(equipment(upgraded, 'Geometrik seyreltme'), 'Unguator');
    expect(equipment(upgraded, 'Eritme'), 'Termostatlı su banyosu');
    expect(equipment(upgraded, 'Levigasyon'), 'Porselen havan ya da merhem taşı ve spatül');
  });

  // Kural (Tuğrul, 2026-10-29): markette her adımın istasyonu; basit alet
  // ücretsiz, daha iyisi parayla ve yalnız süreyi kısaltır.
  test('marketin istasyonları laboratuvarın adımları, her birinde süre kısaltan yükseltme', () {
    expect([for (final s in stations) s.name], [for (final t in labTools()) t.name]);
    for (final s in stations) {
      expect(s.tiers.first.price, 0, reason: '${s.name}: ilk alet ücretsiz');
      expect(s.tiers.first.faster, 0, reason: s.name);
      final paid = s.tiers.skip(1).toList();
      expect(paid, isNotEmpty, reason: '${s.name}: yükseltme yok');
      for (final t in paid) {
        expect(t.price, greaterThan(0), reason: t.name);
        expect(t.faster, inInclusiveRange(1, 99), reason: t.name);
      }
      for (var i = 1; i < s.tiers.length; i++) {
        expect(s.tiers[i].faster, greaterThan(s.tiers[i - 1].faster), reason: '${s.name}: sonraki alet daha hızlı');
      }
    }
  });
}
