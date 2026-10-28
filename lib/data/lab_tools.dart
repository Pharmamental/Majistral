import '../models/prescription.dart';
import '../models/shop_item.dart';
import 'stations.dart';

/// Laboratuvarda duran, oyuncunun basıp reçete seçtiği alet. Her alet aynı
/// anda tek reçetede çalışır.
class LabTool {
  const LabTool({required this.name, required this.imagePath, required this.kind});

  final String name;
  final String imagePath;
  final StepTool kind;
}

/// Satın alma henüz yok: ücretsiz kademeler sahip olunan aletler.
bool isOwned(ShopItem item) => item.price == 0;

List<ShopItem> _owned(String group, bool Function(ShopItem) owns) =>
    stations.firstWhere((s) => s.name == group).tiers.where(owns).toList();

/// Laboratuvardaki aletler (Tuğrul, 2026-10-27). Havanlar ve spatüller farklı
/// işlerin aletleri, sahip olunan her biri ayrı durur. Kademeli gruplarda
/// yalnız sahip olunan en yüksek kademe çalışır. Merhem taşında spatülle
/// karıştırılır; Unguator ya da değirmen alınınca karıştırma o makineye geçer,
/// spatül gerekmez.
List<LabTool> labTools({bool Function(ShopItem item) owns = isOwned}) {
  LabTool tool(ShopItem i, StepTool kind) => LabTool(name: i.name, imagePath: i.imagePath!, kind: kind);
  final mixers = _owned('Merhem karıştırma', owns);
  return [
    for (final i in _owned('Havanlar', owns)) tool(i, StepTool.havan),
    if (mixers.length == 1)
      for (final i in _owned('Spatüller', owns)) tool(i, StepTool.karistirma)
    else
      tool(mixers.last, StepTool.karistirma),
    tool(_owned('Isıtma', owns).last, StepTool.isitma),
    for (final i in _owned('Kaplar', owns)) tool(i, StepTool.kapsul),
    // Formül kitabının en sık adımları (2026-10-28).
    for (final i in _owned('Cam eşya', owns))
      tool(i, i.name == 'Mezür' ? StepTool.mezur : StepTool.beher),
    for (final i in _owned('Toz aletleri', owns))
      tool(i, i.name == 'Elek' ? StepTool.elek : StepTool.kapsulAleti),
  ];
}
