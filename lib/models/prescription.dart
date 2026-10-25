import 'package:flutter/material.dart';

class PrescriptionStep {
  const PrescriptionStep(this.label, {this.icon, this.imagePath});

  final String label;
  final IconData? icon;
  final String? imagePath;
}

/// Hazırlamada seçilen alet türleri ve her türün raftaki seçenekleri.
/// Kaynak: ASHP nonsteril majistral bülteni (beyin: majistral-alet-ve-makineler).
enum ToolKind {
  spatula('Spatül', ['Çelik spatül', 'Plastik spatül']),
  mortar('Havan', ['Cam havan', 'Porselen havan', 'Wedgwood havan']),
  surface('Çalışma yüzeyi', ['Merhem taşı', 'Parşömen blok']);

  const ToolKind(this.label, this.options);

  final String label;
  final List<String> options;
}

/// Bir reçetede bir alet türü için uygun seçenekler; yanlış seçilirse [hint]
/// neden yanlış olduğunu anlatır.
class ToolRequirement {
  const ToolRequirement(this.kind, this.allowed, {this.hint});

  final ToolKind kind;
  final Set<String> allowed;
  final String? hint;
}

class PrescriptionOrder {
  const PrescriptionOrder({
    required this.doctorName,
    required this.doctorBranch,
    required this.patientName,
    required this.magistralName,
    required this.purpose,
    required this.chemicals,
    required this.distractors,
    required this.steps,
    required this.sequenceHint,
    required this.prepTime,
    this.tools = const [],
  });

  /// Bu reçetede seçilecek aletler; listede olmayan tür bu reçetede sorulmaz.
  final List<ToolRequirement> tools;

  /// Başlat'tan teslime kadar gerçek zamanda geçen süre (tasarım belgesi,
  /// bölüm 7: küçük 5–15 dk, krem 20–45 dk). Kapalı testte ayarlanacak.
  final Duration prepTime;

  final String doctorName;
  final String doctorBranch;
  final String patientName;
  final String magistralName;
  final String purpose;
  final List<String> chemicals;

  /// Rafta reçetedekilerle karışık duran, bu reçetede olmayan kimyasallar.
  final List<String> distractors;

  /// Doğru sırada verilen adımlar.
  final List<PrescriptionStep> steps;

  /// Sıra yanlışsa ürüne ne olduğunu anlatan tek cümle.
  final String sequenceHint;
}
