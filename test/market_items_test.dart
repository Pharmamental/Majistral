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

  // Tuğrul, 2026-10-28: "30-40 civarı madde, her madde en az 10 reçetede,
  // 500 civarı reçete".
  test('markette 30-40 madde var, her biri en az 10 reçetede geçiyor', () {
    expect(sold.length, inInclusiveRange(30, 40));
    for (final name in sold) {
      final n = prescriptionOrders.where((o) => o.ingredients.any((i) => i.name == name)).length;
      expect(n, greaterThanOrEqualTo(10), reason: name);
    }
  });

  test('yaklaşık 500 reçete; kimlikler tek, ilk altısı elle yazılanlar', () {
    expect(prescriptionOrders.length, inInclusiveRange(480, 520));
    final keys = [for (final o in prescriptionOrders) o.key];
    expect(keys.toSet(), hasLength(keys.length));
    expect(prescriptionOrders.first.key, '%5 Salisilik Asitli Vazelin');
    expect([for (final i in prescriptionOrders.first.ingredients) i.written], ['%5', '1,5 g', 'ad 50 g']);
    // Aynı formül duvarda arka arkaya gelmez.
    for (var i = 1; i < prescriptionOrders.length; i++) {
      expect(prescriptionOrders[i].formula, isNot(prescriptionOrders[i - 1].formula), reason: '$i');
    }
  });

  test('hâller miktarı oranla yazar ya da notta söyler', () {
    final zno = prescriptionOrders.where((o) => o.magistralName == 'Çinko oksit patı %25 (USP)').toList();
    expect(zno.length, greaterThanOrEqualTo(7));
    // İlk hâl 100 g, ikincisi 50 g: miktarlar yarıya iner.
    expect([for (final i in zno[1].ingredients) i.written], ['12,5 g', '12,5 g', '25 g']);
    // Üçüncü hâl formülü 100 g için yazar, 30 g'ı notta söyler.
    expect(zno[2].batchNote, 'Formül 100 g için yazılmış; sen 30 g hazırla.');
    expect([for (final i in zno[2].ingredients) i.written], ['25 g', '25 g', '50 g']);
  });
}
