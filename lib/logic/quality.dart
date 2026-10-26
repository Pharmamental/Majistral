import '../models/prescription.dart';

/// Bir hazırlığın sonucu: 1–3 yıldız ve oyuncuya gösterilecek açıklamalar.
class PreparationResult {
  const PreparationResult({required this.stars, required this.notes});

  final int stars;
  final List<String> notes;
}

/// Tasarım belgesi bölüm 5: her hata türü bir yıldız götürür, en düşük kalite
/// 1 yıldızdır ve ürün her zaman satılır. Başlat'ta bakılan hata türleri: yanlış
/// alet (kaç alet yanlış olursa olsun tek yıldız) ve yanlış adım sırası.
/// Kimyasal seçimi yok (Tuğrul, 2026-10-26): maddeler reçeteden gelir.
PreparationResult evaluatePreparation({
  required PrescriptionOrder order,
  required List<String> stepOrder,
  Map<ToolKind, String> selectedTools = const {},
}) {
  final notes = <String>[];
  var stars = 3;

  final wrongTools = [
    for (final req in order.tools)
      if (!req.allowed.contains(selectedTools[req.kind])) req,
  ];
  if (wrongTools.isNotEmpty) {
    stars--;
    for (final req in wrongTools) {
      notes.add(req.hint ?? '${req.kind.label}: ${req.allowed.join(' ya da ')} kullanılmalıydı.');
    }
  }

  final correctOrder = [for (final s in order.steps) s.label];
  if (!_sameOrder(stepOrder, correctOrder)) {
    stars--;
    notes.add(order.sequenceHint);
    notes.add('Doğru sıra: ${correctOrder.join(' › ')}.');
  }

  return PreparationResult(stars: stars < 1 ? 1 : stars, notes: notes);
}

bool _sameOrder(List<String> a, List<String> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

/// Tartımda kabul edilen sapma: doğru miktarın %5'i. Oyun kararı; yuvarlamaya
/// izin verir ama "ad"ı unutmak (%8 fazla) ya da 10 kat hatayı yakalar.
const weighTolerance = 0.05;

/// [weighed] maddesi doğru miktarın kabul aralığında mı?
bool weighedRight(Ingredient ingredient, double? weighed) =>
    weighed != null && (weighed - ingredient.grams).abs() <= ingredient.grams * weighTolerance;

/// Tartım hatalıysa teslimde gösterilecek açıklamalar; doğruysa boş. Hata,
/// kaç madde yanlış olursa olsun tek yıldız götürür (tasarım belgesi, bölüm 5).
List<String> evaluateWeighing(PrescriptionOrder order, Map<String, double?> weighed) {
  final wrong = [
    for (final i in order.ingredients)
      if (!weighedRight(i, weighed[i.name])) i,
  ];
  if (wrong.isEmpty) return const [];
  return [
    for (final i in wrong)
      'Tartım: ${i.name} ${formatGrams(weighed[i.name])} g tartıldı, doğrusu ${formatGrams(i.grams)} g.',
    order.calcHint,
  ];
}

/// Gramı Türkçe yazar: 46.25 → "46,25", 12.0 → "12", 0.025 → "0,025".
String formatGrams(double? grams) {
  if (grams == null) return '—';
  var text = grams.toStringAsFixed(3);
  text = text.replaceFirst(RegExp(r'\.?0+$'), '');
  return text.replaceAll('.', ',');
}

/// Oyuncunun yazdığı sayıyı okur; virgül de nokta da olur.
double? parseGrams(String text) => double.tryParse(text.trim().replaceAll(',', '.'));
