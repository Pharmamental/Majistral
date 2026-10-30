import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:game/data/dried_plants.dart';
import 'package:game/data/lab_tools.dart';
import 'package:game/data/orders.dart';
import 'package:game/logic/job_store.dart';
import 'package:game/models/garden.dart';

import 'test_helpers.dart';

/// Hep aynı sayıyı veren zar: kademe zarı 0 → hep sık tohum.
class _Fixed implements math.Random {
  _Fixed(this.value);
  final double value;
  @override
  double nextDouble() => value;
  @override
  int nextInt(int max) => 0;
  @override
  bool nextBool() => false;
}

void main() {
  final at = DateTime(2026, 10, 29, 9);

  // Tuğrul, 2026-10-29: her grupta bir sık, iki orta, bir nadir bitki.
  test('her grupta kademeler 1, 2, 2, 3; etkiler yazılı', () {
    for (final g in PlantGroup.values) {
      final tiers = [for (final p in driedPlants) if (p.group == g) p.tier]..sort();
      expect(tiers, [1, 2, 2, 3], reason: g.title);
    }
    expect(driedPlantNamed('Papatya')!.effectText, 'Duvarda 1 reçete daha birikir');
    expect(driedPlantNamed('Mürver')!.effectText, 'Duvarda 2 reçete daha birikir');
    expect(driedPlantNamed('Adaçayı')!.effectText, 'Günün ilk acelesi kaliteyi düşürmez');
    expect(driedPlantNamed('Gelincik')!.effectText, 'Günün ilk 3 acelesi kaliteyi düşürmez');
    expect(driedPlantNamed('Sarı kantaron')!.effectText, 'Teslimde emek parası %15 artar');
    expect(driedPlantNamed('Nane')!.effectText, "Teslimlerin %55'i tohum getirir");
    expect(driedPlantNamed('Biberiye')!.effectText, "Teslimlerin %60'ı tohum getirir");
    expect(driedPlantNamed('Ekinezya')!.effectText, "Teslimlerin %65'i tohum getirir");
  });

  // Tuğrul, 2026-10-30, "okey A": ferahlatıcı fanus tohum şansını artırır.
  test('ferahlatıcı fanusla tohum şansı yükselir', () {
    expect(Garden().dropSeed(_Fixed(0.6)), isNull);
    expect(Garden().dropSeed(_Fixed(0.6), bonusPercent: 15), isNotNull);
    expect(Garden().dropSeed(_Fixed(0.66), bonusPercent: 15), isNull);
  });

  // Tuğrul, 2026-10-29: teslimlerin %50'si tohum; ağırlıklar tür başına sık 60,
  // orta 27,5, nadir 12,5 ("Yüzdeler tür başına olsun").
  test('tohum olasılıkları: yarı yarıya tohum; tek orta bitki tek nadirin iki katı sık', () {
    final rnd = math.Random(1);
    final garden = Garden();
    var none = 0;
    const n = 40000;
    for (var i = 0; i < n; i++) {
      if (garden.dropSeed(rnd) == null) none++;
    }
    final drops = n - none;
    double share(String plant) => garden.seeds[plant]! / drops;
    expect(none / n, closeTo(0.5, 0.01));
    expect(share('Papatya'), closeTo(60 / 510, 0.01));
    expect(share('Ihlamur'), closeTo(27.5 / 510, 0.007));
    expect(share('Mürver'), closeTo(12.5 / 510, 0.005));
    // Gruplar: sık ~%47, orta ~%43, nadir ~%10.
    int tierTotal(int tier) => [for (final p in driedPlants) if (p.tier == tier) garden.seeds[p.name] ?? 0]
        .fold(0, (a, b) => a + b);
    expect(tierTotal(3) / drops, closeTo(50 / 510, 0.01));
  });

  test('tohumlar birikir; zar tutmazsa tohum yok', () {
    final garden = Garden();
    expect(garden.dropSeed(_Fixed(0.6)), isNull);
    for (var i = 0; i < 3; i++) {
      expect(garden.dropSeed(_Fixed(0)), 'Papatya');
    }
    expect(garden.seeds, {'Papatya': 3});
  });

  test('hasat ve fanus bedeli kademeye göre: sıradan 1 ve 3, orta 2 ve 4, nadir 3 ve 5', () {
    for (final (name, yieldOf, cost) in [('Papatya', 1, 3), ('Ihlamur', 2, 4), ('Mürver', 3, 5)]) {
      final p = driedPlantNamed(name)!;
      expect((p.harvestYield, p.fanusCost), (yieldOf, cost), reason: name);
    }
  });

  test('ek, hasat et: orta bitki iki çiçek verir, 4 çiçek fanusunu açar; kayıttan geri okunur', () {
    final garden = Garden(seeds: {'Ihlamur': 2, 'Papatya': 1}, flowers: {'Ihlamur': 1});
    expect(garden.plant(0, 'Ihlamur', at), isTrue);
    expect(garden.seeds['Ihlamur'], 1);
    expect(garden.plant(0, 'Papatya', at), isFalse, reason: 'parsel dolu');
    expect(garden.beds[0]!.readyAt, at.add(const Duration(hours: 6)));
    expect(garden.harvest(0, at.add(const Duration(hours: 1))), isNull, reason: 'olgun değil');
    expect(garden.plant(1, 'Papatya', at), isTrue);
    expect(garden.beds[1]!.readyAt, at.add(const Duration(hours: 2)));

    final copy = Garden.fromJson(jsonDecode(jsonEncode(garden.toJson())) as Map<String, dynamic>);
    expect(copy.beds[0]!.readyAt, garden.beds[0]!.readyAt);
    expect(copy.seeds, {'Ihlamur': 1});
    expect(copy.flowers, {'Ihlamur': 1});

    expect(garden.harvest(0, at.add(const Duration(hours: 6))), 'Ihlamur');
    expect(garden.flowers['Ihlamur'], 3);
    expect(garden.canShow('Ihlamur'), isFalse);
    expect(garden.openFanus('Ihlamur'), isFalse, reason: '3 çiçek yetmez');
    expect(garden.plant(0, 'Ihlamur', at), isTrue);
    expect(garden.harvest(0, at.add(const Duration(hours: 6))), 'Ihlamur');
    expect(garden.canShow('Ihlamur'), isTrue);
    expect(garden.openFanus('Ihlamur'), isTrue);
    expect(garden.flowers['Ihlamur'], 1);
    expect(garden.grown, {'Ihlamur'});
    expect(garden.openFanus('Ihlamur'), isTrue, reason: 'açık fanus yeniden çiçek harcamaz');
    expect(garden.flowers['Ihlamur'], 1);
  });

  test('eski kayıt (gübre, nadir sayacı) okunur, o alanlar atlanır', () {
    final old = Garden.fromJson({
      'seeds': {'Papatya': 1},
      'beds': [null, null, null],
      'grown': ['Mürver'],
      'sinceRare': 4,
      'fertilizer': 2,
    });
    expect(old.seeds, {'Papatya': 1});
    expect(old.flowers, isEmpty);
    expect(old.grown, {'Mürver'});
  });

  group('oyunda', () {
    late DateTime clock;
    setUp(() => clock = at);

    test('teslim tohum getirir (zar tutunca) ve kaydedilir', () async {
      SharedPreferences.setMockInitialValues({});
      final store = await JobStore.load(now: () => clock, random: _Fixed(0));
      final order = prescriptionOrders.first;
      final tools = {for (final t in labTools()) t.name: t};
      await take(store, order);
      for (final s in order.steps) {
        await store.startStep(jobOf(store, order)!.id, tools[s.label]!);
        clock = clock.add(Duration(minutes: s.minutes));
      }
      await store.deliver(jobOf(store, order)!.id);
      expect(store.lastDrop, 'Papatya');
      final reopened = await JobStore.load(now: () => clock);
      expect(reopened.garden.seeds, {'Papatya': 1});
    });

    test('vitrine yeni Papatya fanusu 3 çiçekle konur', () async {
      SharedPreferences.setMockInitialValues({
        'economy_v1': jsonEncode({'coins': 1000, 'debt': 0, 'stock': {}, 'tools': []}),
        'garden_v1': jsonEncode(Garden(flowers: {'Papatya': 2}).toJson()),
      });
      final store = await JobStore.load(now: () => clock);
      await store.setShowcase(0, 'Papatya');
      expect(store.showcase[0], isNull, reason: '2 çiçek yetmez');
      store.garden.flowers['Papatya'] = 3;
      await store.setShowcase(0, 'Papatya');
      expect(store.showcase[0], 'Papatya');
      expect(store.garden.flowers['Papatya'], 0);
      // Raftan kaldırıp yeniden koymak çiçek harcamaz.
      await store.setShowcase(0, null);
      await store.setShowcase(1, 'Papatya');
      expect(store.showcase[1], 'Papatya');
      final reopened = await JobStore.load(now: () => clock);
      expect(reopened.garden.grown, contains('Papatya'));
      expect(reopened.garden.flowers['Papatya'], 0);
    });

    test('vitrin etkileri: Mürver duvarı 6 yapar, Gelincik 3 aceleyi korur; aynı grup toplanmaz', () async {
      SharedPreferences.setMockInitialValues({
        'garden_v1': jsonEncode(Garden(grown: {'Mürver', 'Papatya', 'Gelincik'}).toJson()),
      });
      final store = await JobStore.load(now: () => clock);
      expect(store.wallLimit, JobStore.wallSize);
      expect(store.wall, hasLength(JobStore.wallSize));
      await store.setShowcase(0, 'Papatya');
      await store.setShowcase(1, 'Mürver');
      await store.setShowcase(2, 'Gelincik');
      expect(store.wallLimit, JobStore.wallSize + 2, reason: 'en güçlü çay fanusu sayılır, +1 ile +2 toplanmaz');
      expect(store.rushLimit, JobStore.dailyRushes, reason: 'acele hakkı artmaz');
      expect(store.protectedRushesLeft, 3);
      // Duvar artık 6'ya kadar dolar.
      clock = clock.add(JobStore.arrivalEvery * 10);
      expect(store.wall, hasLength(JobStore.wallSize + 2));
    });

    test('Gelincik vitrindeyken ilk 3 acele yıldız düşürmez, 4.sü düşürür', () async {
      SharedPreferences.setMockInitialValues({
        'garden_v1': jsonEncode(Garden(grown: {'Gelincik'}).toJson()),
        'profile_v1': jsonEncode({'showcase': ['Gelincik', null, null]}),
      });
      final store = await JobStore.load(now: () => clock);
      final order = prescriptionOrders[2]; // hidrofil: 4 adım
      final tools = {for (final t in labTools()) t.name: t};
      await take(store, order);
      final id = jobOf(store, order)!.id;
      for (final s in order.steps) {
        await store.startStep(id, tools[s.label]!);
        await store.rush(id);
      }
      expect(store.job(id)!.stars, 2, reason: '3 korundu, 4. acele 3 → 2');
    });
  });
}
