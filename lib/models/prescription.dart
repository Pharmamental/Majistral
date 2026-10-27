/// Laboratuvardaki istasyonlar. Her hazırlık adımı bir istasyonda çalışır;
/// bir istasyon aynı anda tek iş yapar (Tuğrul: "her adımı bir laboratuvar
/// aletine bağlamak").
enum LabStation {
  havan('Havan', 'assets/images/ikon/ikon_havan_porselen.png'),
  karistirma('Merhem taşı', 'assets/images/ikon/ikon_merhem_tasi.png'),
  isitma('Su banyosu', 'assets/images/ikon/ikon_ocak_su_banyosu.png'),
  ambalaj('Ambalaj masası', 'assets/images/ikon/ikon_kavanoz.png');

  const LabStation(this.label, this.imagePath);

  final String label;
  final String imagePath;
}

/// Her hazırlama adımının kendi oyuncak blok ikonu (tools/ikon_blok, "Adımlar").
const stepIcons = {
  'Levigasyon': 'levigasyon',
  'Karıştırma': 'karistirma',
  'Isıtma': 'isitma',
  'Emülsifikasyon': 'emulsifikasyon',
  'Soğuma': 'soguma',
  'Etiket': 'etiket',
};

/// Adım adına göre ikon; kayıttaki eski işlerin adımları da böyle bulunur.
String stepIconPath(String label) => 'assets/images/ikon/ikon_adim_${stepIcons[label] ?? 'karistirma'}.png';

class PrescriptionStep {
  const PrescriptionStep(
    this.label, {
    required this.station,
    required this.minutes,
    this.interactive = false,
  });

  final String label;

  /// Adımın çalıştığı istasyon.
  final LabStation station;

  /// Adımın gerçek zamanlı süresi (dakika). Yer tutucu; kapalı testte ayarlanacak.
  final int minutes;

  /// Süre dolunca iş durur ve oyuncuyu bekler (ısıtmada termometreyi tutmak).
  /// Oyuncu bitirince sonraki adımlar o andan itibaren planlanır.
  final bool interactive;

  String get imagePath => stepIconPath(label);
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

/// Reçetedeki bir satır: madde ve reçetede nasıl yazıldığı ("%5", "1,25 g",
/// "ad 50 g").
class Ingredient {
  const Ingredient(this.name, this.written);

  final String name;
  final String written;
}

class PrescriptionOrder {
  const PrescriptionOrder({
    required this.doctorName,
    required this.doctorBranch,
    required this.patientName,
    required this.magistralName,
    required this.purpose,
    required this.usedFor,
    required this.ingredients,
    required this.steps,
    this.batchNote,
    this.tools = const [],
  });

  /// Reçetedeki maddeler, yazıldığı sırayla.
  final List<Ingredient> ingredients;

  /// Formül başka bir toplam için yazıldıysa ne kadar hazırlanacağı.
  final String? batchNote;

  /// Bu reçetede seçilecek aletler; listede olmayan tür bu reçetede sorulmaz.
  final List<ToolRequirement> tools;

  /// İstasyonlar boşken Başlat'tan teslime kadar geçen süre: adım sürelerinin
  /// toplamı (tasarım belgesi, bölüm 7: küçük 5–15 dk, krem 20–45 dk). İstasyon
  /// doluysa adım sıra bekler, iş daha uzun sürer.
  Duration get prepTime => Duration(minutes: steps.fold(0, (sum, s) => sum + s.minutes));

  /// Unvan ve yalnız ilk ad: "Dr. Deniz" (Tuğrul, 2026-10-27).
  final String doctorName;
  final String doctorBranch;
  final String patientName;
  final String magistralName;
  /// Ne işe yarar (kartta ve reçete penceresinde).
  final String purpose;

  /// Neyde kullanılır (reçete penceresinde).
  final String usedFor;

  /// Doğru sırada verilen adımlar.
  final List<PrescriptionStep> steps;
}
