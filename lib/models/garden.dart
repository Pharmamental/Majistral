import 'dart:math' as math;

import '../data/dried_plants.dart';

/// Bahçedeki bir parsel: hangi bitki ekildi, ne zaman olgunlaşır.
class Bed {
  const Bed({required this.plant, required this.plantedAt, required this.readyAt});

  final String plant;
  final DateTime plantedAt;
  final DateTime readyAt;

  bool readyBy(DateTime at) => !at.isBefore(readyAt);

  /// 0–1 arası büyüme.
  double progressAt(DateTime at) {
    final total = readyAt.difference(plantedAt).inMilliseconds;
    if (total <= 0) return 1;
    return (at.difference(plantedAt).inMilliseconds / total).clamp(0, 1);
  }

  Map<String, Object> toJson() =>
      {'plant': plant, 'at': plantedAt.millisecondsSinceEpoch, 'ready': readyAt.millisecondsSinceEpoch};

  factory Bed.fromJson(Map<String, dynamic> json) => Bed(
        plant: json['plant'] as String,
        plantedAt: DateTime.fromMillisecondsSinceEpoch(json['at'] as int),
        readyAt: DateTime.fromMillisecondsSinceEpoch(json['ready'] as int),
      );
}

/// Tıbbi bitki bahçesi (Tuğrul, 2026-10-29, "her teslimde zar atılır"):
/// - Teslim edilen reçetenin yarısı bir tohum getirir ([dropChance]). Tür
///   kademesine göre seçilir; ağırlıklar tür başına (sık 60, orta 27,5, nadir
///   12,5), böylece tek bir orta bitki bir nadirin iki katı sık gelir.
/// - Tohumlar birikir. Ekilen tohum gerçek zamanda büyür, olgunlaşınca bozulmaz;
///   hasatta kademesi kadar kurutulmuş çiçek verir ([DriedPlant.harvestYield]).
/// - Bir bitkinin fanusu o bitkiden 3-5 çiçekle açılır ([DriedPlant.fanusCost]); açılan fanus kalıcıdır
///   ve vitrine konabilir ([grown]). Çiçek markette tek tek de satılır.
class Garden {
  Garden({
    Map<String, int>? seeds,
    Map<String, int>? flowers,
    List<Bed?>? beds,
    Set<String>? grown,
    this.harvested = 0,
  })  : seeds = seeds ?? {},
        flowers = flowers ?? {},
        beds = beds ?? List<Bed?>.filled(openBeds, null, growable: true),
        grown = grown ?? {};

  /// Başta açık parsel sayısı ve bahçedeki toplam parsel; 4-6 parayla açılır
  /// (`JobStore.buyParcel`). [beds]'in uzunluğu açık parsel sayısıdır.
  static const openBeds = 3;
  static const allBeds = 6;

  /// Teslimin tohum getirme şansı.
  static const dropChance = 0.5;

  /// Tek bir türün ağırlığı, kademesine göre.
  static const tierWeights = {1: 60.0, 2: 27.5, 3: 12.5};

  final Map<String, int> seeds;

  /// Hasat edilmiş ya da satın alınmış, henüz fanusa girmemiş çiçekler.
  final Map<String, int> flowers;
  final List<Bed?> beds;

  /// Fanusu açılmış, vitrine konabilen bitkiler.
  final Set<String> grown;

  /// Bugüne dek hasat edilen çiçek sayısı (istatistik).
  int harvested;

  /// Teslimde zar atar: yarı ihtimalle bir tohum düşer, adı döner; yoksa null.
  /// Vitrindeki ferahlatıcı fanus şansı [bonusPercent] kadar artırır (%30 artış %65 eder).
  String? dropSeed(math.Random rnd, {int bonusPercent = 0}) {
    if (rnd.nextDouble() >= dropChance * (1 + bonusPercent / 100)) return null;
    final total = driedPlants.fold(0.0, (sum, p) => sum + tierWeights[p.tier]!);
    var roll = rnd.nextDouble() * total;
    var plant = driedPlants.last.name;
    for (final p in driedPlants) {
      roll -= tierWeights[p.tier]!;
      if (roll < 0) {
        plant = p.name;
        break;
      }
    }
    seeds[plant] = (seeds[plant] ?? 0) + 1;
    return plant;
  }

  /// [plant]'ın fanusu açık mı ya da açacak kadar çiçek birikti mi.
  bool canShow(String plant) {
    final p = driedPlantNamed(plant);
    return grown.contains(plant) || (p != null && (flowers[plant] ?? 0) >= p.fanusCost);
  }

  /// [plant]'ın fanusunu açar: açıksa bir şey harcamaz, değilse fanus bedeli kadar çiçek harcar.
  bool openFanus(String plant) {
    if (grown.contains(plant)) return true;
    if (!canShow(plant)) return false;
    flowers[plant] = flowers[plant]! - driedPlantNamed(plant)!.fanusCost;
    grown.add(plant);
    return true;
  }

  /// [bed]. parsele [plant] tohumunu eker.
  bool plant(int bed, String plant, DateTime now) {
    final p = driedPlantNamed(plant);
    if (p == null || beds[bed] != null || (seeds[plant] ?? 0) < 1) return false;
    seeds[plant] = seeds[plant]! - 1;
    if (seeds[plant] == 0) seeds.remove(plant);
    beds[bed] = Bed(plant: plant, plantedAt: now, readyAt: now.add(p.growTime));
    return true;
  }

  /// Olgun bitkiyi hasat eder: kademesi kadar çiçek verir. Olgun değilse null.
  String? harvest(int bed, DateTime now) {
    final b = beds[bed];
    if (b == null || !b.readyBy(now)) return null;
    beds[bed] = null;
    final yield_ = driedPlantNamed(b.plant)?.harvestYield ?? 1;
    flowers[b.plant] = (flowers[b.plant] ?? 0) + yield_;
    harvested += yield_;
    return b.plant;
  }

  Map<String, Object> toJson() => {
        'seeds': seeds,
        'flowers': flowers,
        'beds': [for (final b in beds) b?.toJson()],
        'grown': grown.toList(),
        'harvested': harvested,
      };

  factory Garden.fromJson(Map<String, dynamic> json) {
    final beds = <Bed?>[
      for (final b in json['beds'] as List) b == null ? null : Bed.fromJson(b as Map<String, dynamic>),
    ];
    Map<String, int> counts(Object? raw) => {
          for (final e in ((raw as Map<String, dynamic>?) ?? {}).entries)
            if (driedPlantNamed(e.key) != null) e.key: e.value as int,
        };
    // Eski kayıttaki gübre ve nadir sayacı (2026-10-29 öncesi) okunmaz.
    return Garden(
      seeds: counts(json['seeds']),
      flowers: counts(json['flowers']),
      beds: [
        for (var i = 0; i < math.max(openBeds, math.min(beds.length, allBeds)); i++) i < beds.length ? beds[i] : null,
      ],
      grown: {for (final g in json['grown'] as List) if (driedPlantNamed(g as String) != null) g},
      harvested: json['harvested'] as int? ?? 0,
    );
  }
}
