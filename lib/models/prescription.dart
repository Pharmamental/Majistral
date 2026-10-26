import 'package:flutter/material.dart';

/// Laboratuvardaki istasyonlar. Her hazırlık adımı bir istasyonda çalışır;
/// bir istasyon aynı anda tek iş yapar (Tuğrul: "her adımı bir laboratuvar
/// aletine bağlamak").
enum LabStation {
  terazi('Terazi', 'assets/images/ikon/ikon_terazi_kefeli.png'),
  havan('Havan', 'assets/images/ikon/ikon_havan_porselen.png'),
  karistirma('Merhem taşı', 'assets/images/ikon/ikon_merhem_tasi.png'),
  isitma('Su banyosu', 'assets/images/ikon/ikon_ocak_su_banyosu.png'),
  ambalaj('Ambalaj masası', 'assets/images/ikon/ikon_kavanoz.png');

  const LabStation(this.label, this.imagePath);

  final String label;
  final String imagePath;
}

class PrescriptionStep {
  const PrescriptionStep(
    this.label, {
    required this.station,
    required this.minutes,
    this.interactive = false,
    this.icon,
    this.imagePath,
  });

  final String label;

  /// Adımın çalıştığı istasyon.
  final LabStation station;

  /// Adımın gerçek zamanlı süresi (dakika). Yer tutucu; kapalı testte ayarlanacak.
  final int minutes;

  /// Süre dolunca iş durur ve oyuncuyu bekler (ısıtmada termometreyi tutmak);
  /// süresi 0 olan adımda (tartım) iş adıma gelir gelmez bekler. Oyuncu
  /// bitirince sonraki adımlar o andan itibaren planlanır.
  final bool interactive;
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

/// Reçetedeki bir satır: madde, reçetede nasıl yazıldığı ("%5", "1,25 g",
/// "ad 50 g") ve terazide tartılacak doğru miktar.
class Ingredient {
  const Ingredient(this.name, this.written, this.grams);

  final String name;
  final String written;
  final double grams;
}

class PrescriptionOrder {
  const PrescriptionOrder({
    required this.doctorName,
    required this.doctorBranch,
    required this.patientName,
    required this.magistralName,
    required this.purpose,
    required this.ingredients,
    required this.calcHint,
    required this.distractors,
    required this.steps,
    required this.sequenceHint,
    this.batchNote,
    this.tools = const [],
  });

  /// Reçetedeki maddeler, yazıldığı sırayla.
  final List<Ingredient> ingredients;

  /// Tartım yanlışsa hesabın nasıl yapıldığını anlatan kısa açıklama.
  final String calcHint;

  /// Formül başka bir toplam için yazıldıysa ne kadar hazırlanacağı.
  final String? batchNote;

  List<String> get chemicals => [for (final i in ingredients) i.name];

  /// Hazırlanacak toplam miktar (g).
  double get totalGrams => ingredients.fold(0, (sum, i) => sum + i.grams);

  /// Bu reçetede seçilecek aletler; listede olmayan tür bu reçetede sorulmaz.
  final List<ToolRequirement> tools;

  /// İstasyonlar boşken Başlat'tan teslime kadar geçen süre: adım sürelerinin
  /// toplamı (tasarım belgesi, bölüm 7: küçük 5–15 dk, krem 20–45 dk). İstasyon
  /// doluysa adım sıra bekler, iş daha uzun sürer.
  Duration get prepTime => Duration(minutes: steps.fold(0, (sum, s) => sum + s.minutes));

  final String doctorName;
  final String doctorBranch;
  final String patientName;
  final String magistralName;
  final String purpose;

  /// Rafta reçetedekilerle karışık duran, bu reçetede olmayan kimyasallar.
  final List<String> distractors;

  /// Doğru sırada verilen adımlar.
  final List<PrescriptionStep> steps;

  /// Sıra yanlışsa ürüne ne olduğunu anlatan tek cümle.
  final String sequenceHint;
}
