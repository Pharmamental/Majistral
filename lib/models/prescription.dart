/// Bir adımın hangi tür aletle yapıldığı. Laboratuvarda kartlar adımdır
/// (Tuğrul, 2026-10-28); alet türü adım kartında "neyle yapılır" diye yazar
/// (data/lab_tools.dart). Beher, mezür, elek ve kapsül doldurma aleti formül
/// kitabının en sık adımları için eklendi (2026-10-28).
enum StepTool { havan, karistirma, isitma, kapsul, beher, mezur, elek, kapsulAleti }

/// Her hazırlama adımının kendi oyuncak blok ikonu (tools/ikon_blok, "Adımlar").
/// Adım, eczacının madde üzerinde eliyle, bir aletle ya da bir yöntemle yaptığı
/// işlemdir (ezme, eritme, çözme, soğutma); malzeme ("su fazı") ya da kontrol,
/// etiket gibi yan işler adım değildir (Tuğrul, 2026-10-28).
const stepIcons = {
  'Ezme': 'ezme',
  'Levigasyon': 'levigasyon',
  'Geometrik seyreltme': 'karistirma',
  'Eritme': 'eritme',
  'Çözme': 'cozme',
  'Emülsifikasyon': 'emulsifikasyon',
  'Soğutma': 'sogutma',
  // Formül kitabındaki öteki adımlar (2026-10-28). Karıştırma beherde bagetle.
  'Karıştırma': 'karistirma_sivi',
  'Elekten geçirme': 'elek',
  'Şişirme': 'sisirme',
  'Nötralleştirme': 'notrallestirme',
  'Süzme': 'suzme',
  'Hacme tamamlama': 'hacim',
  'Kapsül doldurma': 'kapsul_doldurma',
};

/// Adım adına göre ikon; kayıttaki eski işlerin adımları da böyle bulunur.
String stepIconPath(String label) => 'assets/images/ikon/ikon_adim_${stepIcons[label] ?? 'karistirma'}.png';

class PrescriptionStep {
  const PrescriptionStep(
    this.label, {
    required this.tool,
    required this.minutes,
    this.interactive = false,
    this.notWith = const {},
    this.orWith = const {},
  });

  final String label;

  /// Adımı yapan alet türü.
  final StepTool tool;

  /// Adımı aynı doğrulukla yapan başka alet türleri (levigasyon: havan ya da
  /// merhem taşında spatül; Tuğrul, 2026-10-28). Adım kartında yazar.
  final Set<StepTool> orWith;

  /// Adımın gerçek zamanlı süresi (dakika). Yer tutucu; kapalı testte ayarlanacak.
  final int minutes;

  /// Süre başlamadan önce oyuncu mini oyunu oynar (ısıtmada termometreyi
  /// tutmak); süre ancak oyun bitince başlar.
  final bool interactive;

  /// Bu adımda kullanılmaması gereken aletler ve nedeni (alet adı → neden).
  /// Laboratuvar adım kartına geçince (2026-10-28) seçim değil, adımı
  /// başlatırken gösterilen uyarı.
  final Map<String, String> notWith;

  String get imagePath => stepIconPath(label);
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
  });

  /// Reçetedeki maddeler, yazıldığı sırayla.
  final List<Ingredient> ingredients;

  /// Formül başka bir toplam için yazıldıysa ne kadar hazırlanacağı.
  final String? batchNote;

  /// Adım sürelerinin toplamı (tasarım belgesi, bölüm 7: küçük 5–15 dk, krem
  /// 20–45 dk). Her adımı oyuncu başlattığı için iş arada beklerse uzar.
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
