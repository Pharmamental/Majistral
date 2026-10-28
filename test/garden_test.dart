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
    expect(driedPlantNamed('Papatya')!.effectText, 'duvara reçete yeri +1');
    expect(driedPlantNamed('Mürver')!.effectText, 'duvara reçete yeri +2');
    expect(driedPlantNamed('Ihlamur')!.effectText, 'duvara reçete yeri +1');
    expect(driedPlantNamed('Gelincik')!.effectText, 'günde 3 acele kaliteyi düşürmez');
    expect(driedPlantNamed('Sarı kantaron')!.effectText, 'teslim emeği +%15');
  });

  test('tohum olasılıkları: sık %50, orta %40, nadir %10', () {
    final rnd = math.Random(1);
    final count = {1: 0, 2: 0, 3: 0};
    const n = 20000;
    for (var i = 0; i < n; i++) {
      final drop = Garden().dropSeed(rnd); // her seferinde yeni bahçe: garanti devreye girmez
      count[driedPlantNamed(drop.plant)!.tier] = count[driedPlantNamed(drop.plant)!.tier]! + 1;
    }
    expect(count[1]! / n, closeTo(0.5, 0.02));
    expect(count[2]! / n, closeTo(0.4, 0.02));
    expect(count[3]! / n, closeTo(0.1, 0.01));
  });

  test('10 teslimde nadir çıkmazsa 11.de kesin nadir; fazla tohum gübre olur', () {
    final garden = Garden();
    final rnd = _Fixed(0); // hep sık kademe, hep ilk grup (Papatya)
    expect(garden.rareWithin, 11);
    final first = garden.dropSeed(rnd);
    expect(first, (plant: 'Papatya', fertilizer: false));
    for (var i = 0; i < 9; i++) {
      expect(garden.dropSeed(rnd).fertilizer, isTrue); // Papatya zaten elde
    }
    expect(garden.fertilizer, 9);
    expect(garden.rareWithin, 1);
    final rare = garden.dropSeed(rnd);
    expect(driedPlantNamed(rare.plant)!.tier, 3);
    expect(rare.plant, 'Mürver');
    expect(garden.rareWithin, 11);
  });

  test('ek, gübre ver, hasat et; bahçe hızı süreyi kısaltır; kayıttan geri okunur', () {
    final garden = Garden(seeds: {'Ihlamur': 1, 'Papatya': 1}, fertilizer: 1);
    expect(garden.plant(0, 'Ihlamur', at), isTrue);
    expect(garden.plant(0, 'Papatya', at), isFalse, reason: 'parsel dolu');
    expect(garden.beds[0]!.readyAt, at.add(const Duration(hours: 6)));
    expect(garden.harvest(0, at.add(const Duration(hours: 1))), isNull, reason: 'olgun değil');
    // Gübre kalan süreyi yarıya indirir: 1. saatte kalan 5 saat → 2,5 saat.
    final t = at.add(const Duration(hours: 1));
    expect(garden.feed(0, t), isTrue);
    expect(garden.beds[0]!.readyAt, t.add(const Duration(hours: 2, minutes: 30)));
    expect(garden.feed(0, t), isFalse, reason: 'gübre bitti');
    // %30 bahçe hızıyla Papatya 2 saat yerine 1 sa 24 dk.
    expect(garden.plant(1, 'Papatya', at, speedPercent: 30), isTrue);
    expect(garden.beds[1]!.readyAt, at.add(const Duration(hours: 1, minutes: 24)));

    final copy = Garden.fromJson(jsonDecode(jsonEncode(garden.toJson())) as Map<String, dynamic>);
    expect(copy.beds[0]!.readyAt, garden.beds[0]!.readyAt);
    expect(copy.seeds, isEmpty);

    expect(garden.harvest(0, at.add(const Duration(hours: 4))), 'Ihlamur');
    expect(garden.grown, {'Ihlamur'});
    expect(garden.beds[0], isNull);
  });

  group('oyunda', () {
    late DateTime clock;
    setUp(() => clock = at);

    test('her teslim tohum getirir ve kaydedilir', () async {
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
      expect(store.lastDrop, (plant: 'Papatya', fertilizer: false));
      final reopened = await JobStore.load(now: () => clock);
      expect(reopened.garden.seeds, {'Papatya': 1});
      expect(reopened.garden.sinceRare, 1);
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
