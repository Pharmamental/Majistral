/// Bitkinin eczanedeki kullanım grubu ve vitrindeyken verdiği oyun etkisi
/// (Tuğrul, 2026-10-29). Gruplar bitkilerin gerçek kullanımından; etkiler
/// eczanenin oyun etkisi, bitkinin ilacı değil.
enum PlantGroup {
  cay('Çaylar'),
  bogaz('Boğaz ve öksürük'),
  cilt('Cilt ve yara'),
  ferah('Ferahlatıcı');

  const PlantGroup(this.title);

  final String title;

  /// Etkinin cümlesi (Tuğrul, 2026-10-29: "+1" gibi kısaltma yok, düz cümle):
  /// "Duvarda 2 reçete daha birikir", "Günün ilk 2 acelesi kaliteyi düşürmez".
  String effectText(int bonus) => switch (this) {
        cay => 'Duvarda $bonus reçete daha birikir',
        bogaz => bonus == 1 ? 'Günün ilk acelesi kaliteyi düşürmez' : 'Günün ilk $bonus acelesi kaliteyi düşürmez',
        cilt => 'Teslimde emek parası %$bonus artar',
        ferah => 'Teslimlerin %${_accusative(50 + bonus)} tohum getirir',
      };
}

/// Vitrin rafındaki fanuslar (Tuğrul, 2026-10-28, "ilaç koymak çok iyi değil"):
/// ceviz tabanlı cam fanusta kurutulmuş tıbbi bitki. İkonlar
/// tools/ikon_blok/uretici.html "Vitrin" grubunda. Bahçede yetiştirilip hasat
/// edilince vitrine konabilir (2026-10-29).
class DriedPlant {
  const DriedPlant(this.name, this.latin, this.use, this.file, this.group, this.tier, this.color);

  final String name;
  final String latin;

  /// Eczanede neyde kullanıldığı, tek satır.
  final String use;
  final String file;
  final PlantGroup group;

  /// Kademe: 1 sıradan, 2 orta, 3 nadir. Etkinin gücü ve büyüme süresi buna bağlı.
  final int tier;

  /// Bahçede olgunlaşınca çiçeğinin ya da yaprağının rengi.
  final int color;

  String get imagePath => 'assets/images/ikon/ikon_fanus_$file.png';

  /// Vitrindeki etkisinin büyüklüğü. Ekonomi hesabından sonra (2026-10-29,
  /// "önerilerle"): çay duvara +1/+1/+2 (az oynayanın teslimini %14-27 artırır;
  /// +3 %34 ile fazla güçlüydü); boğaz günde 1/2/3 acelenin kalite düşürmemesi
  /// (acele hakkı artırmak para kaybettirdiği için değersizdi); cilt emeğe
  /// %5/10/15; ferah teslimin tohum şansına 5/10/15 puan (Tuğrul, 2026-10-30,
  /// "okey A"; bahçe hızı boşa gidiyordu, darboğaz parsel değil tohum).
  int get bonus => switch (group) {
        PlantGroup.cay => tier == 3 ? 2 : 1,
        PlantGroup.bogaz => tier,
        PlantGroup.cilt => tier * 5,
        PlantGroup.ferah => tier * 5,
      };

  String get effectText => group.effectText(bonus);

  /// Bahçedeki büyüme süresi (oyun süresi, gerçek büyüme değil; 2026-10-29).
  Duration get growTime => const [Duration(hours: 2), Duration(hours: 6), Duration(hours: 12)][tier - 1];

  /// Hasatta verdiği çiçek ve fanusunun bedeli (Tuğrul, 2026-10-30, "Evet,
  /// uygula"): sıradan 1 çiçek verir, fanusu 3 ister; orta 2 ve 4; nadir 3 ve 5.
  /// Uzun büyüyen daha çok verir; düzenli oyuncu ilk fanusu ~2, Mürver'i ~23,
  /// bütün vitrini ~45 günde açar (eskiden 8, 63, 97).
  int get harvestYield => tier;
  int get fanusCost => tier + 2;
}

const driedPlants = <DriedPlant>[
  DriedPlant('Papatya', 'Matricaria chamomilla', 'Yatıştırıcı çay, cilt bakımı', 'papatya', PlantGroup.cay, 1, 0xFFF4E9A8),
  DriedPlant('Lavanta', 'Lavandula angustifolia', 'Yağı merhem ve kremlerde', 'lavanta', PlantGroup.cilt, 2, 0xFF9C86C9),
  DriedPlant('Nane', 'Mentha × piperita', 'Mentol, ferahlatıcı', 'nane', PlantGroup.ferah, 1, 0xFF6FA26A),
  DriedPlant('Adaçayı', 'Salvia officinalis', 'Gargara, ağız bakımı', 'adacayi', PlantGroup.bogaz, 1, 0xFFA7B79A),
  DriedPlant('Aynısefa', 'Calendula officinalis', 'Yara merhemi', 'aynisefa', PlantGroup.cilt, 1, 0xFFF0A13A),
  DriedPlant('Kekik', 'Thymus vulgaris', 'Öksürük şurubu', 'kekik', PlantGroup.bogaz, 2, 0xFFC9A3C4),
  DriedPlant('Biberiye', 'Rosmarinus officinalis', 'Kas ve eklem yağı', 'biberiye', PlantGroup.ferah, 2, 0xFF9DB6D8),
  DriedPlant('Ihlamur', 'Tilia platyphyllos', 'Soğuk algınlığı çayı', 'ihlamur', PlantGroup.cay, 2, 0xFFE8C95A),
  DriedPlant('Rezene', 'Foeniculum vulgare', 'Gaz giderici çay', 'rezene', PlantGroup.cay, 2, 0xFFE2C243),
  DriedPlant('Ekinezya', 'Echinacea purpurea', 'Bağışıklık', 'ekinezya', PlantGroup.ferah, 3, 0xFFD98AA8),
  DriedPlant('Sarı kantaron', 'Hypericum perforatum', 'Kantaron yağı, yara', 'kantaron', PlantGroup.cilt, 3, 0xFFF2C230),
  DriedPlant('Hatmi', 'Althaea officinalis', 'Öksürük, boğaz', 'hatmi', PlantGroup.bogaz, 2, 0xFFF1C6D0),
  DriedPlant('Gelincik', 'Papaver rhoeas', 'Eski öksürük şurupları', 'gelincik', PlantGroup.bogaz, 3, 0xFFC9473A),
  DriedPlant('Defne', 'Laurus nobilis', 'Defne yağı, saç ve cilt', 'defne', PlantGroup.cilt, 2, 0xFF5F7F4E),
  DriedPlant('Okaliptüs', 'Eucalyptus globulus', 'Nefes açıcı buhar', 'okaliptus', PlantGroup.ferah, 2, 0xFF9DB7B4),
  DriedPlant('Mürver', 'Sambucus nigra', 'Mürver şurubu', 'murver', PlantGroup.cay, 3, 0xFF4A3555),
];

/// Sayıya belirtme eki: "55'i", "60'ı". Ek sayının okunuşunun son hecesinden gelir.
String _accusative(int n) {
  const ones = ['', "'i", "'yi", "'ü", "'ü", "'i", "'yı", "'yi", "'i", "'u"];
  const tens = ['', "'u", "'yi", "'u", "'ı", "'yi", "'ı", "'i", "'i", "'ı"];
  return '$n${n % 10 != 0 ? ones[n % 10] : tens[n ~/ 10 % 10]}';
}

DriedPlant? driedPlantNamed(String name) {
  for (final p in driedPlants) {
    if (p.name == name) return p;
  }
  return null;
}
