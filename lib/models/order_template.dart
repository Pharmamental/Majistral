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

/// Bir formülün oyundaki reçete kalıbı (Tuğrul, 2026-10-28, "500 civarı
/// reçete"): aynı formül farklı miktar, farklı hekim ve hastayla birkaç kez
/// reçete edilir. Her hâl [batches]'teki bir miktardır; hâller
/// `data/orders.dart`'ta reçeteye çevrilir.
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
    required this.batches,
    this.capsule,
    this.alwaysNote = false,
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

  /// Maddelerin yazıldığı temel miktar ve birimi (100 g, 100 mL, 30 kapsül).
  final num base;
  final String unit;

  final List<Amount> amounts;
  final List<PrescriptionStep> steps;

  /// Her hâlin hazırlanacak miktarı; ilki temel hâl.
  final List<num> batches;

  /// Kapsül numarası ("3 numara"); kapsül reçetelerinde not satırına yazılır.
  final String? capsule;

  /// Formül hep temel miktarıyla yazılır, hazırlanacak miktar notta
  /// söylenir (hidrofil merhem 1000 g formülü).
  final bool alwaysNote;

  /// İlk hâlin hekimi ve hastası (oyunun ilk reçeteleri hep aynı kalsın).
  final String? doctor;
  final String? patient;
}
