import 'prescription.dart';

/// Şablondaki bir madde: miktarı şablonun temel miktarı ([OrderTemplate.base])
/// içindir; reçete başka bir miktar için yazılınca oranla büyür ya da küçülür.
/// [unit] '%' ise yüzde olarak kalır, ölçeklenmez.
class Amount {
  const Amount(this.name, this.qty, this.unit, {this.ad = false});

  final String name;
  final num qty;

  /// 'g', 'mg', 'mL', '%', 'kapsül', 'paket'.
  final String unit;

  /// "ad 100 g": geri kalanı bu maddeyle tamamla.
  final bool ad;
}

/// Bir formülün oyundaki reçete kalıbı; `data/orders.dart`'ta tek reçeteye
/// çevrilir (Tuğrul, 2026-10-29, "her formül tek reçete").
class OrderTemplate {
  const OrderTemplate({
    required this.formula,
    required this.magistralName,
    required this.purpose,
    required this.usedFor,
    required this.branch,
    required this.base,
    required this.unit,
    required this.amounts,
    required this.steps,
    this.capsule,
    this.doctor,
    this.patient,
  });

  /// Formül kitabındaki adı (data/formulary).
  final String formula;
  final String magistralName;
  final String purpose;
  final String usedFor;

  /// Hekimin dalı ("Dermatoloji"); hekim adı bu dalın listesinden seçilir.
  final String branch;

  /// Maddelerin yazıldığı temel miktar ve birimi (100 g, 100 mL, 30 kapsül);
  /// gram ve mL'li formül reçetede 100'e çevrilir.
  final num base;
  final String unit;

  final List<Amount> amounts;
  final List<PrescriptionStep> steps;

  /// Kapsül numarası ("3 numara"); kapsül reçetelerinde not satırına yazılır.
  final String? capsule;

  /// Reçetenin hekimi ve hastası (oyunun ilk reçeteleri hep aynı kalsın).
  final String? doctor;
  final String? patient;
}
