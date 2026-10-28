/// Bitkinin eczanedeki kullanım grubu ve vitrindeyken verdiği oyun etkisi
/// (Tuğrul, 2026-10-29). Gruplar bitkilerin gerçek kullanımından; etkiler
/// eczanenin oyun etkisi, bitkinin ilacı değil (ekranda "oyun etkisi" yazar).
enum PlantGroup {
  cay('Çaylar', 'duvara reçete yeri'),
  bogaz('Boğaz ve öksürük', 'günlük acele hakkı'),
  cilt('Cilt ve yara', 'teslim parası'),
  ferah('Ferahlatıcı', 'bahçe hızı');

  const PlantGroup(this.title, this.effect);

  final String title;
  final String effect;
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

  /// Kademe: 1 sık, 2 orta, 3 nadir. Etkinin gücü ve büyüme süresi buna bağlı.
  final int tier;

  /// Bahçede olgunlaşınca çiçeğinin ya da yaprağının rengi.
  final int color;

  String get imagePath => 'assets/images/ikon/ikon_fanus_$file.png';

  /// Vitrindeki etkisinin büyüklüğü: duvar ve acele için adet (1-3), para ve
  /// bahçe hızı için yüzde (para 5/10/15, bahçe 10/20/30).
  int get bonus => switch (group) {
        PlantGroup.cay || PlantGroup.bogaz => tier,
        PlantGroup.cilt => tier * 5,
        PlantGroup.ferah => tier * 10,
      };

  /// Etkinin kısa yazısı: "duvara reçete yeri +2", "teslim parası %10".
  String get effectText => switch (group) {
        PlantGroup.cay || PlantGroup.bogaz => '${group.effect} +$bonus',
        PlantGroup.cilt || PlantGroup.ferah => '${group.effect} +%$bonus',
      };

  /// Bahçedeki büyüme süresi (oyun süresi, gerçek büyüme değil; 2026-10-29).
  Duration get growTime => const [Duration(hours: 2), Duration(hours: 6), Duration(hours: 12)][tier - 1];
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

DriedPlant? driedPlantNamed(String name) {
  for (final p in driedPlants) {
    if (p.name == name) return p;
  }
  return null;
}
