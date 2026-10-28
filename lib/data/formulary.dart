import '../models/formula.dart';
import 'formulary/cozelti.dart';
import 'formulary/jel.dart';
import 'formulary/krem.dart';
import 'formulary/merhem.dart';
import 'formulary/suspansiyon.dart';
import 'formulary/toz.dart';
import 'references.dart';

// Formül kitabı (2026-10-28): altı kategoride majistral formülleri. Kırmızı,
// yeşil, turuncu ve mor reçeteli ilaçlar, hormonlar, kortikosteroidler ve
// tehlikeli (NIOSH listesindeki) ilaçlar bilerek dışarıda. Her formül en az iki
// kaynağa dayanır; yayından önce öğretim üyesi/eczacı onayından geçecek
// (AGENTS.md). Metinler kaynaklardan kopyalanmadı, kendi sözlerimizle yazıldı.

const List<Formula> formulary = [
  ...merhemFormulas,
  ...kremFormulas,
  ...jelFormulas,
  ...cozeltiFormulas,
  ...suspansiyonFormulas,
  ...tozFormulas,
];

/// Bütün kaynaklar: ortak liste ve kategori dosyalarının ekleri.
const List<Reference> allReferences = [
  ...coreReferences,
  ...merhemRefs,
  ...kremRefs,
  ...jelRefs,
  ...cozeltiRefs,
  ...suspansiyonRefs,
  ...tozRefs,
];

/// Kimliğe göre kaynak.
final Map<String, Reference> referenceById = {for (final r in allReferences) r.id: r};

/// Kategorinin formülleri.
List<Formula> formulasOf(FormulaCategory c) => [for (final f in formulary) if (f.category == c) f];

/// Kaynağın kaç formülde kullanıldığı.
int citationCount(String id) => formulary.where((f) => f.refs.contains(id)).length;

/// Adımların formül kitabında kaç kez geçtiği, çoktan aza (laboratuvara hangi
/// adımların gireceği buna göre seçildi).
List<MapEntry<String, int>> stepUsage() {
  final counts = <String, int>{};
  for (final f in formulary) {
    for (final s in f.steps) {
      counts[s.name] = (counts[s.name] ?? 0) + 1;
    }
  }
  return counts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
}
