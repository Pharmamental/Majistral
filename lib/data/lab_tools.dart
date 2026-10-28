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

/// Şimdilik her şey açık (Tuğrul, 2026-10-28, "unlocked bir şey olmasın"): market
/// aletlerinin hepsi elde, koleksiyon tam, vitrine her ürün konur. Satın alma ve
/// kazanma kuralları gelince false yapılır.
const unlockAll = true;

/// Satın alma henüz yok: ücretsiz kademeler sahip olunan aletler.
bool isOwned(ShopItem item) => unlockAll || item.price == 0;

List<ShopItem> _owned(String group, bool Function(ShopItem) owns) =>
    stations.firstWhere((s) => s.name == group).tiers.where(owns).toList();

/// Alet türünün laboratuvardaki adı. Kademeli gruplarda sahip olunan en
/// yükseği: merhem taşında spatülle karıştırılır, Unguator ya da değirmen
/// alınınca karıştırma o makineye geçer.
String equipmentName(StepTool kind, {bool Function(ShopItem item) owns = isOwned}) {
  final mixers = _owned('Merhem karıştırma', owns);
  return switch (kind) {
    StepTool.havan => 'Porselen havan',
    StepTool.karistirma => mixers.length == 1 ? 'Merhem taşı ve spatül' : mixers.last.name,
    StepTool.isitma => _owned('Isıtma', owns).last.name,
    StepTool.kapsul => 'Porselen kapsül',
    StepTool.beher => 'Beher ve baget',
    StepTool.mezur => 'Mezür',
    StepTool.elek => 'Elek',
    StepTool.kapsulAleti => 'Kapsül doldurma aleti',
  };
}

/// Laboratuvarın adım kartları: reçetelerde geçen her adım adı bir kez, ilk
/// geçtiği sırayla. Kart reçetelerden türediği için reçetede olup
/// laboratuvarda olmayan adım kalmaz.
List<LabTool> labTools({
  bool Function(ShopItem item) owns = isOwned,
  List<PrescriptionOrder> orders = prescriptionOrders,
}) {
  final kinds = <String, Set<StepTool>>{};
  for (final o in orders) {
    for (final s in o.steps) {
      kinds.putIfAbsent(s.label, () => {}).addAll({s.tool, ...s.orWith});
    }
  }
  return [
    for (final MapEntry(key: name, value: k) in kinds.entries)
      LabTool(
        name: name,
        imagePath: stepIconPath(name),
        equipment: {for (final kind in k) equipmentName(kind, owns: owns)}.join(' · '),
      ),
  ];
}
