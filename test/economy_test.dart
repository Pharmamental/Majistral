import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:game/data/economy.dart';
import 'package:game/data/lab_tools.dart';
import 'package:game/data/market_items.dart';
import 'package:game/data/orders.dart';
import 'package:game/data/stations.dart';
import 'package:game/logic/job_store.dart';
import 'package:game/models/garden.dart';
import 'package:game/models/prescription.dart';
import 'package:game/models/shop_item.dart';

import 'test_helpers.dart';

ShopItem _tool(String name) => stations.expand((s) => s.tiers).firstWhere((t) => t.name == name);

void main() {
  final order = prescriptionOrders.first; // %5 SA 100 g: ezme, levigasyon, seyreltme

  group('veri', () {
    test('gram hesabı: yüzde, ad, kapsül; reçete hep 100 g için', () {
      expect(gramsFor(order), {'Salisilik Asit': 5, 'Sıvı Parafin': 3, 'Beyaz Vazelin': 92});
      final hidrofil = gramsFor(prescriptionOrders[2]); // 1000 g formülü 100 g'a çevrilir
      expect(hidrofil['Stearil Alkol'], closeTo(25, 1e-9));
      expect(hidrofil['Metilparaben'], closeTo(0.025, 1e-9));
      final folik = gramsFor(prescriptionOrders[5]); // 30 kapsül
      expect(folik['Folik Asit'], closeTo(0.03, 1e-9));
      expect(folik['Laktoz'], closeTo(30 * 0.2 - 0.03, 1e-9));
    });

    test('hiçbir reçetede eksi miktar yok; her madde paketli ya da bedava', () {
      for (final o in prescriptionOrders) {
        for (final MapEntry(:key, :value) in gramsFor(o).entries) {
          expect(value, greaterThanOrEqualTo(0), reason: '${o.key}: $key');
          expect(packs.containsKey(key) || freeChemicals.contains(key), isTrue, reason: key);
        }
      }
      // Markette her paketli maddenin fiyatı paketin fiyatı.
      for (final g in chemicalGroups) {
        for (final i in g.items) {
          expect(i.price, packs[i.name]?.price ?? 0, reason: i.name);
        }
      }
    });

    test('değişmez kural: en kötü teslim (1★) bile malzemesini öder', () {
      for (final o in prescriptionOrders) {
        final p = payoutFor(o, 1, dailyBonus: false);
        expect(p.coins, greaterThan(p.material), reason: o.key);
        expect(p.material, materialCost(o));
      }
      final p = payoutFor(order, 3, dailyBonus: true, laborBonusPercent: 10);
      expect(p.labor, (3 * laborPerStep * 2 * 1.1).round());
    });
  });

  group('oyunda', () {
    late DateTime clock;
    setUp(() {
      SharedPreferences.setMockInitialValues({});
      clock = DateTime(2026, 10, 29, 9);
    });

    /// Alınmış [o]'nun bütün adımlarını yapar.
    Future<void> prepare(JobStore store, PrescriptionOrder o) async {
      final tools = {for (final t in labTools()) t.name: t};
      for (final s in o.steps) {
        await store.startStep(jobOf(store, o)!.id, tools[s.label]!);
        clock = clock.add(store.stepDuration(s));
      }
    }

    test('başlangıç: kasada 100, rafta her maddeden bir paket; Al malzemeyi düşer', () async {
      final store = await JobStore.load(now: () => clock);
      expect(store.coins, startCoins);
      expect(store.stockOf('Beyaz Vazelin'), 250);
      expect(store.missingCost(order), 0);
      await take(store, order);
      expect(store.stockOf('Beyaz Vazelin'), 158);
      expect(store.stockOf('Salisilik Asit'), 20);
    });

    test('teslim parası: malzeme + emek; günün ilk 3 teslimi emek ×2, 4.sü değil', () async {
      // Yalnız bu reçete döner: duvarda dört kopyası var.
      final store = await JobStore.load(now: () => clock, orders: [order]);
      final material = materialCost(order);
      final paid = <int>[];
      for (var i = 0; i < 4; i++) {
        await take(store, order);
        final before = store.coins;
        await prepare(store, order);
        await store.deliver(jobOf(store, order)!.id);
        paid.add(store.coins - before);
      }
      expect(paid.take(3), everyElement(material + 3 * laborPerStep * 2));
      expect(paid.last, material + 3 * laborPerStep);
      expect(store.lastPayout!.dailyBonus, isFalse);
    });

    test('para yetmezse depo veresiye verir; borç teslimden kesilir', () async {
      SharedPreferences.setMockInitialValues({
        'economy_v1': jsonEncode({'coins': 0, 'debt': 0, 'stock': {}, 'tools': []}),
      });
      final store = await JobStore.load(now: () => clock);
      expect(store.missingCost(order), 30 + 20 + 5); // vazelin, salisilik asit, sıvı parafin paketleri
      await take(store, order); // takılmaz
      expect(store.debt, 55);
      expect(store.coins, 0);
      await prepare(store, order);
      await store.deliver(jobOf(store, order)!.id);
      final pay = store.lastPayout!.coins;
      expect(store.debt, 0);
      expect(store.coins, pay - 55);
    });

    test('yükseltme yalnız kendi adımını kısaltır: değirmen levigasyonu %50, Unguator seyreltmeyi %30', () async {
      SharedPreferences.setMockInitialValues({
        'economy_v1': jsonEncode({'coins': 10000, 'debt': 0, 'stock': {}, 'tools': []}),
      });
      final store = await JobStore.load(now: () => clock);
      final [ezme, levigasyon, seyreltme] = order.steps;
      final eritme = prescriptionOrders[2].steps.first;
      Duration full(PrescriptionStep s) => Duration(minutes: s.minutes);
      expect(store.stepDuration(levigasyon), const Duration(minutes: 3));
      expect(await store.buyTool(_tool('Merhem değirmeni')), isTrue);
      expect(store.coins, 10000 - 4000);
      expect(await store.buyTool(_tool('Merhem değirmeni')), isFalse, reason: 'ikinci kez alınmaz');
      expect(store.stepDuration(levigasyon), const Duration(seconds: 90));
      expect(store.stepDuration(seyreltme), full(seyreltme), reason: 'değirmen seyreltmeye dokunmaz');
      await store.buyTool(_tool('Unguator'));
      expect(store.stepDuration(seyreltme), Duration(seconds: (seyreltme.minutes * 60 * 0.7).round()));
      expect(store.stepDuration(levigasyon), const Duration(seconds: 90));
      await store.buyTool(_tool('Termostatlı su banyosu'));
      expect(store.stepDuration(eritme), const Duration(minutes: 4, seconds: 30));
      expect(store.stepDuration(ezme), full(ezme));
    });

    test('Wedgwood havan Ezme\'yi kısaltır; kart yine tek reçetede çalışır', () async {
      SharedPreferences.setMockInitialValues({
        'economy_v1': jsonEncode({'coins': 2000, 'debt': 0, 'stock': {}, 'tools': []}),
      });
      final store = await JobStore.load(now: () => clock);
      final ezme = labTools().firstWhere((t) => t.name == 'Ezme');
      final pudra = prescriptionOrders[3]; // ezme ile başlar
      await take(store, order);
      await take(store, pudra);
      await store.buyTool(_tool('Wedgwood havan'));
      final step = pudra.steps.first;
      expect(store.stepDuration(step), Duration(seconds: (step.minutes * 60 * 0.7).round()));
      await store.startStep(jobOf(store, order)!.id, ezme);
      expect(store.whyNot(ezme, jobOf(store, pudra)!), startsWith('Bu adım şu an'));
    });

    test('parsel 4-6 sırayla açılır; oyuncu çiçeğini tek tek satar', () async {
      SharedPreferences.setMockInitialValues({
        'economy_v1': jsonEncode({'coins': 5000, 'debt': 0, 'stock': {}, 'tools': []}),
        'garden_v1': jsonEncode(Garden(grown: {'Papatya'}, flowers: {'Mürver': 2}).toJson()),
      });
      final store = await JobStore.load(now: () => clock);
      expect(store.nextParcelPrice, parcelPrices.first);
      expect(await store.buyParcel(), isTrue);
      expect(store.garden.beds, hasLength(Garden.openBeds + 1));
      expect(store.nextParcelPrice, parcelPrices[1]);
      expect(store.coins, 5000 - 800);
      expect(await store.sellFlower('Mürver'), isTrue);
      expect(await store.sellFlower('Mürver'), isTrue);
      expect(await store.sellFlower('Mürver'), isFalse, reason: 'elinde kalmadı');
      expect(store.garden.flowers['Mürver'], 0);
      expect(store.coins, 5000 - 800 + 2 * flowerSellPrices[3]!);
      final reopened = await JobStore.load(now: () => clock);
      expect(reopened.garden.beds, hasLength(Garden.openBeds + 1));
      expect(reopened.coins, store.coins);
    });
  });
}
