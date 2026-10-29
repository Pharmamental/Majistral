import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:game/data/market_items.dart';
import 'package:game/data/orders.dart';

void main() {
  final sold = [for (final g in chemicalGroups) for (final i in g.items) i.name];

  test('reçetelerdeki her madde markette satılıyor', () {
    for (final order in prescriptionOrders) {
      for (final i in order.ingredients) {
        expect(sold, contains(i.name), reason: '${order.magistralName}: ${i.name}');
      }
    }
  });

  test('her maddenin oyuncak blok ikonu var ve dosyası duruyor', () {
    for (final g in chemicalGroups) {
      for (final i in g.items) {
        expect(i.imagePath, isNotNull, reason: i.name);
        expect(File(i.imagePath!).existsSync(), isTrue, reason: i.imagePath);
      }
    }
  });

  test('markette aynı madde iki kez yok', () {
    expect(sold.toSet(), hasLength(sold.length));
  });

  // Tuğrul, 2026-10-29: "farklı majistral sayımız çok az" → 62 madde, 100'ün
  // üstünde farklı majistral; reçetede geçmeyen madde markette durmaz.
  test('markette 55-65 madde var, her biri en az bir reçetede geçiyor', () {
    expect(sold.length, inInclusiveRange(55, 65));
    for (final name in sold) {
      expect(prescriptionOrders.any((o) => o.ingredients.any((i) => i.name == name)), isTrue, reason: name);
    }
  });

  // Tuğrul, 2026-10-29: "her formül tek reçete".
  test('her formül tek reçete, 100\'ün üstünde; kimlikler tek, ilk altısı elle yazılanlar', () {
    final formulas = [for (final o in prescriptionOrders) o.formula];
    expect(formulas.toSet(), hasLength(formulas.length));
    expect(formulas.length, greaterThan(100));
    final keys = [for (final o in prescriptionOrders) o.key];
    expect(keys.toSet(), hasLength(keys.length));
    expect(prescriptionOrders.first.key, '%5 Salisilik Asitli Vazelin');
  });

  // Tuğrul, 2026-10-29: "100 gramda hangi maddeden kaç g var onu yaz ama oyunun
  // bir mekaniği olmasın".
  test('miktar bilgi: gram ve mL hep 100 için yazılır, "hazırla" notu yok', () {
    expect([for (final i in prescriptionOrders.first.ingredients) i.written], ['%5', '3 g', 'ad 100 g']);
    final hidrofil = prescriptionOrders[2]; // kitapta 1000 g
    expect([for (final i in hidrofil.ingredients) i.written].take(3), ['25 mg', '15 mg', '1 g']);
    for (final o in prescriptionOrders) {
      // Kapsül ve paket tozda formül kendi sayısıyla yazılır (30 kapsül, 30 paket).
      final counted = o.formula.contains('kapsül') || o.formula.contains('paket');
      final ad = o.ingredients.where((i) => i.written.startsWith('ad ')).map((i) => i.written);
      for (final w in ad) {
        if (!counted) expect(w, anyOf('ad 100 g', 'ad 100 mL'), reason: o.key);
      }
      expect(o.note == null || o.note!.endsWith('numara kapsül'), isTrue, reason: o.key);
    }
  });
}
