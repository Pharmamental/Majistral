import '../models/prescription.dart';

/// Bir hazırlığın sonucu: 1–3 yıldız ve oyuncuya gösterilecek açıklamalar.
class PreparationResult {
  const PreparationResult({required this.stars, required this.notes});

  final int stars;
  final List<String> notes;
}

/// Tasarım belgesi bölüm 5: her hata türü bir yıldız götürür, en düşük kalite
/// 1 yıldızdır ve ürün her zaman satılır. Hata türleri: eksik kimyasal,
/// reçetede olmayan kimyasal, yanlış alet (kaç alet yanlış olursa olsun tek
/// yıldız), yanlış adım sırası.
PreparationResult evaluatePreparation({
  required PrescriptionOrder order,
  required Set<String> selectedChemicals,
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

  final missing = order.chemicals.where((c) => !selectedChemicals.contains(c)).toList();
  if (missing.isNotEmpty) {
    stars--;
    notes.add('Eksik kimyasal: ${missing.join(', ')}.');
  }

  final extra = selectedChemicals.where((c) => !order.chemicals.contains(c)).toList();
  if (extra.isNotEmpty) {
    stars--;
    notes.add('Reçetede olmayan kimyasal kullandın: ${extra.join(', ')}.');
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
