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

  test('markette aynı madde iki kez yok', () {
    expect(sold.toSet(), hasLength(sold.length));
  });
}
