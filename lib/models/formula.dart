import 'prescription.dart';

/// Formül kitabındaki kategoriler: farmasötik şekle göre (USP <1151>
/// "Pharmaceutical Dosage Forms" ve Avrupa Farmakopesi'nin şekil
/// monograflarından sadeleştirildi; ayrıntı data/references.dart).
enum FormulaCategory {
  merhem('Merhem ve patlar', 'Susuz, yağlı yarı katılar; çok toz içeren hâli pat (macun).'),
  krem('Kremler', 'Yağ ve suyun emülgatörle birleştiği yarı katılar.'),
  jel('Jeller', 'Suyun ya da sıvının jel yapıcıyla kıvam aldığı yarı katılar.'),
  cozelti('Çözeltiler', 'Maddelerin sıvıda tamamen çözündüğü berrak sıvılar: şurup, gargara, damla, losyon.'),
  suspansiyon('Süspansiyonlar', 'Çözünmeyen tozun sıvıda dağıldığı, çalkalanarak kullanılan sıvılar.'),
  toz('Tozlar ve kapsüller', 'Karıştırılmış tozlar: pudra, paket toz ve kapsül.');

  const FormulaCategory(this.title, this.definition);

  final String title;
  final String definition;
}

/// Formül kitabındaki adım: eczacının madde üzerinde yaptığı işlem (adı
/// [formulaStepNames] içinden) ve o formülde nasıl yapıldığı.
class FormulaStep {
  const FormulaStep(this.name, this.how);

  final String name;
  final String how;
}

/// Formül kitabında kullanılan adım adları. Adım, eczacının madde üzerinde
/// eliyle, aletle ya da yöntemle yaptığı işlemdir; tartım, kontrol, etiket ve
/// ambalaj adım sayılmaz (Tuğrul, 2026-10-28).
const formulaStepNames = [
  'Ezme',
  'Elekten geçirme',
  'Levigasyon',
  'Geometrik seyreltme',
  'Karıştırma',
  'Eritme',
  'Çözme',
  'Emülsifikasyon',
  'Soğutma',
  'Şişirme',
  'Nötralleştirme',
  'Süzme',
  'Hacme tamamlama',
  'Kapsül doldurma',
];

/// Bir majistral formülü: ne işe yarar, hangi maddeler, nasıl yapılır.
class Formula {
  const Formula({
    required this.name,
    required this.category,
    required this.use,
    required this.ingredients,
    required this.steps,
    required this.refs,
  });

  final String name;
  final FormulaCategory category;

  /// Ne işe yarar.
  final String use;

  /// Hangi maddeler, reçetede yazıldığı gibi.
  final List<Ingredient> ingredients;

  /// Nasıl yapılır, sırasıyla.
  final List<FormulaStep> steps;

  /// Formülün dayandığı kaynakların kimlikleri (data/references.dart).
  final List<String> refs;
}
