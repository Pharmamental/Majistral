import '../models/prescription.dart';
import '../models/shop_item.dart';
import 'orders.dart';
import 'stations.dart';

/// Laboratuvardaki bir adım kartı (Tuğrul, 2026-10-28): reçetedeki her adımın
/// laboratuvarda aynı adlı bir kartı vardır. Oyuncu karta basıp reçeteyi
/// seçer; kart aynı anda tek reçetede çalışır.
class LabTool {
  const LabTool({required this.name, required this.imagePath, required this.equipment});

  /// Adımın adı ("Geometrik seyreltme").
  final String name;

  /// Adımın ikonu.
  final String imagePath;

  /// Adımı yapan aletler ("Porselen havan · Merhem taşı ve spatül").
  final String equipment;
}

/// Koleksiyon şimdilik tam görünür (Tuğrul, 2026-10-28, "unlocked bir şey olmasın").
/// Aletler ekonomiyle (2026-10-29) satın alınır, vitrin bahçeyle (2026-10-29)
/// açılır; bu bayrak artık yalnız koleksiyonu açar.
const unlockAll = true;

/// Mağazasız varsayılan: yalnız ücretsiz kademeler elde. Oyunda sahiplik
/// `JobStore.ownsTool`'dan gelir.
bool isOwned(ShopItem item) => item.price == 0;

/// Alet türünün ücretsiz, basit hâli.
String equipmentName(StepTool kind) => switch (kind) {
  StepTool.havan => 'Porselen havan',
  StepTool.karistirma => 'Merhem taşı ve spatül',
  StepTool.isitma => 'Ocak ve su banyosu',
  StepTool.kapsul => 'Porselen kapsül',
  StepTool.beher => 'Beher ve baget',
  StepTool.mezur => 'Mezür',
  StepTool.elek => 'Elek',
  StepTool.kapsulAleti => 'Kapsül doldurma aleti',
};

/// Adımın satın alınmış en iyi aleti; yoksa null (basit aletlerle yapılır).
ShopItem? upgradeFor(String step, {bool Function(ShopItem item) owns = isOwned}) {
  final bought = stationFor(step)?.tiers.where((t) => t.price > 0 && owns(t));
  return bought == null || bought.isEmpty ? null : bought.last;
}

/// Laboratuvarın adım kartları: reçetelerde geçen her adım adı bir kez, ilk
/// geçtiği sırayla. Kart adımı yapan basit aletleri yazar; adımın marketteki
/// yükseltmesi alınınca onu. Kart reçetelerden türediği için reçetede olup
/// laboratuvarda olmayan adım kalmaz.
List<LabTool> labTools({
  bool Function(ShopItem item) owns = isOwned,
  List<PrescriptionOrder>? orders,
}) {
  final kinds = <String, Set<StepTool>>{};
  for (final o in orders ?? prescriptionOrders) {
    for (final s in o.steps) {
      kinds.putIfAbsent(s.label, () => {}).addAll({s.tool, ...s.orWith});
    }
  }
  return [
    for (final MapEntry(key: name, value: k) in kinds.entries)
      LabTool(
        name: name,
        imagePath: stepIconPath(name),
        equipment: upgradeFor(name, owns: owns)?.name ?? {for (final kind in k) equipmentName(kind)}.join(' · '),
      ),
  ];
}
