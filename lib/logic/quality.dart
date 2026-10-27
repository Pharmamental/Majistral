import '../models/prescription.dart';

/// Bir hazırlığın sonucu: 1–3 yıldız ve oyuncuya gösterilecek açıklamalar.
class PreparationResult {
  const PreparationResult({required this.stars, required this.notes});

  final int stars;
  final List<String> notes;
}

/// Tasarım belgesi bölüm 5: her hata türü bir yıldız götürür, en düşük kalite
/// 1 yıldızdır ve ürün her zaman satılır. Başlat'ta bakılan tek hata türü yanlış
/// alet (kaç alet yanlış olursa olsun tek yıldız). Kimyasal seçimi (Tuğrul,
/// 2026-10-26) ve adım sırası (2026-10-27) oyuncuya sorulmaz.
PreparationResult evaluatePreparation({
  required PrescriptionOrder order,
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

  return PreparationResult(stars: stars, notes: notes);
}
