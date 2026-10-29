import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:game/data/economy.dart';
import 'package:game/data/orders.dart';
import 'package:game/logic/job_store.dart';

void main() {
  var clock = DateTime(2026, 10, 29, 9);
  setUp(() {
    clock = DateTime(2026, 10, 29, 9);
    SharedPreferences.setMockInitialValues({});
  });

  // Kural (Tuğrul, 2026-10-29): madde, onu isteyen ilk reçete duvara gelince açılır.
  test('henüz reçetesi gelmemiş kimyasal kilitli; reçete gelince açılır ve kayıtta kalır', () async {
    final store = await JobStore.load(now: () => clock);
    final onWall = {
      for (final w in store.wall)
        ...prescriptionOrders.firstWhere((o) => o.key == w.orderKey).ingredients.map((i) => i.name),
    };
    for (final c in onWall) {
      expect(store.chemicalUnlocked(c), isTrue, reason: c);
    }
    // Duvardakilerde geçmeyen, sonra gelen bir reçetenin maddesi.
    final later = prescriptionOrders.indexWhere((o) => o.ingredients.any((i) => !onWall.contains(i.name)));
    final chemical = prescriptionOrders[later].ingredients.firstWhere((i) => !onWall.contains(i.name)).name;
    expect(store.chemicalUnlocked(chemical), isFalse);

    // Duvar boşaltılıp reçeteler sırayla gelince madde açılır.
    while (!store.chemicalUnlocked(chemical)) {
      await store.accept(store.wall.first);
      clock = clock.add(JobStore.arrivalEvery);
      store.wall;
    }
    final reloaded = await JobStore.load(now: () => clock);
    expect(reloaded.chemicalUnlocked(chemical), isTrue);
  });

  test('kilit kaydından önceki oyun: gelmiş reçetelerin maddeleri açık', () async {
    SharedPreferences.setMockInitialValues({
      'wall_v1': jsonEncode({'wall': [], 'nextId': 2, 'due': clock.millisecondsSinceEpoch + 3600000}),
    });
    final store = await JobStore.load(now: () => clock);
    for (final i in prescriptionOrders[1].ingredients) {
      expect(store.chemicalUnlocked(i.name), isTrue, reason: i.name);
    }
  });

  test('rafta paket sayısı: açılmış paket de bir paket', () async {
    final store = await JobStore.load(now: () => clock);
    expect(store.packsOf('Beyaz Vazelin'), 1); // ilk açılışta her maddeden bir paket
    await store.buyPack('Beyaz Vazelin');
    expect(store.packsOf('Beyaz Vazelin'), 2);
    final vazelin = packs['Beyaz Vazelin']!.grams;
    SharedPreferences.setMockInitialValues({
      'economy_v1': jsonEncode({
        'coins': 0,
        'debt': 0,
        'stock': {'Beyaz Vazelin': vazelin * 2 + 0.5},
        'tools': [],
      }),
    });
    expect((await JobStore.load(now: () => clock)).packsOf('Beyaz Vazelin'), 3);
    expect(store.packsOf('Distile Su'), 0);
  });
}
