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

  Bed copyWith({DateTime? readyAt}) => Bed(plant: plant, plantedAt: plantedAt, readyAt: readyAt ?? this.readyAt);

  Map<String, Object> toJson() =>
      {'plant': plant, 'at': plantedAt.millisecondsSinceEpoch, 'ready': readyAt.millisecondsSinceEpoch};

  factory Bed.fromJson(Map<String, dynamic> json) => Bed(
        plant: json['plant'] as String,
        plantedAt: DateTime.fromMillisecondsSinceEpoch(json['at'] as int),
        readyAt: DateTime.fromMillisecondsSinceEpoch(json['ready'] as int),
      );
}

/// Teslimde düşen tohum: hangi bitki, ve bitki zaten varsa gübreye döndü mü.
typedef SeedDrop = ({String plant, bool fertilizer});

/// Tıbbi bitki bahçesi (Tuğrul, 2026-10-29, "A"):
/// - Her teslimde bir tohum düşer: grup eşit şansla, kademe sık %50, iki orta
///   %20'şer, nadir %10. 10 teslim üst üste nadir çıkmazsa 11.'de kesin nadir.
/// - Bir bitkinin tek tohumu yeter. Zaten elde olan (tohumu, parselde ya da
///   yetiştirilmiş) bitkinin tohumu boşa gitmez, gübre olur.
/// - Gübre büyüyen bir parselin kalan süresini yarıya indirir.
/// - Bitki gerçek zamanda büyür, olgunlaşınca bozulmaz, hasat edilene kadar
///   parselde bekler; hasat edilince vitrine konabilir ([grown]).
class Garden {
  Garden({
    Map<String, int>? seeds,
    List<Bed?>? beds,
    Set<String>? grown,
    this.sinceRare = 0,
    this.fertilizer = 0,
  })  : seeds = seeds ?? {},
        beds = beds ?? List.filled(openBeds, null),
        grown = grown ?? {};

  /// Açık parsel sayısı ve bahçedeki toplam parsel (kalanı kilitli).
  static const openBeds = 3;
  static const allBeds = 6;

  /// Nadir tohum en geç bu kadar teslimden sonra kesin gelir.
  static const pity = 10;

  final Map<String, int> seeds;
  final List<Bed?> beds;

  /// Hasat edilmiş, vitrine konabilen bitkiler.
  final Set<String> grown;

  /// Son nadir tohumdan beri teslim sayısı.
  int sinceRare;
  int fertilizer;

  /// Nadir tohumun en geç kaç teslim sonra geleceği (1 = bir sonraki).
  int get rareWithin => pity + 1 - sinceRare;

  /// Bitki elde mi: tohumu duruyor, parselde ya da yetiştirilmiş.
  bool has(String plant) => (seeds[plant] ?? 0) > 0 || grown.contains(plant) || beds.any((b) => b?.plant == plant);

  /// Teslimde tohum düşürür.
  SeedDrop dropSeed(math.Random rnd) {
    final group = PlantGroup.values[rnd.nextInt(PlantGroup.values.length)];
    final inGroup = [for (final p in driedPlants) if (p.group == group) p];
    final roll = rnd.nextDouble();
    final tier = sinceRare >= pity ? 3 : (roll < 0.5 ? 1 : roll < 0.9 ? 2 : 3);
    final choices = [for (final p in inGroup) if (p.tier == tier) p];
    final plant = choices[rnd.nextInt(choices.length)].name;
    sinceRare = tier == 3 ? 0 : sinceRare + 1;
    if (has(plant)) {
      fertilizer++;
      return (plant: plant, fertilizer: true);
    }
    seeds[plant] = 1;
    return (plant: plant, fertilizer: false);
  }

  /// [bed]. parsele [plant] tohumunu eker; bahçe hızı ([speedPercent]) süreyi kısaltır.
  bool plant(int bed, String plant, DateTime now, {int speedPercent = 0}) {
    final p = driedPlantNamed(plant);
    if (p == null || beds[bed] != null || (seeds[plant] ?? 0) < 1) return false;
    seeds[plant] = seeds[plant]! - 1;
    if (seeds[plant] == 0) seeds.remove(plant);
    final grow = p.growTime * (1 - speedPercent / 100);
    beds[bed] = Bed(plant: plant, plantedAt: now, readyAt: now.add(grow));
    return true;
  }

  /// Büyüyen parsele gübre verir: kalan süre yarıya iner.
  bool feed(int bed, DateTime now) {
    final b = beds[bed];
    if (b == null || b.readyBy(now) || fertilizer < 1) return false;
    fertilizer--;
    beds[bed] = b.copyWith(readyAt: now.add(b.readyAt.difference(now) ~/ 2));
    return true;
  }

  /// Olgun bitkiyi hasat eder; vitrine konabilir olur. Olgun değilse null.
  String? harvest(int bed, DateTime now) {
    final b = beds[bed];
    if (b == null || !b.readyBy(now)) return null;
    beds[bed] = null;
    grown.add(b.plant);
    return b.plant;
  }

  Map<String, Object> toJson() => {
        'seeds': seeds,
        'beds': [for (final b in beds) b?.toJson()],
        'grown': grown.toList(),
        'sinceRare': sinceRare,
        'fertilizer': fertilizer,
      };

  factory Garden.fromJson(Map<String, dynamic> json) {
    final beds = <Bed?>[
      for (final b in json['beds'] as List) b == null ? null : Bed.fromJson(b as Map<String, dynamic>),
    ];
    return Garden(
      seeds: {
        for (final e in (json['seeds'] as Map<String, dynamic>).entries)
          if (driedPlantNamed(e.key) != null) e.key: e.value as int,
      },
      beds: [for (var i = 0; i < openBeds; i++) i < beds.length ? beds[i] : null],
      grown: {for (final g in json['grown'] as List) if (driedPlantNamed(g as String) != null) g},
      sinceRare: json['sinceRare'] as int,
      fertilizer: json['fertilizer'] as int,
    );
  }
}
